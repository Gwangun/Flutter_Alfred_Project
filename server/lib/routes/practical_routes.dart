import 'package:alfred/alfred.dart';
import 'package:sqlite3/sqlite3.dart';
import '../services/practical_service.dart';

void registerPracticalRoutes(Alfred app, Database db) {
  final service = PracticalService(db);

  app.get('/practical-questions', service.getPracticalQuestions);
  app.get('/practical-answer', service.getPracticalAnswer);
  app.post('/save-practical-question', service.savePracticalQuestion);
  app.get('/saved-practical-questions', service.getSavedPracticalQuestions);
  app.delete(
      '/delete-saved-practical-question', service.deleteSavedPracticalQuestion);
}
