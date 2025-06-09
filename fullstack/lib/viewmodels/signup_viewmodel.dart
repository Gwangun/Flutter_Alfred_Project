import 'package:flutter/material.dart';
import '../models/signup_request.dart';
import '../services/auth_service.dart';

class SignupViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> signup() async {
    final request = SignupRequest(
      email: emailController.text,
      password: passwordController.text,
    );
    return await _authService.signup(request);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
