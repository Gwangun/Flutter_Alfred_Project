import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../views/signup_view.dart';
import '../views/home_view.dart';
import '../widgets/text_styles.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome\n',
                        style: AppTextStyles.welcomeTitle,
                      ),
                      TextSpan(
                        text: 'Login to continue',
                        style: AppTextStyles.welcomeSubtitle,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              Text('Email Address', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.emailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFF491B6D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFF491B6D)),
                  ),
                ),
                style: AppTextStyles.fieldValue,
              ),
              const SizedBox(height: 24),
              Text('Password', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              TextField(
                controller: viewModel.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFF491B6D)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFF491B6D)),
                  ),
                ),
                style: AppTextStyles.fieldValue,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF491B6D),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final success = await viewModel.login();

                    if (!context.mounted) return;

                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('로그인 실패'),
                              content: const Text(
                                '등록되지 않은 사용자입니다. 회원가입을 진행해주세요.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('닫기'),
                                ),
                              ],
                            ),
                      );
                    }
                  },
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don’t have an account? ',
                        style: AppTextStyles.fieldValue,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ChangeNotifierProvider(
                                      create: (_) => SignupViewModel(),
                                      child: const SignupScreen(),
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            'Sign up now',
                            style: AppTextStyles.welcomeSubtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
