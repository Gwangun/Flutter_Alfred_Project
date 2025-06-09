import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fullstack/services/written_save_service.dart';

void main() {
  group('WrittenSaveService', () {
    test('fetchSavedQuestions() - 200 OK → 저장된 문제 리스트 반환', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {'id': 1, 'question': '문제1'},
            {'id': 2, 'question': '문제2'},
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = WrittenSaveService(client: mockClient);
      final result = await service.fetchSavedQuestions();

      expect(result.length, 2);
      expect(result[0]['id'], 1);
      expect(result[1]['question'], '문제2');
    });

    test('deleteSavedQuestion() - 200 OK → true 반환', () async {
      final mockClient = MockClient((request) async {
        return http.Response('', 200);
      });

      final service = WrittenSaveService(client: mockClient);
      final result = await service.deleteSavedQuestion(1);

      expect(result, isTrue);
    });

    test('deleteSavedQuestion() - 404 Not Found → false 반환', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = WrittenSaveService(client: mockClient);
      final result = await service.deleteSavedQuestion(999);

      expect(result, isFalse);
    });
  });
}
