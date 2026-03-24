import 'package:flutter/material.dart';
import 'utils/preferences.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FitQuestApp());
}

class FitQuestApp extends StatefulWidget {
  const FitQuestApp({super.key});

  @override
  _FitQuestAppState createState() => _FitQuestAppState();
}

class _FitQuestAppState extends State<FitQuestApp> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await Preferences.getTheme();
    if (!mounted) return;
    setState(() {
      _isDark = isDark;
    });
  }

  void _updateTheme(bool isDark) {
    setState(() {
      _isDark = isDark;
    });
    Preferences.saveTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDark: _isDark, onThemeChanged: _updateTheme),
    );
  }
}