import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  final int _maxLimit = 100;
  final int _targetValue = 50;
  String _message = '';

  final TextEditingController _incrementController = TextEditingController();
  int _customIncrement = 1;

  List<int> _history = [];
  final ScrollController _historyScrollController = ScrollController();

  void _scrollToBottom() {
    if (_historyScrollController.hasClients) {
      _historyScrollController.animateTo(
        _historyScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _addToHistory() {
    _history.add(_counter);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showSuccessDialog(int value) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Text('You reached the target value of $value!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _checkTarget() {
    if (_counter == _targetValue) {
      _showSuccessDialog(_targetValue);
    }
  }

  void _undo() {
    if (_history.isNotEmpty) {
      setState(() {
        _history.removeLast();
        _counter = _history.isNotEmpty ? _history.last : 0;
        _message = '';
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  Color _getCounterColor() {
    if (_counter == 0) {
      return Colors.red;
    } else if (_counter > 50) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }

  Color _getBackgroundColor() {
    if (_counter == 0) {
      return Colors.red.withOpacity(0.2);
    } else if (_counter > 50) {
      return Colors.green.withOpacity(0.2);
    } else {
      return Colors.blue.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: _getBackgroundColor(),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 50.0,
                  color: _getCounterColor(),
                ),
              ),
            ),
          ),

          Slider(
            min: 0,
            max: _maxLimit.toDouble(),
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
                _message = '';
                _addToHistory();
                _checkTarget();
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),

          if (_message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextField(
              controller: _incrementController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Custom Value',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  if (int.tryParse(value) != null) {
                    _customIncrement = int.parse(value);
                  } else {
                    _customIncrement = 1;
                  }
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔴 Decrement Button (Red)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: _counter > 0
                    ? () {
                        setState(() {
                          _counter -= _customIncrement;
                          if (_counter < 0) _counter = 0;
                          _message = '';
                          _addToHistory();
                          _checkTarget();
                        });
                      }
                    : null,
                child: const Text(
                  'Decrement',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(width: 20),

              // Reset
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter = 0;
                    _message = '';
                    _addToHistory();
                    _checkTarget();
                  });
                },
                child: const Text('Reset'),
              ),

              const SizedBox(width: 20),

              // 🟢 Increment Button (Green)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    if (_counter + _customIncrement <= _maxLimit) {
                      _counter += _customIncrement;
                      _message = '';
                    } else {
                      _counter = _maxLimit;
                      _message = 'Maximum limit reached!';
                    }
                    _addToHistory();
                    _checkTarget();
                  });
                },
                child: const Text(
                  'Increment',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(width: 20),

              // Undo
              ElevatedButton(
                onPressed: _history.length > 1 ? _undo : null,
                child: const Text('Undo'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'Counter History:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 150,
            child: ListView.builder(
              controller: _historyScrollController,
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Value: ${_history[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
