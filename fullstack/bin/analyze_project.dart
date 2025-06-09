import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

void main() async {
  final dir = Directory('lib');
  if (!await dir.exists()) {
    stderr.writeln('❌ lib/ 디렉토리가 존재하지 않습니다.');
    exit(1);
  }

  final entities = await dir.list(recursive: true).toList();
  final files =
      entities
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();

  final int fileCount = files.length;
  int totalLines = 0;
  int classCount = 0;
  int methodInClassCount = 0;
  int topLevelFunctionCount = 0;
  int threadUsageCount = 0;

  for (var file in files) {
    final lines = await file.readAsLines();
    totalLines += lines.length;

    final content = lines.join('\n');
    final result = parseString(content: content, path: file.path);
    final unit = result.unit;

    for (var declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        classCount++;
        methodInClassCount +=
            declaration.members.whereType<MethodDeclaration>().length;
      } else if (declaration is FunctionDeclaration) {
        topLevelFunctionCount++;
      }
    }

    if (content.contains('Isolate') ||
        content.contains('compute') ||
        content.contains('Thread') ||
        content.contains('Future.')) {
      threadUsageCount++;
    }
  }

  stdout.writeln('\n📊 정적 분석 결과');
  stdout.writeln('---------------------------');
  stdout.writeln('📁 Dart 파일 개수              : $fileCount');
  stdout.writeln('📏 전체 코드 라인 수           : $totalLines');
  stdout.writeln('🏛️ 클래스 개수                : $classCount');
  stdout.writeln('🔧 클래스 내 메서드 수         : $methodInClassCount');
  stdout.writeln('🔓 클래스 외 전역 함수 수      : $topLevelFunctionCount');
  stdout.writeln('🧵 Thread 관련 키워드 사용 수   : $threadUsageCount\n');
}
