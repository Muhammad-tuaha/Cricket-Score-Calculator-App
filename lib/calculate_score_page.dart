import 'package:flutter/material.dart';

class ScoreCalculationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Score Calculation')),
      body: Center(
        child: Text(
          'This is the Score Calculation page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
