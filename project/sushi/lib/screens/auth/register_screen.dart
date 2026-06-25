import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/app_strings.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../models/user_model.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

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
                  // Top Sushi Decoration (Same as Android selective_color_1)
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset('assets/images/selective_color_1.png', width: 250),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Register !',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF322E2B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildUnderlineField(_nameController, 'Username', Icons.person_outline),
                        _buildUnderlineField(_emailController, 'E-mail', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                        _buildUnderlineField(_passwordController, 'Password', Icons.lock_outline, obscureText: true),
                        _buildUnderlineField(_phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
                        
                        const SizedBox(height: 20),
                        
                        // Register Now Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              final name = _nameController.text.trim();
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              final phone = _phoneController.text.trim();
                              if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && phone.isNotEmpty) {
                                final userModel = UserModel(name: name, email: email, phone: phone);
                                context.read<AuthCubit>().register(email, password, userModel);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text('Register Now', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
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
                        
                        const SizedBox(height: 15),
                        
                        // Social Login Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _socialButton('assets/images/google.png', () => context.read<AuthCubit>().loginWithGoogle()),
                            _socialButton('assets/images/facebook.png', () {}),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Bottom Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account, "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                              },
                              child: const Text("Sign in?", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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

  Widget _buildUnderlineField(TextEditingController controller, String hint, IconData icon, {bool obscureText = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightOrange)),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath, VoidCallback? onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 35,
      child: Image.asset(assetPath, height: 65, fit: BoxFit.contain),
    );
  }
}
