import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

/// DB 파일 열기
Map<String, Database> initDatabases() {
  final basePath = Directory.current.path;
  final questionsDbPath = p.join(basePath, 'bin', 'questions.db');
  final practicalDbPath = p.join(basePath, 'bin', 'practical_questions.db');

  final questionsDb = sqlite3.open(questionsDbPath);
  final practicalDb = sqlite3.open(practicalDbPath);

  return {'questions': questionsDb, 'practical': practicalDb};
}

/// 테이블 생성
void createTables(Database questionsDb, Database practicalDb) {
  // 필기 문제용 테이블
  questionsDb.execute('''
    CREATE TABLE IF NOT EXISTS saved_questions (
      id INTEGER PRIMARY KEY,
      question TEXT,
      choice1 TEXT,
      choice2 TEXT,
      choice3 TEXT,
      choice4 TEXT,
      answer INTEGER,
      explanation TEXT
    );
  ''');

  questionsDb.execute('''
    CREATE TABLE IF NOT EXISTS wrong_questions (
      id INTEGER PRIMARY KEY,
      question TEXT,
      choice1 TEXT,
      choice2 TEXT,
      choice3 TEXT,
      choice4 TEXT,
      answer INTEGER,
      explanation TEXT
    );
  ''');

  // 실기 문제용 테이블
  practicalDb.execute('''
    CREATE TABLE IF NOT EXISTS saved_practical_questions (
      id INTEGER PRIMARY KEY,
      question TEXT,
      code TEXT,
      answer TEXT,
      explanation TEXT
    );
  ''');
}
