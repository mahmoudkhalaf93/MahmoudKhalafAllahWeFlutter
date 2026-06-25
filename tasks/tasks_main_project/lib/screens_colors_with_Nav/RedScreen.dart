import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Redscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Red")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: Text("Red"),
      ),
    );
  }
}
