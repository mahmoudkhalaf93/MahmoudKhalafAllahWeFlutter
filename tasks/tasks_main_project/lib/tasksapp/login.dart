import 'package:flutter/material.dart';

import 'home.dart';
import 'mywidgets.dart';

class Login extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String myemail = "mahmoud khalaf", mypassword = "1";

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
        backgroundColor: Colors.blueGrey,
        title: Text("we app"),
        centerTitle: true,
      ),
      //backgroundColor: Colors.red,
      body: Padding(
        padding: const EdgeInsetsGeometry.only(
          top: 150,
          bottom: 8,
          left: 8,
          right: 8,
        ),
        child: ListView(
          children: [
            // CircleAvatar(
            //   radius: 50,
            //   backgroundImage: AssetImage("assets/images/tasks-icon-26.png"),
            // )
            Image.asset(
              "assets/images/tasks-icon-26.png",
              height: 100,
              width: 100,
            ),
            mytext("Tick Tick", fontSize: 20, fontWeight: FontWeight.bold,textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: " Enter Email Address",
                  labelText: "Email",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.email),
                ),

                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: TextFormField(
                controller: password,
                decoration: InputDecoration(
                  hoverColor: Colors.red,
                  focusColor: Colors.red,
                  fillColor: Colors.red,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: " Enter Password",
                  labelText: "Password",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: Icon(Icons.remove_red_eye_rounded),
                ),

                keyboardType: TextInputType.emailAddress,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if ((email.text == myemail) && (password.text == mypassword))
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(
                          name: email.text,
                          image: "assets/images/user10.jpg",
                        ),
                      ),
                    );
                  else
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'wrong mail or password',
                          style: TextStyle(fontFamily: 'Cairo'),
                          textAlign: TextAlign.right,
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                },
                child: const Text("Login"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
