import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_colors.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _userData = UserModel.fromJson(doc.data()!);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A73D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFF4A73D)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header (Matching fragment_my_account.xml)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/layer_2_copy_5.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 50,
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _userData?.image != null
                                    ? CachedNetworkImage(
                                        imageUrl: _userData!.image!,
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset('assets/images/userpng.png', width: 130),
                                      )
                                    : Image.asset('assets/images/userpng.png', width: 130),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: const BoxDecoration(color: Color(0xFFF4A73D), shape: BoxShape.circle),
                                child: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // User Info Items (Matching the screenshot style)
                  _buildProfileItem(
                    Icons.person_outline, 
                    'Username', 
                    _userData?.name ?? '',
                    isVerified: false,
                  ),
                  _buildProfileItem(
                    Icons.email_outlined, 
                    'E-mail', 
                    _userData?.email ?? '',
                    isVerified: user?.emailVerified ?? false,
                  ),
                  _buildProfileItem(
                    Icons.phone_outlined, 
                    'Phone Number', 
                    _userData?.phone ?? '',
                    isVerified: true, // Assuming phone is verified in your logic
                  ),
                  _buildProfileItem(
                    Icons.lock_outline, 
                    'Password', 
                    '********',
                    isVerified: false,
                  ),
                  _buildProfileItem(
                    Icons.language, 
                    'Language', 
                    'English',
                    isVerified: false,
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value, {required bool isVerified}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 24),
          const SizedBox(width: 15),
          Text(title, style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
          if (isVerified) ...[
            const SizedBox(width: 10),
            const Icon(Icons.check_circle, color: Color(0xFF8BD875), size: 18),
          ],
          const Spacer(),
          Text(
            value, 
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }
}
