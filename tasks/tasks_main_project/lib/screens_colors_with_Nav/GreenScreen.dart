import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Greenscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Green")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green,
        child: Text("Green"),
      ),
    );
  }
}