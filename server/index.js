const express = require('express');

const app = express();

const { Client } = require('pg');
const Buffer = require('buffer').Buffer;

// Database configuration
//The default port for PostgreSQL is 5432
const client = new Client({
  user: 'postgres',
  password: 'password',
  host: 'localhost',
  port: '5432',
  database: 'takuwa'
});

// Connect to the database
client.connect()
  .then(() => {
    console.log('Connected to the database');
  })
  .catch(err => {
    console.error('Error connecting to the database', err);
  });

app.use(express.json());

// Login endpoint
app.post('/api/login', (req, res) => {
  const { email, password } = req.body;

  if (!/^\w+([.-]?\w+)@\w+([.-]?\w+)(.com)$/.test(email)) {
    res.status(400).send('Invalid email format');
    return;
  }  

  const query = `SELECT * FROM users WHERE email = '${email}'`;

  client.query(query, (err, result) => {
    if (err) {
      console.log(err);
      res.status(500).send('Error occurred while querying the database');
    } else {
      if (result.rows.length === 0) {
        res.status(404).send('Email not found');
      } else {
        const user = result.rows[0];
        //password stored in the database is in binary format (bytea).
        //you need to decode the binary password stored in the database and compare it to the plain text password sent by the client:
        const decodedPassword = Buffer.from(user.password).toString();
        if (decodedPassword === password) {
          res.status(200).send('Login successful');
        } else {
          res.status(401).send('Incorrect password');
        }
      }
    }
  });
});

// Registration endpoint
app.post('/api/register', (req, res) => {
  const { email, password } = req.body;

  if (!/^\w+([.-]?\w+)@\w+([.-]?\w+)(.com)$/.test(email)) {
    res.status(400).send('Invalid email format');
    return;
  }  

  // Validate password format
  if (!/^(?=.*[A-Z])(?=.*[0-9]).{5,}$/.test(password)) {
    res.status(400).send('Password must contain at least 5 characters and one capital letter');
    return;
  }

  const query = `SELECT * FROM users WHERE email = '${email}'`;

  client.query(query, (err, result) => {
    if (err) {
      console.log(err);
      res.status(500).send('Error occurred while checking for existing email');
      return;
    }

    if (result.rows.length > 0) {
      res.status(400).send('Email already exists');
      return;
    }

    const insertQuery = `INSERT INTO users (email, password) VALUES ('${email}', '${password}')`;
    client.query(insertQuery, (err, result) => {
      if (err) {
        console.log(err);
        res.status(500).send('Error occurred while registering the user');
      } else {
        res.status(200).send('User registered successfully');
      }
    });
  });
});

app.get('/', (req, res) => {
  res.send('Hello there everyone!');
});

app.listen(3000, () => {
  console.log('Server listening on port 3000');
});
