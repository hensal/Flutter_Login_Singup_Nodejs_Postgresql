import 'package:flutter/material.dart';
import 'package:takuwa_project/authentication_screen/forgot_password.dart';
import 'package:takuwa_project/authentication_screen/register_screen.dart';
import 'package:takuwa_project/screens/home_screen.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  //late String _email, _password;
  late bool _obscureText = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
                //onSaved: (input) => _email = input!,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
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
                obscureText: _obscureText,
                //onSaved: (input) => _password = input!,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: MaterialButton(
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  onPressed: loginButtonPressed,
                  child: const Text('Login',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Do not have account?'),
                  TextButton(
                    child: const Text(
                      'Register Here',
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
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

//login_button_function using Api
void loginButtonPressed() async {
  if (!isValidEmail(_email.text)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid email format'),
      ),
    );
    return;
  }
  var response = await login(_email.text, _password.text);

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful'),
      ),
    );
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  } else if (response.statusCode == 401) {
    print('Incorrect password');
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Incorrect password'),
      ),
    );
  } else if (response.statusCode == 404) {
    print('Email not found');
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email not found'),
      ),
    );
  } else {
    print('Error occurred while querying the database');
  }
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.(com|edu|org)$").hasMatch(email);
}

}
