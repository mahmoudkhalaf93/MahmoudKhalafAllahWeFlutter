import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GreenScreen.dart';
import 'RedScreen.dart';
import 'YellowScreen.dart';

class ScreencolorNav extends StatefulWidget {
  @override
  State<ScreencolorNav> createState() => _ScreencolorNavState();
}

class _ScreencolorNavState extends State<ScreencolorNav> {
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

        children: [button(Colors.red, "Red",Redscreen()),button(Colors.green, "green",Greenscreen()),button(Colors.yellow, "yellow",Yellowscreen()),],
      ),
    );
  }

  Widget button(Color color, String name,Widget screen) {
    return MaterialButton(
      padding: EdgeInsets.all(16),
      color: Colors.black,
      child: Text(name, style: TextStyle(fontSize: 20, color: color)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  screen ),);

      },
    );
  }


}


