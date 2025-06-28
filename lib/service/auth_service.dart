import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // Step 1: Google sign-in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Step 2: Get Google Auth credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 3: Sign in with Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      // Step 4: Check if user already exists in Firestore
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        /// If the user doesn't exist, create a new user document
        if (!docSnapshot.exists) {
          final newUser = UserModel(
            email: user.email!,
            userName: user.displayName!,
            uid: user.uid,
            userProfile: user.photoURL!,
          );

          /// Set user data in Firestore (only if the user is new)
          await userDoc.set(newUser.toJson());
        }

        /// Return the existing user if the user exists in Firestore
        return user;
      }
      return null;
    } catch (error) {
      log("Google Sign-in failed: $error", name: 'AuthService');
      return null;
    }
  }

  /// Optional: Sign out method
   Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
