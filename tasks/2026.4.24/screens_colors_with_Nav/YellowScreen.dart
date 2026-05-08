import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Yellowscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("yellow")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellow,
        child: Text("yellow"),
      ),
    );
  }
}