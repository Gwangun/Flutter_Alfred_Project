import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class WrittenQuestionsService {
  final String baseUrl;
  final http.Client client;
  final Logger _logger;

  WrittenQuestionsService({
    this.baseUrl = 'http://10.0.2.2:3000',
    http.Client? client,
    Logger? logger,
  }) : client = client ?? http.Client(),
       _logger = logger ?? Logger();

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/questions'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body).cast<Map<String, dynamic>>();
      } else {
        _logger.e('문제 로딩 실패: ${response.statusCode}');
        throw Exception('문제 로딩 실패');
      }
    } catch (e) {
      _logger.e('서버 요청 중 오류 발생: $e');
      rethrow;
    }
  }

  Future<String> saveQuestion(int id) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/save-question?id=$id'),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['status'] == 'saved' ? '문제가 저장되었습니다!' : '이미 저장된 문제입니다.';
      } else {
        _logger.w('저장 실패: ${response.statusCode}');
        return '저장에 실패했습니다.';
      }
    } catch (e) {
      _logger.e('문제 저장 요청 중 오류 발생: $e');
      return '저장 중 오류 발생';
    }
  }

  Future<void> saveWrongQuestion(int id) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/save-wrong-question?id=$id'),
      );
      if (response.statusCode != 200) {
        _logger.w('오답 저장 실패: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('오답 저장 중 오류 발생: $e');
    }
  }
}
