import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(FitQuestApp());
}

class FitQuestApp extends StatefulWidget {
  const FitQuestApp({super.key});

  @override
  _FitQuestAppState createState() => _FitQuestAppState();
}

class _FitQuestAppState extends State<FitQuestApp> {
  final bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitQuest',
      debugShowCheckedModeBanner: false,
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(),
    );
  }
}