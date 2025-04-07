import 'package:go_router/go_router.dart';
import 'package:login_app/API_SERVICE/login_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  // Load saved credentials (if any)
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    bool savedRememberMe =
        prefs.getBool('remember_me') ?? false; // Default to false if null

    if (savedRememberMe) {
      _emailController.text = savedEmail ?? '';
      _passwordController.text = savedPassword ?? '';
      setState(() {
        _rememberMe = savedRememberMe;
      });
    }
  }

  // Save credentials if Remember Me is checked
  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('remember_me');
    }
  }

  Future<void> _login() async {
    final BuildContext ctx = context;
    setState(() {
      _isLoading = true;
      _emailErrorMessage = null;
      _passwordErrorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    // Validate email format
    if (!_isEmailValid(email)) {
      setState(() {
        _emailErrorMessage = 'Please enter a valid email address';
        _isLoading = false;
      });
      return;
    }

    // Check if password is empty
    if (password.isEmpty) {
      setState(() {
        _passwordErrorMessage = 'Password cannot be empty';
        _isLoading = false;
      });
      return;
    }

    // Make the login request
    final response = await LoginService().login(email, password);
    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      await _saveCredentials();
      if (ctx.mounted) {
        context.go('/home');
      }
    } else {
      setState(() {
        if (response['message'] == "Email not found") {
          _emailErrorMessage = 'No account found with this email.';
        } else if (response['message'] == "Invalid email format") {
          _emailErrorMessage = 'Please enter a valid email address.';
        } else if (response['message'] == "Password is wrong") {
          _passwordErrorMessage = 'Password is incorrect';
        } else {
          _emailErrorMessage = response['message'];
        }
      });
    }
  }

  // Email validation function
  bool _isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400), // Set max width
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome to Page! 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please sign-in to your account and start the adventure',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Email TextField with error handling
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: _emailErrorMessage, // Show error below email
                  ),
                ),
                const SizedBox(height: 26),
                // Password TextField with error handling
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText:
                        _passwordErrorMessage, // Show error below password
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/forgot-password');
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('SIGN IN'),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('SIGN UP'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.g_mobiledata,
                        color: Colors.blueAccent),
                    onPressed:
                        () {}, // Call the method when button is pressed
                    label: const Text(
                      'Log in with Google',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
