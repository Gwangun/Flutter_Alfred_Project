import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/signup_request.dart'; // 추가

class AuthService {
  final http.Client client;
  AuthService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> login(LoginRequest request) async {
    final url = Uri.parse('http://10.0.2.2:3000/login');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> signup(SignupRequest request) async {
    final url = Uri.parse('http://10.0.2.2:3000/signup');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    return {
      'success': response.statusCode == 200,
      'data': jsonDecode(response.body),
    };
  }
}
