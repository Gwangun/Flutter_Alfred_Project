import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  const baseUrl = 'http://localhost:3000';

  group('WrittenService 테스트', () {
    test('GET /questions → 전체 문제 목록 조회', () async {
      final response = await http.get(Uri.parse('$baseUrl/questions'));
      expect(response.statusCode, equals(200));

      final List data = jsonDecode(response.body);
      expect(data, isA<List>());
      expect(data.first, contains('question'));
    });

    test('POST /save-question → 문제 저장', () async {
      final response =
          await http.post(Uri.parse('$baseUrl/save-question?id=1'));
      expect(response.statusCode, anyOf([200, 400]));
      final result = jsonDecode(response.body);
      expect(result, contains('status'));
    });

    test('GET /saved-questions → 저장된 문제 조회', () async {
      final response = await http.get(Uri.parse('$baseUrl/saved-questions'));
      expect(response.statusCode, equals(200));

      final List data = jsonDecode(response.body);
      expect(data, isA<List>());
    });

    test('DELETE /delete-saved-question → 문제 삭제', () async {
      final response =
          await http.delete(Uri.parse('$baseUrl/delete-saved-question?id=1'));
      expect(response.statusCode, equals(200));
      final result = jsonDecode(response.body);
      expect(result['status'], equals('deleted'));
    });

    test('POST /save-wrong-question → 오답 저장', () async {
      final response =
          await http.post(Uri.parse('$baseUrl/save-wrong-question?id=1'));
      expect(response.statusCode, anyOf([200, 400]));
      final result = jsonDecode(response.body);
      expect(result, contains('status'));
    });

    test('GET /wrong-questions → 오답 조회', () async {
      final response = await http.get(Uri.parse('$baseUrl/wrong-questions'));
      expect(response.statusCode, equals(200));
      final List data = jsonDecode(response.body);
      expect(data, isA<List>());
    });

    test('DELETE /delete-wrong-question → 오답 삭제', () async {
      final response =
          await http.delete(Uri.parse('$baseUrl/delete-wrong-question?id=1'));
      expect(response.statusCode, equals(200));
      final result = jsonDecode(response.body);
      expect(result['status'], equals('deleted'));
    });
  });
}
