import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이메일과 비밀번호를 입력해주세요.'),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final result = await viewModel.signup();

                if (!context.mounted) return; // ✅ context 유효성 확인

                if (result['success']) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('회원가입 완료'),
                          content: Text(
                            '${result['data']['user']}님, 가입을 환영합니다!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // AlertDialog 닫기
                                Navigator.of(context).pop(); // 로그인 화면으로 돌아가기
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('회원가입 실패'),
                          content: Text(result['data']['message']),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('닫기'),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
