import 'package:flutter/material.dart';
import '../views/written_save_view.dart';
import '../views/saved_practical_view.dart';
import '../views/wrong_note_view.dart';

class HomeViewModel {
  void goToWrongNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WrongNotePage()),
    );
  }

  void showSavedQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Center(
            child: Text(
              '문제 유형 선택',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _dialogButton(
                context,
                label: '필기 문제',
                target: const WrittenSavePage(),
              ),
              _dialogButton(
                context,
                label: '실기 문제',
                target: const SavedPracticalView(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dialogButton(
    BuildContext context, {
    required String label,
    required Widget target,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        side: const BorderSide(color: Colors.deepPurple),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => target));
      },
      child: Text(label),
    );
  }
}
