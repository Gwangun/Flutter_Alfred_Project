import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:fullstack/services/auth_service.dart';
import 'package:fullstack/models/login_request.dart';
import 'package:fullstack/models/signup_request.dart';
import 'mocks.mocks.dart'; // ✅ auto-generated

@GenerateMocks([http.Client])
void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      authService = AuthService(client: mockClient); // 주입 필요
    });

    test('로그인 성공 시 true 반환', () async {
      final request = LoginRequest(email: 'test@test.com', password: '1234');
      final url = Uri.parse('http://10.0.2.2:3000/login');

      when(
        mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      final result = await authService.login(request);
      expect(result, isTrue);
    });

    test('회원가입 실패 시 success: false 반환', () async {
      final request = SignupRequest(email: 'test@test.com', password: '1234');

      final url = Uri.parse('http://10.0.2.2:3000/signup');

      when(
        mockClient.post(
          url,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{"message": "error"}', 400));

      final result = await authService.signup(request);
      expect(result['success'], isFalse);
      expect(result['data']['message'], 'error');
    });
  });
}
