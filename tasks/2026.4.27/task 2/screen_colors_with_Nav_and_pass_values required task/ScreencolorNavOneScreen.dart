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
    "colorName":"green from list"
  },
  {
    "color":Colors.yellow,
    "colorName":"yellow from list"
  },
  {
    "color":Colors.deepPurple,
    "colorName":"deepPurple from list"
  },
  {
    "color":Colors.yellow,
    "colorName":"yellow from list"
  },
  {
    "color":Colors.green,
    "colorName":"green from list"
  },
  {
    "color":Colors.yellow,
    "colorName":"yellow from list"
  },
];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          for(int i=0;i<listColors.length;i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: button(listColors[i]),
          )],
      ),
    );
  }

  Widget button(Map data) {

    return MaterialButton(
      padding: EdgeInsets.all(16),
      color: Colors.black,
      child: Text(data["colorName"], style: TextStyle(fontSize: 20, color: data["color"])),
      onPressed: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) =>  Colorscreen(data: data,) ),);

      },
    );
  }


}


