import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:fullstack/services/written_questions_service.dart';

void main() {
  group('WrittenQuestionsService', () {
    test('fetchQuestions() - 200 OK → 질문 목록 반환', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {'id': 1, 'question': 'Q1'},
            {'id': 2, 'question': 'Q2'},
          ]),
          200,
        );
      });

      final service = WrittenQuestionsService(client: mockClient);
      final result = await service.fetchQuestions();

      expect(result.length, 2);
      expect(result[0]['id'], 1);
    });

    test('saveQuestion() - status=saved → 저장 성공 메시지', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'status': 'saved'}), 200);
      });

      final service = WrittenQuestionsService(client: mockClient);
      final result = await service.saveQuestion(1);
      expect(result, '문제가 저장되었습니다!');
    });

    test('saveQuestion() - status=already_exists → 중복 메시지', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'status': 'already_exists'}), 200);
      });

      final service = WrittenQuestionsService(client: mockClient);
      final result = await service.saveQuestion(1);
      expect(result, '이미 저장된 문제입니다.');
    });

    test('saveWrongQuestion() - 200 OK → 예외 없이 완료', () async {
      final mockClient = MockClient((request) async {
        return http.Response('', 200);
      });

      final service = WrittenQuestionsService(client: mockClient);
      await service.saveWrongQuestion(42); // 성공 시 아무 것도 반환하지 않음
    });
  });
}
