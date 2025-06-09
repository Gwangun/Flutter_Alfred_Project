import 'dart:io';
import 'dart:convert';

class UserService {
  final String usersFilePath;

  UserService({required this.usersFilePath});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final usersFile = File(usersFilePath);
    if (!await usersFile.exists()) {
      return {
        'statusCode': 500,
        'body': {'message': 'User data not found'},
      };
    }

    final usersData = jsonDecode(await usersFile.readAsString());
    final user = usersData.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => null,
    );

    if (user != null) {
      return {
        'statusCode': 200,
        'body': {'message': '로그인 성공', 'user': user['email']},
      };
    } else {
      return {
        'statusCode': 401,
        'body': {'message': '로그인 실패'},
      };
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    final usersFile = File(usersFilePath);

    if (!await usersFile.exists()) {
      await usersFile.create(recursive: true);
      await usersFile.writeAsString(jsonEncode([]));
    }

    final List usersData = jsonDecode(await usersFile.readAsString());
    final existingUser = usersData.firstWhere(
      (u) => u['email'] == email,
      orElse: () => null,
    );

    if (existingUser != null) {
      return {
        'statusCode': 409,
        'body': {'message': '이미 존재하는 이메일입니다.'},
      };
    }

    usersData.add({'email': email, 'password': password});
    await usersFile.writeAsString(jsonEncode(usersData));

    return {
      'statusCode': 200,
      'body': {'message': '회원가입 성공', 'user': email},
    };
  }
}
