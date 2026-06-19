import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colorscreen extends StatelessWidget{
  Map data;
  Colorscreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.data["colorName"]+" new one page")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: this.data["color"],
        child: Text(this.data["colorName"]),
      ),
    );
  }
}