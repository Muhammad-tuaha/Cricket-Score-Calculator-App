import 'package:flutter/material.dart';

class LiveScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Score')),
      body: Center(
        child: Text(
          'This is the Live Score page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
