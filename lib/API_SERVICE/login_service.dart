import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String _baseUrl =
      'http://localhost:3000'; // Replace with your backend URL

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the response and save the token and user_id in SharedPreferences
      final data = json.decode(response.body);
      final token = data['token'];
      final userId = data['user_id']; // Now user_id is included in the response

      if (token != null && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token); // Save the token
        await prefs.setInt('user_id', userId); // Save the user_id
        await prefs.reload();
        print("Token saved: $token");
        print("User ID saved: $userId");
      }
      return {
        'success': true,
        'message': 'Login successful',
        'token': token,
        'user_id': userId,
      };
    } else {
      final data = json.decode(response.body);
      String errorMessage = 'Failed to login: ${response.body}';

      if (data['message'] != null) {
        if (data['message'].contains('Email not found')) {
          errorMessage =
              'No account found with this email.'; // Custom message for email not found
        } else if (data['message'].contains('Invalid credentials')) {
          errorMessage =
              'Password is wrong'; // Custom message for wrong password
        } else {
          errorMessage = data['message']; // Use the generic error message
        }
      }

      print("Login failed: $errorMessage");
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }
}
