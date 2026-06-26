import 'package:flutter/material.dart';
import '../../widgets/app_colors.dart';

class AboutUsScreen extends StatelessWidget {
  final bool isShell;
  const AboutUsScreen({super.key, this.isShell = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isShell ? null : AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.lightOrange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/layer_2_copy_5.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Image.asset('assets/images/layer_2.png', width: 100, height: 100),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoTile('About Us:', 'this app developed by mahmoud khalaf allah mohamed elsayd'),
            _buildInfoTile('Phone:', '+201064587878'),
            _buildInfoTile('Email:', 'mahmoudkhalafeg93@gmail.com'),
            _buildInfoTile('LinkedIn:', 'www.linkedin.com/in/mahmoudkhalaf1/'),
            _buildInfoTile('GitHub:', 'github.com/mahmoudkhalaf93'),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/shopping_cart_background.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.lightOrange, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SelectableText(content, style: const TextStyle(color: AppColors.lightOrange, fontSize: 16)),
        ],
      ),
    );
  }
}
