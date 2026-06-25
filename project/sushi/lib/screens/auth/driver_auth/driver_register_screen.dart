import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/app_colors.dart';
import '../../../models/driver_model.dart';
import '../../../services/auth_service.dart';
import '../../../blocs/auth/auth_cubit.dart';
import '../../home/driver_home_screen.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _picker = ImagePicker();
  File? _selfie, _idFront, _idBack, _license;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isUploading = false;

  Future<void> _pickImage(String type) async {
    // Optimized settings for readable but small images
    final pickedFile = await _picker.pickImage(
      source: type == 'selfie' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70, // Compresses image by 30%
      maxWidth: 1200,   // Limits resolution to ensure text is readable but size is small
      maxHeight: 1200,
    );

    if (pickedFile != null) {
      setState(() {
        if (type == 'selfie') _selfie = File(pickedFile.path);
        if (type == 'idFront') _idFront = File(pickedFile.path);
        if (type == 'idBack') _idBack = File(pickedFile.path);
        if (type == 'license') _license = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadFile(File? file, String uid, String path) async {
    if (file == null) return null;
    // Using UID in path is more secure and helps with rules
    final ref = FirebaseStorage.instance.ref().child('drivers/$uid/$path.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  void _handleRegister() async {
    if (_selfie == null || _idFront == null || _idBack == null || _license == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload all required documents')));
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isUploading = true);
    
    try {
      // 1. Create Auth Account First (Fixes 403 error because user is now signed in)
      final userCredential = await _authService.createAuthAccount(email, password);
      final uid = userCredential?.user?.uid;

      if (uid != null) {
        // 2. Upload images using the UID
        final selfieUrl = await _uploadFile(_selfie, uid, 'selfie');
        final idFrontUrl = await _uploadFile(_idFront, uid, 'id_front');
        final idBackUrl = await _uploadFile(_idBack, uid, 'id_back');
        final licenseUrl = await _uploadFile(_license, uid, 'license');

        // 3. Save full driver data to Firestore
        final driver = DriverModel(
          uid: uid,
          name: name,
          email: email,
          phone: phone,
          profileImage: selfieUrl,
          nationalIdFront: idFrontUrl,
          nationalIdBack: idBackUrl,
          licenseImage: licenseUrl,
        );

        await _authService.saveProfileData('DeliveryDrivers', uid, driver.toJson());
        
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DriverHomeScreen()));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Driver Registration'), backgroundColor: const Color(0xFFF4A73D)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person))),
                TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
                TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)), obscureText: true),
                TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone))),
                const SizedBox(height: 30),
                
                _buildDocTile('Selfie with Face', _selfie, () => _pickImage('selfie')),
                _buildDocTile('National ID (Front)', _idFront, () => _pickImage('idFront')),
                _buildDocTile('National ID (Back)', _idBack, () => _pickImage('idBack')),
                _buildDocTile('Driving License', _license, () => _pickImage('license')),
                
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF4A73D)),
                    child: const Text('SUBMIT APPLICATION', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          if (_isUploading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator(color: Color(0xFFF4A73D))),
            ),
        ],
      ),
    );
  }

  Widget _buildDocTile(String title, File? file, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        trailing: file != null 
            ? const Icon(Icons.check_circle, color: Colors.green) 
            : const Icon(Icons.camera_alt_outlined, color: Color(0xFFF4A73D)),
        onTap: onTap,
      ),
    );
  }
}
