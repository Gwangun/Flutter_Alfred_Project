import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 📦 MVVM 구조로 나눈 View & ViewModel import
import 'views/login_view.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/home_view.dart';
import 'views/written_save_view.dart';
import 'views/wrong_note_view.dart';
import 'views/screen_view.dart'; // 시작화면 (Splash 또는 LoginView로 바꿔도 됨)

// ✅ RouteObserver 정의
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // 추후 다른 ViewModel도 여기에 등록
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver], // ✅ 여기에 RouteObserver 추가
      /// ✅ 앱 시작 화면
      home: const FigmaScreen(),
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomePage(),
        '/wrong': (context) => const WrongNotePage(),
        '/saved': (context) => const WrittenSavePage(),
      },
    );
  }
}
