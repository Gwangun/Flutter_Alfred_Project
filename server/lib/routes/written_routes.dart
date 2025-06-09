import 'package:alfred/alfred.dart';
import 'package:sqlite3/sqlite3.dart';
import '../services/written_service.dart';

void registerWrittenRoutes(Alfred app, Database db) {
  final writtenService = WrittenService(db);

  app.get('/questions', writtenService.getQuestions);
  app.post('/save-question', writtenService.saveQuestion);
  app.post('/save-wrong-question', writtenService.saveWrongQuestion);
  app.get('/saved-questions', writtenService.getSavedQuestions);
  app.get('/wrong-questions', writtenService.getWrongQuestions);
  app.delete('/delete-saved-question', writtenService.deleteSavedQuestion);
  app.delete('/delete-wrong-question', writtenService.deleteWrongQuestion);
}
