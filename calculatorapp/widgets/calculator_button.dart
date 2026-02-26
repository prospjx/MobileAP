import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({super.key});


  @override
  Widget build(BuildContext context) {
    return Container( child: Padding(
              padding: EdgeInsets.all(5.0),
              child: SizedBox(
              width: 70,
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  // Handle button press
                },
                child: Text('9',
                style: TextStyle(fontSize: 24),),
              ),
            ),
            ),
            );
  }
}