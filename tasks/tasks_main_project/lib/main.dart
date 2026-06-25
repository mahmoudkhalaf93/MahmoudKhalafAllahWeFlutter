import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'news_app_services/newsApp.dart';
import 'news_app_services/newsCubit.dart';
import 'tasks/counter.dart';


void main() {

 // MyApp a = MyApp();
  runApp(BlocProvider(
    create: (context) => NewsCubit()..getNews(),
    child: MyApp(),
  ),);
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
     //home: Home(name: "mahmoud khalaf", image: "assets/images/tasks-icon-26.png")
      home: NewsScreen(),
     // home: Splash(),
    );
  }
}
