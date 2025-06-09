import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart'; // ✅ 핵심: mockito 아님!
import 'dart:convert';

import 'package:fullstack/services/saved_practical_service.dart';

void main() {
  group('SavedPracticalService', () {
    test('fetchAnswer() - 200 OK → answer & explanation 반환', () async {
      final mockClient = MockClient((http.Request request) async {
        final jsonBody = jsonEncode({'answer': '정답', 'explanation': '설명입니다'});

        return http.Response(
          jsonBody,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = SavedPracticalService(client: mockClient);

      final result = await service.fetchAnswer(1);
      expect(result['answer'], '정답');
      expect(result['explanation'], '설명입니다');
    });
  });
}
