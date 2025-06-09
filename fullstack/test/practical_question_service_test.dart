import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fullstack/services/practical_question_service.dart';
import 'mocks.mocks.dart';

void main() {
  group('PracticalQuestionService', () {
    late PracticalQuestionService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      service = PracticalQuestionService(client: mockClient);
    });

    test('fetchQuestions() - 200 OK → 질문 목록 반환', () async {
      final mockResponse = jsonEncode([
        {'id': 1, 'question': 'Q1'},
        {'id': 2, 'question': 'Q2'},
      ]);
      final url = Uri.parse('http://10.0.2.2:3000/practical-questions');

      when(
        mockClient.get(url),
      ).thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await service.fetchQuestions();
      expect(result.length, 2);
      expect(result[0]['question'], 'Q1');
    });

    test('fetchAnswer() - 200 OK → 정답 반환', () async {
      final id = 1;
      final mockResponse = jsonEncode({'answer': '42'});
      final url = Uri.parse('http://10.0.2.2:3000/practical-answer?id=$id');

      when(
        mockClient.get(url),
      ).thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await service.fetchAnswer(id);
      expect(result['answer'], '42');
    });

    test('savePracticalQuestion() - 이미 저장된 문제', () async {
      final id = 1;
      final mockResponse = jsonEncode({'status': 'already_exists'});
      final url = Uri.parse(
        'http://10.0.2.2:3000/save-practical-question?id=$id',
      );

      when(
        mockClient.post(url),
      ).thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await service.savePracticalQuestion(id);
      expect(result, '이미 저장된 문제입니다.');
    });

    test('savePracticalQuestion() - 새 문제 저장 성공', () async {
      final id = 2;
      final mockResponse = jsonEncode({'status': 'saved'});
      final url = Uri.parse(
        'http://10.0.2.2:3000/save-practical-question?id=$id',
      );

      when(
        mockClient.post(url),
      ).thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await service.savePracticalQuestion(id);
      expect(result, '문제가 저장되었습니다!');
    });
  });
}
