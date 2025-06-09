import 'dart:convert';
import 'package:http/http.dart' as http;

class WrongNoteService {
  final String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Map<String, dynamic>>> fetchWrongQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/wrong-questions'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<Map<String, dynamic>>();
    } else {
      throw Exception('오답 문제 불러오기 실패');
    }
  }

  Future<void> deleteWrongQuestion(int id) async {
    await http.delete(Uri.parse('$baseUrl/delete-wrong-question?id=$id'));
  }
}
