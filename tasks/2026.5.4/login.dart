import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(
        top: 150,
        bottom: 8,
        left: 8,
        right: 8,
      ),
      child: ListView(

        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/user1.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              "Login",textAlign: TextAlign.center,
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

              },
              child: const Text("Login"),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.grey[700]),
              ),
              TextButton(
                onPressed: () {
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
