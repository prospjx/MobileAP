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

class MyApp extends StatelessWidget {
  final String? firebaseError;

  const MyApp({super.key, this.firebaseError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: firebaseError == null
          ? const TaskListScreen()
          : FirebaseSetupErrorScreen(message: firebaseError!),
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
