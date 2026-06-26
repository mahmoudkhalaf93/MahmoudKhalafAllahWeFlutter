import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../models/user_model.dart';
import '../../widgets/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final bool isShell;
  const ProfileScreen({super.key, this.isShell = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userData;
  bool _isLoading = true;
  bool _isUploading = false;
  final _picker = ImagePicker();

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

  Future<void> _updateProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image == null) return;

    setState(() => _isUploading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance.ref().child('users/${user!.uid}/profile.jpg');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'image': url});
      _loadUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _editField(String field, String currentValue, bool isVerified) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit ${field.toUpperCase()}',
          style: const TextStyle(color: Color(0xFFF4A73D), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller, 
              decoration: InputDecoration(
                hintText: 'Enter new $field',
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF4A73D))),
              ),
              keyboardType: field == 'phone' ? TextInputType.phone : TextInputType.text,
            ),
            if (!isVerified && (field == 'name' || field == 'phone')) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to send verification
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification link sent!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BD875),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('ACTIVATE / VERIFY', style: TextStyle(color: Colors.white)),
                ),
              ),
            ]
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({field: controller.text});
              Navigator.pop(context);
              _loadUserData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF4A73D)),
            child: const Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _changePassword() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link sent to your email!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: widget.isShell ? null : AppBar(
        title: const Text('My Account', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFF4A73D),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFF4A73D)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // --- Header Section (Clipped + Overlapping Profile Pic) ---
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // imageView7: Background Header (Shows bottom half)
                      ClipRect(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: 0.5,
                          child: Image.asset(
                            'assets/images/layer_2_copy_5.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Profile Pic Stack - Positioned to be half-in, half-out
                      Positioned(
                        bottom: -70, // Push half outside the clipped background
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // White border circle (using ellipse asset feel or Container)
                            Container(
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                              ),
                            ),
                            
                            // Actual Profile Pic
                            Container(
                              width: 137,
                              height: 137,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _userData?.image != null
                                  ? CachedNetworkImage(
                                      imageUrl: _userData!.image!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover),
                                    )
                                  : Image.asset('assets/images/backgroud_logo.png', fit: BoxFit.cover),
                            ),
                            
                            // Edit Pen Button
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: _isUploading ? null : _updateProfileImage,
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4A73D),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 4),
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                            if (_isUploading)
                              const CircularProgressIndicator(color: Color(0xFFF4A73D)),
                          ],
                        ),
                      ),
                      
                      // Back Button only if NOT shell
                      if (!widget.isShell)
                        Positioned(
                          top: 40,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black54),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 100), // Space for the half-out profile pic

                  // --- Data Rows ---
                  
                  _buildXmlRow(
                    label: 'Username',
                    value: _userData?.name ?? '',
                    isVerified: true, // Example logic
                    onTap: () => _editField('name', _userData?.name ?? '', true),
                  ),

                  _buildXmlRow(
                    label: 'E-mail',
                    value: _userData?.email ?? '',
                    isVerified: FirebaseAuth.instance.currentUser?.emailVerified ?? false,
                    onTap: () => _editField('email', _userData?.email ?? '', FirebaseAuth.instance.currentUser?.emailVerified ?? false),
                  ),

                  _buildXmlRow(
                    label: 'Phone Number',
                    value: _userData?.phone ?? 'Set Phone',
                    isVerified: false, // Set to false to test "ACTIVATE"
                    onTap: () => _editField('phone', _userData?.phone ?? '', false),
                  ),

                  _buildXmlRow(
                    label: 'Password',
                    value: '********',
                    onTap: _changePassword,
                  ),

                  _buildXmlRow(
                    label: 'Language',
                    value: context.watch<SettingsCubit>().state.locale.languageCode == 'en' ? 'English' : 'العربية',
                    onTap: () {
                      final cubit = context.read<SettingsCubit>();
                      cubit.setLanguage(cubit.state.locale.languageCode == 'en' ? 'ar' : 'en');
                    },
                  ),

                  _buildXmlRow(
                    label: 'Dark Mode',
                    value: isDark ? 'ON' : 'OFF',
                    onTap: () => context.read<SettingsCubit>().toggleTheme(),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget _buildXmlRow({
    required String label, 
    required String value, 
    bool? isVerified,
    VoidCallback? onTap
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rowBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: rowBg,
        child: Row(
          children: [
            // Label
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'calibril'),
            ),

            // Verification Icon (Green Check or Gray X)
            if (isVerified != null) ...[
              const SizedBox(width: 8),
              Icon(
                isVerified ? Icons.check_circle : Icons.cancel,
                color: isVerified ? const Color(0xFF8BD875) : Colors.grey.shade400,
                size: 20,
              ),
            ],

            const Spacer(),

            // Value
            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.end,
                softWrap: false,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontFamily: 'calibril',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
