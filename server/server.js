const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');
require('dotenv').config();
const { Pool } = require('pg');
const bcrypt = require('bcrypt'); 
const { body, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const { authenticateToken } = require('./jwt_token');

// PostgreSQL database connection
const pool = new Pool({
  user: 'postgres',  //superusername
  host: 'localhost',  //default
  database: 'flutter',
  password: 'password',  //password when you installed the Postgre DB
  port: 5433,
});

const app = express();
const PORT = 3000;
 
// Enable CORS for all routes
app.use(cors());
app.use(bodyParser.json());

pool.connect()
  .then(() => console.log('Connected to PostgreSQL'))
  .catch(err => console.error('Connection error', err.stack));

// Environment variables for JWT secret
const JWT_SECRET = process.env.JWT_SECRET || 'your_jwt_secret';
// Route for user sign-up
app.post(
  '/signup',
  [
    body('name').notEmpty().withMessage('Name is required'),
    body('email')
      .matches(/^[a-zA-Z0-9._%+-]+@gmail\.com$/)
      .withMessage('Only Gmail addresses are allowed'),
    body('password')
      .isLength({ min: 5 })
      .withMessage('Password must be at least 5 characters long'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password } = req.body;

    try {
      // Check if user already exists
      const userExists = await pool.query('SELECT * FROM Users WHERE email = $1', [email]);
      if (userExists.rows.length > 0) {
        return res.status(400).json({ message: 'Email already in use.' });
      }

      // Hash password before saving
      const hashedPassword = await bcrypt.hash(password, 10);

      // Insert user into the database
      const newUser = await pool.query(
        'INSERT INTO Users (name, email, password) VALUES ($1, $2, $3) RETURNING *',
        [name, email, hashedPassword]
      );

      res.status(201).json({ message: 'User registered successfully', user: newUser.rows[0] });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error' });
    }
  }
);

// Login route
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try { 
    // Step 1: Check if the email exists in the database
    const query = 'SELECT * FROM users WHERE email = $1';
    const result = await pool.query(query, [email]);

    if (result.rows.length === 0) {
      return res.status(400).json({ message: 'Email not found' });
    }

    // Step 2: Validate the email format
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ message: 'Invalid email format' });
    }

    const user = result.rows[0];
    // Step 3: Compare the password with the stored hashed password
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Step 4: Generate JWT token
    const token = jwt.sign(
      { userId: user.id, email: user.email },
      JWT_SECRET,
    );

    // Step 5: Send response with token and user_id
    res.status(200).json({
      message: 'Login successful',
      token,
      user_id: user.id,
    });
  } catch (err) {
    console.error('Error during login', err);
    res.status(500).json({ message: 'Server error' });
  }
});


// Create a Nodemailer transporter using Gmail
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
  tls: {
    rejectUnauthorized: false, 
  }, 
});   

// Password reset route
app.post('/send-reset-link', async (req, res) => {
  const { email } = req.body;

  // Check if email is valid
  if (!email || !email.includes('@gmail.com')) {
    return res.status(400).json({ message: 'Invalid email address' });
  }

  try {
    // Check if email exists in the database
    const result = await  pool.query('SELECT * FROM users WHERE email = $1', [email]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'We cannot find your email, re-check your email!!!' });
    }

    // Email exists, proceed to send reset link
    const resetUrl = `http://localhost:63847/reset-password?email=${email}`; 
    
    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: email,
      subject: 'Password Reset Request',
      text: `You requested a password reset. Click the link below to reset your password:\n\n${resetUrl}`,
    }; 

    // Send email
    await transporter.sendMail(mailOptions);

    return res.status(200).json({ message: 'Password reset link sent!' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Error sending email', error: error.message });
  }
});

// Route to reset password (this is just a placeholder)
app.post('/reset-password', async (req, res) => {
  const { email, newPassword } = req.body;

  if (!newPassword || newPassword.length < 5) {
    return res.status(400).json({ success: false, message: 'Password must be at least 5 characters long.' });
  }

  try {
    // Hash the new password before saving
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update password in the database
    const result = await pool.query('UPDATE users SET password = $1 WHERE email = $2', [hashedPassword, email]);

    // Check if any rows were updated
    if (result.rowCount === 0) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    // Generate new JWT token
    const userResult = await pool.query('SELECT id, email FROM users WHERE email = $1', [email]);
    const user = userResult.rows[0];

    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '1h' });

    return res.status(200).json({
      success: true,
      message: 'Password has been reset successfully.',
      token: token
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ success: false, message: 'Error resetting password' });
  }
});

// Route to test JWT authentication
app.get('/profile', (req, res) => {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ message: 'No token provided' });
  }
  // Verify JWT token
  jwt.verify(token, JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: 'Invalid or expired token' });
    }

    res.status(200).json({
      message: 'Profile data',
      userId: decoded.userId,
      email: decoded.email,
    });
  }); 
});


app.get('/', (req, res) => {
  res.send('Server is running');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
