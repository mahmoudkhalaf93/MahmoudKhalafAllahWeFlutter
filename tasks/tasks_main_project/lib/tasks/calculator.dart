import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String result = "0";

  var buttons = [
    ["1", "2", "3", "ac", "c"],
    ["4", "5", "6", "/", "*"],
    ["7", "8", "9", "-", "+"],
    ["0", "00", "%", "√", "="],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(20),
              child: Text(
                result.startsWith('0')&& result.length>1 ? result.substring(1) : result,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          for (int i = 0; i < 4; i++)
            Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Row(
                children: [for (int j = 0; j < 5; j++) button(buttons[i][j])],
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
        ],
      ),
    );
  }

  Widget button(String value) {

    return MaterialButton(
      onPressed: () {
       
        if(value=="ac")
          result="0";
        
        else if(value=="c")
          result=result.substring(0,result.length-1);

        else
          result=result+value;

        setState(() {});
      },
      child: Container(
        child: Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        width: 90,
        height: 60,
        alignment: Alignment.center,
        color: (value == "=")?  Colors.red : Colors.black,
      ),
    );
  }
}
