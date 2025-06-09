import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fullstack/services/wrong_note_service.dart';

class WrongNoteServiceWithClient extends WrongNoteService {
  final http.Client client;

  WrongNoteServiceWithClient(this.client);

  @override
  Future<List<Map<String, dynamic>>> fetchWrongQuestions() async {
    final response = await client.get(Uri.parse('$baseUrl/wrong-questions'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<Map<String, dynamic>>();
    } else {
      throw Exception('오답 문제 불러오기 실패');
    }
  }

  @override
  Future<void> deleteWrongQuestion(int id) async {
    await client.delete(Uri.parse('$baseUrl/delete-wrong-question?id=$id'));
  }
}

void main() {
  group('WrongNoteService', () {
    test('fetchWrongQuestions() - 200 OK → 오답 문제 리스트 반환', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {'id': 1, 'question': '오답1'},
            {'id': 2, 'question': '오답2'},
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = WrongNoteServiceWithClient(mockClient);
      final result = await service.fetchWrongQuestions();

      expect(result.length, 2);
      expect(result[0]['id'], 1);
      expect(result[1]['question'], '오답2');
    });

    test('deleteWrongQuestion() - 200 OK → 예외 없이 종료', () async {
      final mockClient = MockClient((request) async {
        return http.Response('', 200);
      });

      final service = WrongNoteServiceWithClient(mockClient);

      // 예외 발생하지 않아야 함
      expect(() => service.deleteWrongQuestion(1), returnsNormally);
    });

    test('deleteWrongQuestion() - 404 → 예외 없이 종료 (서버에서 처리 실패)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = WrongNoteServiceWithClient(mockClient);

      // 예외 없이 정상 종료되어야 함
      expect(() => service.deleteWrongQuestion(999), returnsNormally);
    });
  });
}
