import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/written_save_service.dart';

class WrittenSaveViewModel extends ChangeNotifier {
  final WrittenSaveService _service;
  List<Map<String, dynamic>> savedQuestions = [];
  int currentIndex = 0;
  int? selectedOption;

  WrittenSaveViewModel({http.Client? client})
    : _service = WrittenSaveService(client: client ?? http.Client());

  Future<void> loadSavedQuestions() async {
    savedQuestions = await _service.fetchSavedQuestions();
    savedQuestions.sort((a, b) => a['id'].compareTo(b['id']));
    currentIndex = 0;
    selectedOption = null;
    notifyListeners();
  }

  void selectOption(int index) {
    selectedOption = index;
    notifyListeners();
  }

  Future<bool> deleteCurrentQuestion() async {
    final id = savedQuestions[currentIndex]['id'];
    final success = await _service.deleteSavedQuestion(id);
    if (success) {
      savedQuestions.removeWhere((q) => q['id'] == id);
      if (currentIndex >= savedQuestions.length) {
        currentIndex = savedQuestions.length - 1;
      }
      selectedOption = null;
      notifyListeners();
    }
    return success;
  }

  void nextQuestion() {
    if (currentIndex < savedQuestions.length - 1) {
      currentIndex++;
      selectedOption = null;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      selectedOption = null;
      notifyListeners();
    }
  }
}
