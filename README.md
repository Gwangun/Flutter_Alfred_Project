개요

이 프로젝트는 정보처리기사 실기 및 필기 문제를 Flutter 기반으로 연습할 수 있는 모바일 앱입니다. Flutter(MVVM 구조) + SQLite + Alfred 서버 구조로 구성되어 있으며, 사용자 경험 향상과 서버 통신 기능을 갖춘 학습 도우미 역할을 합니다.

![image](https://github.com/user-attachments/assets/104018d2-7de1-4369-bb8c-c65a40a1f699)

![image](https://github.com/user-attachments/assets/953e5cd3-c551-498b-a858-ba2b134643aa)

핵심 기능
*  로그인 / 회원가입 기능 
*  필기/실기 문제 연습 및 정답 확인
*  문제 저장 및 오답노트 기능
*  SQLite 기반 문제 로컬 저장 / 서버 연동

서버 연동
서버는 Alfred 프레임워크를 사용하며, 다음 기능을 REST API로 제공합니다:
* `/questions` → 필기 문제 목록 조회
* `/saved-questions` → 저장된 문제 목록 / 추가 / 삭제
* `/wrong-questions` → 오답 노트 문제 목록 / 추가 / 삭제
* `/practical-questions` → 실기 문제 목록 제공

실행 방법
1. 서버 실행
cd server

dart lib/main.dart
3. Flutter 앱 실행
flutter pub get

flutter run
