import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/app_colors.dart';
import '../../../blocs/auth/auth_cubit.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../services/biometric_service.dart';
import '../../home/driver_home_screen.dart';
import 'driver_register_screen.dart';
import '../../home/home_screen.dart'; // Assume driver home will be handled

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final BiometricService _biometricService = BiometricService();

  void _handleBiometric() async {
    bool authenticated = await _biometricService.authenticate();
    if (authenticated && mounted) {
      // In a real app, you'd verify the UID with stored credentials
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometric Login Success')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DriverHomeScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Driver Login'), backgroundColor: AppColors.lightOrange),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => context.read<AuthCubit>().login(_emailController.text, _passwordController.text),
                child: const Text('LOGIN'),
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.fingerprint, size: 50, color: AppColors.lightOrange),
                onPressed: _handleBiometric,
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverRegisterScreen())),
                child: const Text('New Driver? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
