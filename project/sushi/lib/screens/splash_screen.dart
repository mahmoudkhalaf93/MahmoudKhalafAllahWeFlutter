import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth_service.dart';
import '../blocs/auth/auth_cubit.dart';
import 'auth/welcome_screen.dart';
import 'home/home_screen.dart';
import 'home/driver_home_screen.dart';

class SplashScreen extends StatefulWidget {
  final Future<FirebaseApp>? firebaseInit;
  const SplashScreen({super.key, this.firebaseInit});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // 1. Initialize light animations
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // 2. Start animation and logic after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _handleStartUp();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleStartUp() async {
    final minTime = Future.delayed(const Duration(milliseconds: 2000));

    try {
      // Wait for Firebase (started in main.dart)
      if (widget.firebaseInit != null) {
        await widget.firebaseInit;
      }

      // Now safe to access Firebase. Initialize Cubit check.
      if (!mounted) return;
      context.read<AuthCubit>().checkAuth();

      final user = FirebaseAuth.instance.currentUser;
      Widget target;

      if (user == null) {
        target = const WelcomeScreen();
      } else {
        final role = await AuthService().getUserRole(user.uid);
        target = (role == 'driver') ? const DriverHomeScreen() : const HomeScreen();
      }

      await minTime;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => target,
          transitionsBuilder: (context, anim1, anim2, child) {
            return FadeTransition(opacity: anim1, child: child);
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4A73D),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/layer_2.png', width: 120),
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
