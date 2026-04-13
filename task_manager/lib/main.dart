import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/screens/task_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? firebaseError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError catch (e) {
    firebaseError = e.message;
  } catch (e) {
    firebaseError = e.toString();
  }

  runApp(MyApp(firebaseError: firebaseError));
}

class MyApp extends StatefulWidget {
  final String? firebaseError;

  const MyApp({super.key, this.firebaseError});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleThemeMode() {
    setState(() {
      _themeMode = switch (_themeMode) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: widget.firebaseError == null
          ? TaskListScreen(
              themeMode: _themeMode,
              onToggleTheme: _toggleThemeMode,
            )
          : FirebaseSetupErrorScreen(message: widget.firebaseError!),
    );
  }
}

class FirebaseSetupErrorScreen extends StatelessWidget {
  final String message;

  const FirebaseSetupErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Firebase is not configured for this platform.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(message),
            const SizedBox(height: 12),
            const Text(
              'Run on Android or configure FlutterFire for your current platform.',
            ),
          ],
        ),
      ),
    );
  }
}
