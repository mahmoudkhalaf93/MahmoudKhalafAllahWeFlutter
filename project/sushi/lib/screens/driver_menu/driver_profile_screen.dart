import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/driver_model.dart';
import '../../widgets/app_colors.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  DriverModel? _driver;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  void _loadDriverData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('DeliveryDrivers').doc(user.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _driver = DriverModel.fromJson(doc.data()!, doc.id);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFF4A73D)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/layer_2_copy_5.png', width: double.infinity, height: 180, fit: BoxFit.cover),
                      Positioned(
                        top: 30,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _driver?.profileImage != null
                                ? CachedNetworkImage(imageUrl: _driver!.profileImage!, width: 120, height: 120, fit: BoxFit.cover)
                                : const Icon(Icons.person, size: 120),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(_driver?.name ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Active Driver', style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold)),
                  
                  const SizedBox(height: 30),
                  _buildInfoItem(Icons.email_outlined, 'Email', _driver?.email ?? ''),
                  _buildInfoItem(Icons.phone_outlined, 'Phone', _driver?.phone ?? ''),
                  _buildInfoItem(Icons.verified_user_outlined, 'National ID', 'Verified', isVerified: true),
                  _buildInfoItem(Icons.drive_eta_outlined, 'License', 'Valid', isVerified: true),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value, {bool isVerified = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          if (isVerified) const Icon(Icons.check_circle, color: Color(0xFF8BD875), size: 18),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
