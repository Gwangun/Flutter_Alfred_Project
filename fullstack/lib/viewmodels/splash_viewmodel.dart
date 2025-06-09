import 'dart:async';

class SplashViewModel {
  Future<void> waitAndNavigate(Function callback) async {
    await Future.delayed(const Duration(seconds: 3));
    callback(); // 콜백으로 라우팅 제어
  }
}
