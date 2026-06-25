import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ColorScreen.dart';



class ScreencolorNavOneScreen extends StatefulWidget {
  @override
  State<ScreencolorNavOneScreen> createState() => _ScreencolorNavState();
}

class _ScreencolorNavState extends State<ScreencolorNavOneScreen> {
  Color bg = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      width: double.infinity,
      height: double.infinity,

      color: bg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [button(Colors.red, "Red"),button(Colors.green, "green"),button(Colors.yellow, "yellow"),],
      ),
    );
  }

  Widget button(Color color, String name) {
    return MaterialButton(
      padding: EdgeInsets.all(16),
      color: Colors.black,
      child: Text(name, style: TextStyle(fontSize: 20, color: color)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  Colorscreen(color: color,name: name,) ),);

      },
    );
  }


}


