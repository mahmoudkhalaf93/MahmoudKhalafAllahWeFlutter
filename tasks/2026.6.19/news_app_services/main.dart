import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_main_project/tasksapp/home.dart';
import 'package:tasks_main_project/tasksapp/splash.dart';

import 'news_app_services/newsApp.dart';
import 'news_app_services/newsCubit.dart';
import 'tasks/counter.dart';


void main() {

 // MyApp a = MyApp();
  runApp(BlocProvider(
    create: (context) => NewsCubit()..getNews(), // السطر ده بيعمل الكوبيت ويشغل دالة جلب الأخبار فوراً أول ما التطبيق يفتح
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
