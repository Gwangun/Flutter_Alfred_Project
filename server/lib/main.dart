import 'package:alfred/alfred.dart';

import 'routes/auth_routes.dart';
import 'routes/written_routes.dart';
import 'routes/practical_routes.dart';
import 'utils/db_helper.dart';

void main() async {
  final app = Alfred();

  // DB 연결 및 테이블 초기화
  final dbs = initDatabases();
  final questionsDb = dbs['questions']!;
  final practicalDb = dbs['practical']!;
  createTables(questionsDb, practicalDb);

  // 각 Route 등록
  registerAuthRoutes(app);
  registerWrittenRoutes(app, questionsDb);
  registerPracticalRoutes(app, practicalDb);

  // 서버 실행
  await app.listen(3000);
  print('✅ 서버 실행 중: http://localhost:3000');
}
