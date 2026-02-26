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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: const MyHomePage(title: 'Flutter Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    this.fillColor = 0xFFFFEB3B,
    this.textColor = 0xFF000000,
    this.textSize = 24.0,
    this.callback = _defaultCallback,
  });

  final String title;
  final int fillColor;
  final int textColor;
  final double textSize;
  final Function callback;

  static void _defaultCallback() {}

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1A2F),
              Color(0xFF0F2D4A),
            ],
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
                    style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 209, 212, 223)),
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: 'C', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 20.0, callback: btnOnClick),
                  CalculatorButton(text: '+-', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 20.0, callback: btnOnClick),
                  CalculatorButton(text: '<', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 20.0, callback: btnOnClick),
                  CalculatorButton(text: '/', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '7', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '8', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '9', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '*', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '4', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '5', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '6', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '-', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '1', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '2', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '3', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '+', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CalculatorButton(text: '0', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '.', fillColor: 0xFF8ac4d0, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                  CalculatorButton(text: '=', fillColor: 0xFFFFEB3B, textColor: 0xFF000000, textSize: 24.0, callback: btnOnClick),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}