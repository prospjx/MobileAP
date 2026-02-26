import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final int fillColor;
  final int textColor;
  final double textSize;
  final Function callback;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.fillColor,
    required this.textColor,
    required this.textSize,
    required this.callback,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: SizedBox(
          width: 70,
          height: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(fillColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () {
              callback(text);
            },
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: Color(textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
