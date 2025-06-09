import 'package:sqlite3/sqlite3.dart';
import 'package:alfred/alfred.dart';

class PracticalService {
  final Database db;

  PracticalService(this.db);

  Future<void> getPracticalQuestions(HttpRequest req, HttpResponse res) async {
    final result =
        db.select('SELECT id, question, code FROM practical_questions');
    final questions = result
        .map((row) => {
              'id': row['id'],
              'question': row['question'],
              'code': row['code'],
            })
        .toList();
    await res.json(questions);
  }

  Future<void> getPracticalAnswer(HttpRequest req, HttpResponse res) async {
    final id = int.tryParse(req.uri.queryParameters['id'] ?? '');
    if (id == null) {
      res.statusCode = 400;
      await res.json({'error': '유효하지 않은 문제 ID입니다.'});
      return;
    }

    final result = db.select(
      'SELECT answer, explanation FROM practical_questions WHERE id = ?',
      [id],
    );
    if (result.isEmpty) {
      res.statusCode = 404;
      await res.json({'error': '문제를 찾을 수 없습니다.'});
      return;
    }

    final row = result.first;
    await res
        .json({'answer': row['answer'], 'explanation': row['explanation']});
  }

  Future<void> savePracticalQuestion(HttpRequest req, HttpResponse res) async {
    final id = int.tryParse(req.uri.queryParameters['id'] ?? '');
    if (id == null) {
      res.statusCode = 400;
      await res.json({'error': '유효하지 않은 문제 ID'});
      return;
    }

    final exists = db.select(
      'SELECT * FROM saved_practical_questions WHERE id = ?',
      [id],
    );
    if (exists.isNotEmpty) {
      await res.json({'status': 'already_exists'});
      return;
    }

    final result =
        db.select('SELECT * FROM practical_questions WHERE id = ?', [id]);
    if (result.isEmpty) {
      res.statusCode = 404;
      await res.json({'error': '문제 없음'});
      return;
    }

    final row = result.first;
    db.execute(
      '''
      INSERT INTO saved_practical_questions (id, question, code, answer, explanation)
      VALUES (?, ?, ?, ?, ?)
    ''',
      [
        row['id'],
        row['question'],
        row['code'],
        row['answer'],
        row['explanation'],
      ],
    );

    await res.json({'status': 'saved'});
  }

  Future<void> getSavedPracticalQuestions(
      HttpRequest req, HttpResponse res) async {
    final result = db.select('SELECT * FROM saved_practical_questions');
    final questions = result
        .map((row) => {
              'id': row['id'],
              'question': row['question'],
              'code': row['code'],
              'answer': row['answer'],
              'explanation': row['explanation'],
            })
        .toList();
    await res.json(questions);
  }

  Future<void> deleteSavedPracticalQuestion(
      HttpRequest req, HttpResponse res) async {
    final id = int.tryParse(req.uri.queryParameters['id'] ?? '');
    if (id == null) {
      res.statusCode = 400;
      await res.json({'error': '유효하지 않은 ID'});
      return;
    }

    db.execute('DELETE FROM saved_practical_questions WHERE id = ?', [id]);
    await res.json({'status': 'deleted'});
  }
}
