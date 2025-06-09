import 'package:flutter/material.dart';
import '../views/login_view.dart';
import '../viewmodels/splash_viewmodel.dart';

class FigmaScreen extends StatefulWidget {
  const FigmaScreen({super.key});

  @override
  State<FigmaScreen> createState() => _FigmaScreenState();
}

class _FigmaScreenState extends State<FigmaScreen> {
  final SplashViewModel vm = SplashViewModel();

  @override
  void initState() {
    super.initState();
    vm.waitAndNavigate(() {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(image: AssetImage('assets/images/im.png'), width: 300),
      ),
    );
  }
}
