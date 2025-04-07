// /services/signup_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  static const String _url = 'http://localhost:3000/signup';

  // Sign up a new user
  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); 

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'error': 'Failed to create user: ${response.body}'};
    }
  }
}
