import 'package:http/http.dart' as http;
import 'dart:convert';

class SavedPracticalService {
  final String baseUrl;
  final http.Client client;

  SavedPracticalService({
    this.baseUrl = 'http://10.0.2.2:3000',
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> fetchSavedQuestions() async {
    final url = Uri.parse('$baseUrl/saved-practical-questions');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      data.sort((a, b) => a['id'].compareTo(b['id']));
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('저장된 문제 불러오기 실패');
    }
  }

  Future<void> deleteSavedQuestion(int id) async {
    final url = Uri.parse('$baseUrl/delete-saved-practical-question?id=$id');
    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw Exception('문제 삭제 실패');
    }
  }

  Future<Map<String, String>> fetchAnswer(int id) async {
    final url = Uri.parse('$baseUrl/practical-answer?id=$id');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'answer': data['answer'] ?? '',
        'explanation': data['explanation'] ?? '',
      };
    } else {
      throw Exception('정답 불러오기 실패');
    }
  }
}
