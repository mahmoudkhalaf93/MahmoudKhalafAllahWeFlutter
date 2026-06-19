import 'package:flutter/material.dart';




void main() {
  MyApp a = MyApp();
  runApp(a);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
