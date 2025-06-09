import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<bool> login() async {
    final request = LoginRequest(
      email: emailController.text,
      password: passwordController.text,
    );
    return await _authService.login(request);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
