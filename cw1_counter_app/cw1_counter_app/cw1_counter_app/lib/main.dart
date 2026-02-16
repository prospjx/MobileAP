import 'package:flutter/material.dart';

void main() {
  runApp(const CombinedApp());
}

class CombinedApp extends StatefulWidget {
  const CombinedApp({super.key});

  @override
  State<CombinedApp> createState() => _CombinedAppState();
}

class _CombinedAppState extends State<CombinedApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined Counter + Animation App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Counter system
  int _counter = 0;
  int _step = 1;
  int _goal = 50;
  List<int> _history = [];

  // Animation system
  bool _isFirstImage = true;
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start fully visible
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Counter logic
  void _pushHistory() {
    _history.insert(0, _counter);
    if (_history.length > 5) _history.removeLast();
  }

  void _increment() {
    _pushHistory();
    setState(() => _counter += _step);
  }

  void _decrement() {
    if (_counter == 0) return;
    _pushHistory();
    setState(() => _counter = (_counter - _step).clamp(0, 999999));
  }

  void _reset() {
    if (_counter == 0) return;
    _pushHistory();
    setState(() => _counter = 0);
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() => _counter = _history.removeAt(0));
  }

  void _toggleImage() async {
    // Fade out current image
    await _controller.reverse();

    // Swap image AFTER fade-out
    setState(() => _isFirstImage = !_isFirstImage);

    // Fade in new image
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_counter / _goal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Combined Counter + Animation'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                'Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _stepButton(1),
                  _stepButton(5),
                  _stepButton(10),
                ],
              ),

              const SizedBox(height: 8),
              Text("Current Step: $_step"),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: _increment, child: const Text('+')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _counter == 0 ? null : _decrement,
                    child: const Text('-'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _counter == 0 ? null : _reset,
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _history.isEmpty ? null : _undo,
                    child: const Text('Undo'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text("Goal: $_goal"),
              Slider(
                value: _goal.toDouble(),
                min: 10,
                max: 200,
                divisions: 19,
                label: "$_goal",
                onChanged: (v) => setState(() => _goal = v.toInt()),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade300,
                  color: progress >= 1.0 ? Colors.green : Colors.blue,
                ),
              ),

              if (progress >= 1.0)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "🎉 Goal Achieved!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

              const SizedBox(height: 24),

              FadeTransition(
                opacity: _fade,
                child: Image.asset(
                  _isFirstImage
                      ? 'assets/images/image1.png'
                      : 'assets/images/image2.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepButton(int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => setState(() => _step = value),
        child: Text('+$value'),
      ),
    );
  }
}
