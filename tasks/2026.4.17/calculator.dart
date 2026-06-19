import 'package:flutter/material.dart';

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.white,
        title: Text("we app"),
        centerTitle: true,
      ),
      backgroundColor: Colors.red,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: 500,
            height: 200,
            margin: EdgeInsets.all(20),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Row(
              children: [
                Container(

                  child: Text(
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "2",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "3",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "AC",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "Del",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,

                ),
              ],spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Row(
              children: [
                Container(

                  child: Text(
                    "4",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "5",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "6",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "+",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "-",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,

                ),
              ],spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Row(
              children: [
                Container(

                  child: Text(
                    "7",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "8",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "9",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "*",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "/",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,

                ),
              ],spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Row(
              children: [
                Container(

                  child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "^",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,
                ),
                Container(

                  child: Text(
                    "=",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 90,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.black,

                ),
              ],spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }
}
