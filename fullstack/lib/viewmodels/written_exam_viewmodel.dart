import 'package:flutter/material.dart';
import '../views/written_practice_view.dart';

class WrittenExamViewModel {
  void navigateToPractice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WrittenPracticePage()),
    );
  }

  void navigateToSaved(BuildContext context) {
    Navigator.pushNamed(context, '/saved');
  }

  void navigateToWrong(BuildContext context) {
    Navigator.pushNamed(context, '/wrong');
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }
}
