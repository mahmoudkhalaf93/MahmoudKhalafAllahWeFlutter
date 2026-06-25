import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ColorScreen.dart';



class ScreencolorNavOneScreen extends StatefulWidget {
  @override
  State<ScreencolorNavOneScreen> createState() => _ScreencolorNavState();
}

class _ScreencolorNavState extends State<ScreencolorNavOneScreen> {
  Color bg = Colors.white;
List<Map> listColors=[

  {
    "color":Colors.red,
    "colorName":"red from list"
  },
  {
    "color":Colors.green,
    "colorName":"red from list"
  },
  {
    "color":Colors.yellow,
    "colorName":"red from list"
  },
];
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

        children: [
          for(int i=0;i<listColors.length;i++)
          button(listColors[i]["color"], listColors[i]["colorName"])],
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


