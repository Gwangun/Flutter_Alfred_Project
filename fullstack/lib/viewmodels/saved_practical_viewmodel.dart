import 'package:flutter/material.dart';
import '../services/saved_practical_service.dart';

class SavedPracticalViewModel extends ChangeNotifier {
  final SavedPracticalService _service = SavedPracticalService();

  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  String? _answer;
  String? _explanation;

  List<Map<String, dynamic>> get questions => _questions;
  int get currentIndex => _currentIndex;
  bool get showAnswer => _showAnswer;
  String? get answer => _answer;
  String? get explanation => _explanation;

  Map<String, dynamic> get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentIndex] : {};

  Future<void> loadSavedQuestions() async {
    _questions = await _service.fetchSavedQuestions();
    _questions.sort((a, b) => a['id'].compareTo(b['id']));
    _currentIndex = 0;
    _showAnswer = false;
    _answer = null;
    _explanation = null;
    notifyListeners();
  }

  /// ❌ context 제거: ViewModel에서는 메시지 등 UI 책임을 가지지 않음
  Future<bool> deleteCurrentQuestion() async {
    final id = currentQuestion['id'];
    await _service.deleteSavedQuestion(id);
    _questions.removeWhere((q) => q['id'] == id);
    if (_currentIndex >= _questions.length) {
      _currentIndex = _questions.length - 1;
    }
    _showAnswer = false;
    _answer = null;
    _explanation = null;
    notifyListeners();

    return true; // 삭제 성공 여부 반환
  }

  Future<void> loadAnswer() async {
    final id = currentQuestion['id'];
    final result = await _service.fetchAnswer(id);
    _answer = result['answer'];
    _explanation = result['explanation'];
    _showAnswer = true;
    notifyListeners();
  }

  void goToNext() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _showAnswer = false;
      notifyListeners();
    }
  }

  void goToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _showAnswer = false;
      notifyListeners();
    }
  }
}
