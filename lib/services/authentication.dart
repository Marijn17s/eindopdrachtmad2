import 'dart:convert';
import 'package:http/http.dart' as http;
import '/token_manager.dart';

class AuthenticationServices {
  // static const String _baseApi = "http://localhost:8000/api";
  static const String _baseApi = "http://localhost:8000/api";
  static String _bearerToken = "";

  // api/register/
  static Future<bool> register (String email, String password) async {
    final response = await http.post(
        Uri.parse('$_baseApi/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'password_confirmation': password
        })
    );
    return response.statusCode == 200;
  }

  // api/login/
  static Future<bool> login (String email, String password) async {
    final response = await http.post(
        Uri.parse('$_baseApi/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        })
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      TokenManager.bearerToken = result['access_token'];
    }

    return response.statusCode == 200;
  }

  // api/logout/
  static Future<bool> logout (String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseApi/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${TokenManager.bearerToken}'
      },
    );

    return response.statusCode == 200;
  }
}