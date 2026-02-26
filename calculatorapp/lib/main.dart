import 'package:flutter/material.dart';
import 'package:calculatorapp/widgets/calculator_button.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
        title: 'Flutter Calculator',
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    this.isDarkMode = true,
    this.onToggleTheme = _defaultVoidCallback,
    this.fillColor = 0xFFFFEB3B,
    this.textColor = 0xFF000000,
    this.textSize = 24.0,
    this.callback = _defaultCallback,
  });

  final String title;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final int fillColor;
  final int textColor;
  final double textSize;
  final Function callback;

  static void _defaultCallback() {}
  static void _defaultVoidCallback() {}

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int firstNum;
  late int secondNum;
  late String history = '';
  late String textToDisplay = '';
  late String res;
  late String operation;

  @override
  void initState() {
    super.initState();
    firstNum = 0;
    secondNum = 0;
    history = '';
    textToDisplay = '';
    res = '';
    operation = '';
  }

  void btnOnClick(String btnVal) {
    if (btnVal == 'C') {
      textToDisplay = '';
      firstNum = 0;
      secondNum = 0;
      res = '';
    } else if (btnVal == '+' || btnVal == '-' || btnVal == '*' || btnVal == '/') {
      firstNum = int.parse(textToDisplay);
      res = '';
      operation = btnVal;
    } else if (btnVal == '+-') {
      if (textToDisplay[0] != '-') {
        res = '-' + textToDisplay;
      } else {
        res = textToDisplay.substring(1);
      }
      textToDisplay = res;
    } else if (btnVal == '<') {
      res = textToDisplay.substring(0, textToDisplay.length - 1);
    } else if (btnVal == '=') {
      secondNum = int.parse(textToDisplay);
      if (operation == '+') {
        res = (firstNum + secondNum).toString();
        history = firstNum.toString() + operation.toString() + secondNum.toString();
      }
      if (operation == '-') {
        res = (firstNum - secondNum).toString();
        history = firstNum.toString() + operation.toString() + secondNum.toString();
      }
      if (operation == '*') {
        res = (firstNum * secondNum).toString();
        history = firstNum.toString() + operation.toString() + secondNum.toString();
      }
      if (operation == '/') {
        res = (firstNum / secondNum).toString();
        history = firstNum.toString() + operation.toString() + secondNum.toString();
      }
    } else {
      res = int.parse(textToDisplay + btnVal).toString();
    }

    setState(() {
      textToDisplay = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> backgroundColors = widget.isDarkMode
        ? const [Color(0xFF0A1A2F), Color(0xFF0F2D4A)]
        : const [Color(0xFFF7F9FC), Color(0xFFE6EEF7)];
    final Color historyColor = widget.isDarkMode
        ? const Color.fromARGB(255, 209, 212, 223)
        : const Color(0xFF455A64);
    final Color displayColor = widget.isDarkMode
        ? Colors.white
        : const Color(0xFF1F2937);
    final int numberFillColor = widget.isDarkMode ? 0xFF8AC4D0 : 0xFFBEE9F2;
    final int numberTextColor = widget.isDarkMode ? 0xFF000000 : 0xFF102A43;
    final int operatorFillColor = widget.isDarkMode ? 0xFFFFEB3B : 0xFFFDD835;
    final int operatorTextColor = 0xFF000000;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors,
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment(1.0, 1.0),
                child: Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    history,
                    style: TextStyle(fontSize: 24, color: historyColor),
                  ),
                ),
              ),
              Container(
                alignment: Alignment(1.0, 1.0),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    textToDisplay,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: displayColor,
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: 'C', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 20.0, callback: btnOnClick),
                  CalculatorButton(text: '+-', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 20.0, callback: btnOnClick),
                  CalculatorButton(text: '<', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 20.0, callback: btnOnClick),
                  CalculatorButton(text: '/', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '7', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '8', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '9', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '*', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '4', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '5', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '6', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '-', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '1', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '2', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '3', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '+', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '0', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '.', fillColor: numberFillColor, textColor: numberTextColor, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '=', fillColor: operatorFillColor, textColor: operatorTextColor, textSize: 24.0, callback: btnOnClick),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}