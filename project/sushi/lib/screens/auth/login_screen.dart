import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/app_strings.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import 'package:sushi/services/biometric_service.dart';
import 'register_screen.dart';
import 'forget_password_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final BiometricService _biometricService = BiometricService();

  void _handleBiometric() async {
    bool authenticated = await _biometricService.authenticate();
    if (authenticated && mounted) {
      // In a real app, you would retrieve stored credentials
      // For now, we'll notify user. Biometric usually works after first successful login.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometric Authentication Successful!')));
      // Navigation would happen if we had stored user credentials
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Sushi Decoration
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset('assets/images/sign_in_background_suhi.png', width: 250),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign In !',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF322E2B),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Underline Username Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightOrange)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Underline Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightOrange)),
                          ),
                        ),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()));
                            },
                            child: const Text('Forget Password?', style: TextStyle(color: Colors.black54)),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              if (email.isNotEmpty && password.isNotEmpty) {
                                context.read<AuthCubit>().login(email, password);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text('Sign In', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // OR Divider
                        Row(
                          children: [
                            const Expanded(child: Divider(color: AppColors.lightOrange, thickness: 1.5)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('OR', style: TextStyle(color: Colors.orange.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            const Expanded(child: Divider(color: AppColors.lightOrange, thickness: 1.5)),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Social Login Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _socialButton('assets/images/google.png', () => context.read<AuthCubit>().loginWithGoogle()),
                            IconButton(
                              icon: const Icon(Icons.fingerprint, size: 50, color: Color(0xFFF4A73D)),
                              onPressed: _handleBiometric,
                            ),
                            _socialButton('assets/images/facebook.png', () {}),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Bottom Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account, "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                              },
                              child: const Text("Register?", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Loading Overlay
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator(color: AppColors.lightOrange)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath, VoidCallback? onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 35,
      child: Image.asset(assetPath, height: 60, fit: BoxFit.contain),
    );
  }
}
