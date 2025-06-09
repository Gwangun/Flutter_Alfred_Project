import 'package:sqlite3/sqlite3.dart';
import 'package:alfred/alfred.dart';

class WrittenService {
  final Database db;

  WrittenService(this.db);

  Future<void> getQuestions(HttpRequest req, HttpResponse res) async {
    final result = db.select('SELECT * FROM questions');
    final questions = result
        .map((row) => {
              'id': row['id'],
              'question': row['question'],
              'options': [
                row['choice1'],
                row['choice2'],
                row['choice3'],
                row['choice4']
              ],
              'answer': row['answer'],
              'explanation': row['explanation'],
            })
        .toList();
    await res.json(questions);
  }

  Future<void> saveQuestion(HttpRequest req, HttpResponse res) async {
    final id = int.tryParse(req.uri.queryParameters['id'] ?? '');
    if (id == null) {
      res.statusCode = 400;
      await res.json({'error': '유효하지 않은 문제 ID'});
      return;
    }

    final exists =
        db.select('SELECT * FROM saved_questions WHERE id = ?', [id]);
    if (exists.isNotEmpty) {
      await res.json({'status': 'already_exists'});
      return;
    }

    final result = db.select('SELECT * FROM questions WHERE id = ?', [id]);
    if (result.isEmpty) {
      res.statusCode = 404;
      await res.json({'error': '문제 없음'});
      return;
    }

    final row = result.first;
    db.execute('''
      INSERT INTO saved_questions (id, question, choice1, choice2, choice3, choice4, answer, explanation)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      row['id'],
      row['question'],
      row['choice1'],
      row['choice2'],
      row['choice3'],
      row['choice4'],
      row['answer'],
      row['explanation'],
    ]);

    await res.json({'status': 'saved'});
  }

  Future<void> saveWrongQuestion(HttpRequest req, HttpResponse res) async {
    final id = int.tryParse(req.uri.queryParameters['id'] ?? '');
    if (id == null) {
      res.statusCode = 400;
      await res.json({'error': '유효하지 않은 문제 ID'});
      return;
    }

    final exists =
        db.select('SELECT * FROM wrong_questions WHERE id = ?', [id]);
    if (exists.isNotEmpty) {
      await res.json({'status': 'already_exists'});
      return;
    }

    final result = db.select('SELECT * FROM questions WHERE id = ?', [id]);
    if (result.isEmpty) {
      res.statusCode = 404;
      await res.json({'error': '문제 없음'});
      return;
    }

    final row = result.first;
    db.execute('''
      INSERT INTO wrong_questions (id, question, choice1, choice2, choice3, choice4, answer, explanation)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      row['id'],
      row['question'],
      row['choice1'],
      row['choice2'],
      row['choice3'],
      row['choice4'],
      row['answer'],
      row['explanation'],
    ]);

    await res.json({'status': 'saved'});
  }

  Future<void> getSavedQuestions(HttpRequest req, HttpResponse res) async {
    final result = db.select('SELECT * FROM saved_questions');
    final questions = result
        .map((row) => {
              'id': row['id'],
              'question': row['question'],
              'choice1': row['choice1'],
              'choice2': row['choice2'],
              'choice3': row['choice3'],
              'choice4': row['choice4'],
              'answer': row['answer'],
              'explanation': row['explanation'],
            })
        .toList();
    await res.json(questions);
  }

  Future<void> getWrongQuestions(HttpRequest req, HttpResponse res) async {
    final result = db.select('SELECT * FROM wrong_questions');
    final questions = result
        .map((row) => {
              'id': row['id'],
              'question': row['question'],
              'choice1': row['choice1'],
              'choice2': row['choice2'],
              'choice3': row['choice3'],
              'choice4': row['choice4'],
              'answer': row['answer'],
              'explanation': row['explanation'],
            })
        .toList();
    await res.json(questions);
  }

  Future<void> deleteSavedQuestion(HttpRequest req, HttpResponse res) async {
    final id = int.tryParse(req.uri.queryParameters['id'] ?? '');
    if (id == null) {
      res.statusCode = 400;
      await res.json({'error': '유효하지 않은 id입니다'});
      return;
    }
    db.execute('DELETE FROM saved_questions WHERE id = ?', [id]);
    await res.json({'status': 'deleted'});
  }

  Future<void> deleteWrongQuestion(HttpRequest req, HttpResponse res) async {
    final id = int.tryParse(req.uri.queryParameters['id'] ?? '');
    if (id == null) {
      res.statusCode = 400;
      await res.json({'error': '유효하지 않은 id입니다'});
      return;
    }
    db.execute('DELETE FROM wrong_questions WHERE id = ?', [id]);
    await res.json({'status': 'deleted'});
  }
}
