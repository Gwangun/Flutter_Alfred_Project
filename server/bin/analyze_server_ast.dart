import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

Future<void> main() async {
  final dirsToScan = ['lib', 'routes', 'services'];
  final files = <File>[];

  for (final dirName in dirsToScan) {
    final dir = Directory(dirName);
    if (await dir.exists()) {
      await for (var entity in dir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          files.add(entity);
        }
      }
    }
  }

  final mainFile = File('main.dart');
  if (await mainFile.exists()) {
    files.add(mainFile);
  }

  int classCount = 0;
  int methodCount = 0;
  int topLevelFunctionCount = 0;
  int threadCount = 0;
  int totalLines = 0;

  for (final file in files) {
    final content = await file.readAsString();
    totalLines += content.split('\n').length;

    final result = parseString(content: content, path: file.path);
    final unit = result.unit;

    for (var declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        classCount++;
        methodCount +=
            declaration.members.whereType<MethodDeclaration>().length;
      } else if (declaration is FunctionDeclaration) {
        topLevelFunctionCount++;
      }
    }

    final threadIndicators = [
      'Isolate.spawn',
      'compute',
      'Future.delayed',
      'Future.microtask',
      'Future.sync'
    ];
    for (final line in content.split('\n')) {
      if (threadIndicators.any((keyword) => line.contains(keyword))) {
        threadCount++;
      }
    }
  }

  // Microservice 수 = services 디렉토리 내 Dart 파일 수
  final servicesDir = Directory('services');
  int microserviceCount = 0;
  if (await servicesDir.exists()) {
    microserviceCount = await servicesDir
        .list()
        .where((f) => f is File && f.path.endsWith('.dart'))
        .length;
  }

  print('\n📊 AST 기반 서버 분석 결과');
  print('-----------------------------');
  print('📦 Microservice 개수        : $microserviceCount');
  print('📄 소스코드 파일 개수       : ${files.length}');
  print('📏 전체 라인 수             : $totalLines');
  print('🏛️ 클래스 수                : $classCount');
  print('🔧 클래스 내 메서드 수       : $methodCount');
  print('🔓 클래스 외 전역 함수 수    : $topLevelFunctionCount');
  print('🧵 Thread 사용 추정 횟수     : $threadCount\n');
}
