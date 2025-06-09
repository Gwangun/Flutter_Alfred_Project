import 'package:flutter/material.dart';
import '../services/written_questions_service.dart';

class WrittenPracticeViewModel extends ChangeNotifier {
  final WrittenQuestionsService _service = WrittenQuestionsService();

  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  int? _selectedOption;

  List<Map<String, dynamic>> get questions => _questions;
  int get currentIndex => _currentIndex;
  int? get selectedOption => _selectedOption;

  Map<String, dynamic> get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentIndex] : {};

  Future<void> loadQuestions() async {
    _questions = await _service.fetchQuestions();
    _currentIndex = 0;
    _selectedOption = null;
    notifyListeners();
  }

  void selectOption(int index) {
    _selectedOption = index;
    final int answerIndex = (currentQuestion['answer'] ?? 1) - 1;
    if (_selectedOption != answerIndex) {
      _service.saveWrongQuestion(currentQuestion['id']);
    }
    notifyListeners();
  }

  void goToNext() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedOption = null;
      notifyListeners();
    }
  }

  void goToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _selectedOption = null;
      notifyListeners();
    }
  }

  Future<String> saveCurrentQuestion() async {
    final id = currentQuestion['id'];
    return await _service.saveQuestion(id);
  }
}
