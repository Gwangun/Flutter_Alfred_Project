import 'package:test/test.dart';
import 'dart:io';
import 'dart:convert';
import 'package:server/services/user_service.dart';

void main() {
  late Directory tempDir;
  late String tempFilePath;
  late UserService userService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('user_service_test');
    tempFilePath = '${tempDir.path}/users.json';

    // 초기 JSON 데이터 파일 생성
    final file = File(tempFilePath);
    await file.writeAsString(jsonEncode([
      {'email': 'test@example.com', 'password': '1234'}
    ]));

    userService = UserService(usersFilePath: tempFilePath);
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('login() - 로그인 성공', () async {
    final result = await userService.login('test@example.com', '1234');
    expect(result['statusCode'], 200);
    expect(result['body']['message'], '로그인 성공');
  });

  test('login() - 로그인 실패', () async {
    final result = await userService.login('test@example.com', 'wrongpass');
    expect(result['statusCode'], 401);
    expect(result['body']['message'], '로그인 실패');
  });

  test('signup() - 신규 회원가입 성공', () async {
    final result = await userService.signup('new@example.com', 'abcd');
    expect(result['statusCode'], 200);
    expect(result['body']['message'], '회원가입 성공');

    final fileContent = await File(tempFilePath).readAsString();
    final users = jsonDecode(fileContent);
    expect(users.any((u) => u['email'] == 'new@example.com'), true);
  });

  test('signup() - 중복 이메일 실패', () async {
    final result = await userService.signup('test@example.com', '1234');
    expect(result['statusCode'], 409);
    expect(result['body']['message'], '이미 존재하는 이메일입니다.');
  });
}
