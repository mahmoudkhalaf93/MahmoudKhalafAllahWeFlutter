import 'package:flutter/material.dart';
import 'package:task1/calculator.dart';

void main() {
  MyApp a = MyApp();
  runApp(a);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator()
    );
  }
}
