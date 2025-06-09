import 'dart:convert';
import 'package:http/http.dart' as http;

class WrittenSaveService {
  final String baseUrl;
  final http.Client client;

  // 생성자에서 client를 주입받도록 변경 (테스트 시 mock 주입 가능)
  WrittenSaveService({
    required this.client,
    this.baseUrl = 'http://10.0.2.2:3000',
  });

  // 저장된 문제 목록 가져오기
  Future<List<Map<String, dynamic>>> fetchSavedQuestions() async {
    final response = await client.get(Uri.parse('$baseUrl/saved-questions'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('저장된 문제 불러오기 실패');
    }
  }

  // 문제 삭제 요청
  Future<bool> deleteSavedQuestion(int id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/delete-saved-question?id=$id'),
    );
    return response.statusCode == 200;
  }
}
