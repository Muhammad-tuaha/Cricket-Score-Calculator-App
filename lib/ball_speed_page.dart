import 'package:flutter/material.dart';

class BallSpeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ball Speed Calculation')),
      body: Center(
        child: Text(
          'This is the Ball Speed Calculation page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
