import 'package:test/test.dart';
import 'package:alfred/alfred.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite3/sqlite3.dart';
import 'dart:convert';
import 'package:server/routes/practical_routes.dart';

void main() {
  late Alfred app;
  late Database db;
  late int port;

  setUpAll(() async {
    app = Alfred();
    db = sqlite3.openInMemory();

    // 테이블 생성
    db.execute('''
      CREATE TABLE practical_questions (
        id INTEGER PRIMARY KEY,
        question TEXT,
        code TEXT,
        answer TEXT,
        explanation TEXT
      );
    ''');

    db.execute('''
      CREATE TABLE saved_practical_questions (
        id INTEGER PRIMARY KEY,
        question TEXT,
        code TEXT,
        answer TEXT,
        explanation TEXT
      );
    ''');

    // 샘플 데이터 추가
    db.execute('''
      INSERT INTO practical_questions (id, question, code, answer, explanation)
      VALUES (1, 'What is Dart?', 'void main() {}', 'A language', 'Dart is a language.');
    ''');

    // 라우트 등록
    registerPracticalRoutes(app, db);

    await app.listen();
    port = app.server!.port;
  });

  tearDownAll(() async {
    await app.close();
    db.dispose();
  });

  test('GET /practical-questions returns list of questions', () async {
    final response =
        await http.get(Uri.parse('http://localhost:$port/practical-questions'));
    expect(response.statusCode, 200);

    final data = jsonDecode(response.body);
    expect(data, isList);
    expect(data[0]['question'], contains('Dart'));
  });

  test('GET /practical-answer returns correct answer and explanation',
      () async {
    final response = await http
        .get(Uri.parse('http://localhost:$port/practical-answer?id=1'));
    expect(response.statusCode, 200);

    final data = jsonDecode(response.body);
    expect(data['answer'], 'A language');
    expect(data['explanation'], contains('Dart is'));
  });

  test('POST /save-practical-question inserts question into saved table',
      () async {
    final response = await http.post(
      Uri.parse('http://localhost:$port/save-practical-question?id=1'),
    );
    expect(response.statusCode, 200);

    final data = jsonDecode(response.body);
    expect(data['status'], 'saved');
  });

  test('GET /saved-practical-questions returns saved list', () async {
    final response = await http
        .get(Uri.parse('http://localhost:$port/saved-practical-questions'));
    expect(response.statusCode, 200);

    final data = jsonDecode(response.body);
    expect(data, isList);
    expect(data[0]['code'], contains('main'));
  });

  test('DELETE /delete-saved-practical-question removes the question',
      () async {
    final response = await http.delete(
      Uri.parse('http://localhost:$port/delete-saved-practical-question?id=1'),
    );
    expect(response.statusCode, 200);

    final data = jsonDecode(response.body);
    expect(data['status'], 'deleted');
  });
}
