import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int num = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Counter", style: TextStyle(color: Colors.black, fontSize: 20)),
        Text(num.toString(),style: TextStyle(color: Colors.black,fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              child: Text(
                "+",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.black87,
              onPressed: () {
                num++;
                setState(() {});
              },
            ),
            MaterialButton(
              child: Text(
                "-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.black,
              onPressed: () {
                num--;
                setState(() {});
              },
            ),
          ],
        ),
        MaterialButton(
          child: Text(
            "reset",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          color: Colors.black,
          onPressed: () {
            num = 0;
            setState(() {});
          },
        ),
      ],
    );
  }
}
