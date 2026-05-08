import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Screencolor extends StatefulWidget {
  @override
  State<Screencolor> createState() => _ScreencolorState();
}

class _ScreencolorState extends State<Screencolor> {
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

        children: [button(Colors.red, "Red"),button(Colors.green, "green"),button(Colors.yellow, "yellow"),button(Colors.white, "reset")],
      ),
    );
  }

  Widget button(Color color, String name) {
    return MaterialButton(
padding: EdgeInsets.all(16),
      color: Colors.black,
      child: Text(name, style: TextStyle(fontSize: 20, color: color)),
      onPressed: () {
        bg = color;
        setState(() {});
      },
    );
  }
}
