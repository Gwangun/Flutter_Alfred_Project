import 'package:alfred/alfred.dart';
import '../services/user_service.dart';

void registerAuthRoutes(Alfred app) {
  // 👇 파일 경로를 명시적으로 넘겨주는 부분 추가
  final userService = UserService(usersFilePath: 'data/users.json');

  app.post('/login', (req, res) async {
    final body = await req.bodyAsJsonMap;
    final result = await userService.login(body['email'], body['password']);

    res.statusCode = result['statusCode'];
    await res.json(result['body']);
  });

  app.post('/signup', (req, res) async {
    final body = await req.bodyAsJsonMap;
    final result = await userService.signup(body['email'], body['password']);

    res.statusCode = result['statusCode'];
    await res.json(result['body']);
  });
}
