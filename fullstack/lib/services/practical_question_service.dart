import 'dart:convert';
import 'package:http/http.dart' as http;

class PracticalQuestionService {
  final String baseUrl;
  final http.Client client;

  PracticalQuestionService({
    this.baseUrl = 'http://10.0.2.2:3000',
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final url = Uri.parse('$baseUrl/practical-questions');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('문제 로딩 실패');
    }
  }

  Future<Map<String, dynamic>> fetchAnswer(int id) async {
    final url = Uri.parse('$baseUrl/practical-answer?id=$id');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('정답 로딩 실패');
    }
  }

  Future<String> savePracticalQuestion(int id) async {
    final url = Uri.parse('$baseUrl/save-practical-question?id=$id');
    final response = await client.post(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['status'] == 'already_exists'
          ? '이미 저장된 문제입니다.'
          : '문제가 저장되었습니다!';
    } else {
      throw Exception('저장 실패');
    }
  }
}
