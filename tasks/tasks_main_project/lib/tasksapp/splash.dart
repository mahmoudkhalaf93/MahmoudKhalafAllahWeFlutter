import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'mywidgets.dart';


class Splash extends StatefulWidget{
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _opacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
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
        
        body: AnimatedSize(
          duration: Duration(seconds: 5),
          child: AnimatedOpacity(
            opacity: _opacity, duration: Duration(seconds: 4),
            child: Container(alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircleAvatar(radius: 50,backgroundImage: AssetImage("assets/images/tasks-icon-26.png"),),mytext("Tick Tick",fontSize: 20,fontWeight: FontWeight.bold)],),
            ),
          ),
        )
    );
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // الصفحة اللي رايح لها
      );
    });
  }
}