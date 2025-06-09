# Dart SDK 이미지 사용
FROM dart:stable

# 작업 디렉토리 설정
WORKDIR /app

# 시스템 패키지 업데이트 및 SQLite 설치
RUN apt-get update && apt-get install -y libsqlite3-dev pkg-config

# pubspec 파일만 먼저 복사해서 의존성 설치
COPY pubspec.yaml ./
RUN dart pub get

# 모든 소스 복사
COPY . .

# 다시 pub get 실행 (lock 파일과 함께)
RUN dart pub get

# 포트 오픈
EXPOSE 3000

# 서버 실행 명령
CMD ["dart", "lib/main.dart"]
