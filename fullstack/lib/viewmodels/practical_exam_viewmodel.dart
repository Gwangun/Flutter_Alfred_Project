import 'package:flutter/material.dart';

class PracticalExamViewModel extends ChangeNotifier {
  final String title = '실기 문제 풀기';
  final String subtitle = 'What do you want to learn?';

  /// 일반 페이지 이동
  void goToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  /// 네임드 라우트 이동
  void goToNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
