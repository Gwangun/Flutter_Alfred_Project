import 'package:flutter/material.dart';
import '../services/practical_question_service.dart';

class PracticalPracticeViewModel extends ChangeNotifier {
  final PracticalQuestionService _service = PracticalQuestionService();

  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  String? _answer;
  String? _explanation;
  bool _showAnswer = false;

  List<Map<String, dynamic>> get questions => _questions;
  int get currentIndex => _currentIndex;
  String? get answer => _answer;
  String? get explanation => _explanation;
  bool get showAnswer => _showAnswer;

  bool get hasPrevious => _currentIndex > 0;
  bool get hasNext => _currentIndex < _questions.length - 1;

  Map<String, dynamic> get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentIndex] : {};

  Future<void> loadQuestions() async {
    _questions = await _service.fetchQuestions();
    _currentIndex = 0;
    _showAnswer = false;
    _answer = null;
    _explanation = null;
    notifyListeners();
  }

  Future<void> loadAnswer() async {
    final id = currentQuestion['id'];
    final result = await _service.fetchAnswer(id);
    _answer = result['answer'];
    _explanation = result['explanation'];
    _showAnswer = true;
    notifyListeners();
  }

  Future<String> saveQuestion() async {
    final id = currentQuestion['id'];
    final result = await _service.savePracticalQuestion(id);
    return result;
  }

  void nextQuestion() {
    if (hasNext) {
      _currentIndex++;
      _showAnswer = false;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (hasPrevious) {
      _currentIndex--;
      _showAnswer = false;
      notifyListeners();
    }
  }
}
