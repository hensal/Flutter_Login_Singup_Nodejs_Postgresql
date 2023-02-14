import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:takuwa_project/authentication_screen/login_screen.dart';
import 'package:takuwa_project/controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _passwordobscureText = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 40),
                child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset('assets/TAKUWALOGO.png')),
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Provide an email';
                  }
                  final RegExp regex = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@gmail\.com");
                  if (!regex.hasMatch(input)) {
                    return 'Provide a valid email address with gmail.com domain';
                  }
                  return null;
                },
                //onSaved: (input) => email = input!,
               // onSaved: (input) {email = input!;  },
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: _password,
                obscureText: _passwordobscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordobscureText
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordobscureText = !_passwordobscureText;
                      });
                    },
                  ),
                ),
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Provide a password';
                  }
                  if (!RegExp(r'^(?=.*[A-Z])').hasMatch(input)) {
                    return 'Password must have at least one capital letter';
                  }
                  if (input.length < 6 || input.length > 15) {
                    return 'Password must have between 6 and 15 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: registerButtonPressed,
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already have an account?'),
                  TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

void registerButtonPressed() async {
  // Validate email format
  if (!isValidEmail(_email.text)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid email format'),
      ),
    );
    return;
  }

  // Validate password
  if (!isValidPassword(_password.text)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password must be at least 5 characters and contain at least one capital letter'),
      ),
    );
    return;
  }

  var response = await register(_email.text, _password.text);

  if (response.statusCode == 200) {
    print('User registered');
     // ignore: use_build_context_synchronously
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User registered successfully'),
      ),
    );
  } else if (response.statusCode == 400) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email already exists'),
      ),
    );
  } else {
    print('Error registering user');
  }
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.(com|edu|org)$").hasMatch(email);
}


bool isValidPassword(String password) {
  // Write logic to check if the password is at least 5 characters and contains at least one capital letter
  return password.length >= 5 && password.contains(RegExp(r'[A-Z]'));
}

  /*
  void _submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      // ignore: unrelated_type_equality_checks
      if (_password.text == _confirmPassword.text) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Password match')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password do not match')));
      }
    }
  }*/
}
