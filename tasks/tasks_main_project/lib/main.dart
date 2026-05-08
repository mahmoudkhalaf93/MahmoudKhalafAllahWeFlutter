import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tasks_main_project/tasksapp/home.dart';
import 'package:tasks_main_project/tasksapp/splash.dart';


void main() {
  MyApp a = MyApp();
  runApp(a);
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.trackpad,
          },
        ),
     home: Home(name: "mahmoud khalaf", image: "assets/images/tasks-icon-26.png")
     // home: Splash(),
    );
  }
}
