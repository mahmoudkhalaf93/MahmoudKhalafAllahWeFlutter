import 'package:flutter/material.dart';
import 'package:tasks_main_project/old_tasks/ScreenColor.dart';
import 'package:tasks_main_project/screen_colors_with_Nav_and_pass_values/ScreencolorNavOneScreen.dart';




import 'old_tasks/calculator.dart';
import 'old_tasks/counter.dart';


void main() {
  MyApp a = MyApp();
  runApp(a);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.account_circle_outlined),
            actions: [
              IconButton(
                onPressed: () {
                  print("ok");
                },
                icon: Icon(Icons.access_time),
              ),
              InkWell(
                child: Icon(Icons.login),
                onTap: () {
                  print("login");
                },
              ),
              SizedBox(width: 10),
              InkWell(
                child: Icon(Icons.language),
                onTap: () {
                  print("arabic");
                },
              ),
            ],
            backgroundColor: Colors.blueGrey,
            title: Text("we app"),
            centerTitle: true,
          ),
          //backgroundColor: Colors.red,
          body: ScreencolorNavOneScreen()
      )
    );
  }
}
