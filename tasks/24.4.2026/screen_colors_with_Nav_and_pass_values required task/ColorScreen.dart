import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colorscreen extends StatelessWidget{
  Color color;
  String name;
  Colorscreen({this.color=Colors.white,this.name="white"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.name+" new one page")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: this.color,
        child: Text(this.name),
      ),
    );
  }
}