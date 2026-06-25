import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sushi/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleInitialized = false;

  User? get currentUser => _auth.currentUser;

  Future<void> _ensureGoogleInitialized() async {
    if (!_isGoogleInitialized) {
      await _googleSignIn.initialize();
      _isGoogleInitialized = true;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  // Create Auth account only (no firestore yet)
  Future<UserCredential?> createAuthAccount(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  // Save specific collection data (users or drivers)
  Future<void> saveProfileData(String collection, String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(uid).set(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmail(String email, String password, UserModel userModel) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set(userModel.toJson());
      }
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _ensureGoogleInitialized();
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final clientAuth = await googleUser.authorizationClient.authorizationForScopes(['email', 'profile', 'openid']);
      final credential = GoogleAuthProvider.credential(
        accessToken: clientAuth?.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      await _updateUserDataInFirestore(userCredential.user);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        await _updateUserDataInFirestore(userCredential.user);
        return userCredential;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateUserDataInFirestore(User? user) async {
    if (user == null) return;
    DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      UserModel newUser = UserModel(
        name: user.displayName,
        email: user.email,
        phone: user.phoneNumber,
        image: user.photoURL,
      );
      await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
    }
  }

  // Get User Role (Shopper or Driver)
  Future<String?> getUserRole(String uid) async {
    // Check in DeliveryDrivers first
    final driverDoc = await _firestore.collection('DeliveryDrivers').doc(uid).get();
    if (driverDoc.exists) return 'driver';

    // Then check in users
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) return 'shopper';

    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }
}
