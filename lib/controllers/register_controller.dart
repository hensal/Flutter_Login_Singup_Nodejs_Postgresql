import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> register(String email, String password) async {
  Map<String, String> data = {
    'email': email,
    'password': password,
  };

final uri = Uri.parse('http://localhost:3000/api/register');

  http.Response response = await http.post(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  return response;
}
