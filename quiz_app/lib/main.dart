import 'package:flutter/material.dart';
import 'quiz_screen.dart';

/// Main entry point of the Quiz Application
/// 
/// IMPLEMENTATION GUIDE for main.dart:
/// 
/// This file serves as the root of your Flutter application.
/// 
/// Key components to implement:
/// 1. main() function - entry point that runs the app
/// 2. MyApp widget - root material app configuration
/// 3. Navigation to QuizScreen
///
/// Best practices:
/// - Keep main.dart simple - only app setup and routing
/// - Define app theme here (colors, fonts, etc.)
/// - Set up any global providers or services
/// - Handle navigation/routing

void main() {
  // STEP 1: Entry point of the application
  // This function is called first when the app starts
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // STEP 2: Root widget of the application
  // This widget defines the overall app structure and theme
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title (shown in system menus/recent apps)
      title: 'Quiz Master',
      
      // STEP 3: Define the app theme
      // This applies to all screens in the app
      theme: ThemeData(
        // Color scheme based on seed color (Material Design 3)
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        
        // App bar theme
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        
        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        // Text theme
        useMaterial3: true,
      ),
      
      // STEP 4: Set home screen
      // This is the first screen shown when app launches
      home: const QuizScreen(),
      
      // Optional: Debug banner can be removed
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Alternative: Structure with navigation/routing
/// 
/// If you want multiple screens, use named routes:
/// 
/// home: const MyHomePage(),
/// 
/// And define routes:
/// routes: {
///   '/quiz': (context) => const QuizScreen(),
///   '/results': (context) => const ResultsScreen(),
/// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. 
  // It is stateful, meaning it has a State object that contains fields 
  // that affect how it looks.

  // This class is the configuration for the state. It holds the values 
  // (in this case the title) provided by the parent (in this case the App widget) 
  // and used by the build method of the State.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
