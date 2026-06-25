import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/app_colors.dart';
import 'login_screen.dart';
import 'driver_auth/driver_login_screen.dart';
import '../home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Background Section
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                padding: const EdgeInsets.only(bottom: 60),
                child: Image.asset(
                  'assets/images/sign_reg_background.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 100,
                child: Image.asset(
                  'assets/images/layer_2.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          Image.asset(
            'assets/images/sign_reg_sushi_image.png',
            width: 180,
            height: 120,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 70),

          // Role Selection: Shopper (Customer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Shoppers can enter as Guest immediately
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'I am a Shopper',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Role Selection: Driver
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverLoginScreen()));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.lightOrange, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delivery_dining, color: AppColors.lightOrange),
                    SizedBox(width: 10),
                    Text(
                      'I am a Driver',
                      style: TextStyle(color: AppColors.lightOrange, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Terms and Conditions',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
