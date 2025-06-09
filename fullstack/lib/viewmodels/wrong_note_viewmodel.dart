import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WrongNoteViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _wrongQuestions = [];
  int _currentIndex = 0;
  int? _selectedOption;
  final Set<int> _toBeDeleted = {};

  List<Map<String, dynamic>> get wrongQuestions => _wrongQuestions;
  int get currentIndex => _currentIndex;
  int? get selectedOption => _selectedOption;
  Map<String, dynamic> get currentQuestion => _wrongQuestions[_currentIndex];

  Future<void> loadWrongQuestions() async {
    final url = Uri.parse('http://10.0.2.2:3000/wrong-questions');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      _wrongQuestions = data.cast<Map<String, dynamic>>();
      _currentIndex = 0;
      _selectedOption = null;
      notifyListeners();
    }
  }

  void selectOption(int index) {
    _selectedOption = index;
    final isCorrect = index == (_wrongQuestions[_currentIndex]['answer'] - 1);
    if (isCorrect) {
      _toBeDeleted.add(_wrongQuestions[_currentIndex]['id']);
    }
    notifyListeners();
  }

  void goToNext() async {
    final id = _wrongQuestions[_currentIndex]['id'];
    if (_toBeDeleted.contains(id)) {
      await deleteWrongQuestion(id);
      _wrongQuestions.removeWhere((q) => q['id'] == id);
      _toBeDeleted.remove(id);
    } else {
      _currentIndex++;
    }
    if (_currentIndex >= _wrongQuestions.length) {
      _currentIndex = _wrongQuestions.length - 1;
    }
    _selectedOption = null;
    notifyListeners();
  }

  void goToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _selectedOption = null;
      notifyListeners();
    }
  }

  Future<void> deleteWrongQuestion(int id) async {
    final url = Uri.parse('http://10.0.2.2:3000/delete-wrong-question?id=$id');
    await http.delete(url);
  }

  Future<void> deleteAllMarked() async {
    for (final id in _toBeDeleted) {
      await deleteWrongQuestion(id);
    }
    _toBeDeleted.clear();
  }
}
