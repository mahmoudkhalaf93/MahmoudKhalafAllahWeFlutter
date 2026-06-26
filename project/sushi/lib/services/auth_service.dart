import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sushi/models/user_model.dart';

class AuthService {
  // Use getters to avoid accessing .instance before Firebase.initializeApp()
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  
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

  Future<UserCredential?> createAuthAccount(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveProfileData(String collection, String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(uid).set(data, SetOptions(merge: true));
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
    return null;
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

  Future<String?> getUserRole(String uid) async {
    final driverDoc = await _firestore.collection('DeliveryDrivers').doc(uid).get();
    if (driverDoc.exists) return 'driver';

    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) return 'shopper';

    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
