import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up method
  Future<UserCredential> signUpWithEmailAndPassword
  (String username, 
  String email, 
  String password) async {
    try {
      // Create a new user with the given email and password
      UserCredential credential = 
        await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firestore.collection("users").doc(credential.user!.uid).set({
        'uid' : credential.user!.uid,
        'email' : email,
      });

      // Store user data in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now(),
      });


      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign In method
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Sign in the user with the provided email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid' : userCredential.user!.uid,
        'email' : email,
      }, SetOptions(merge: true));
    
     return userCredential;
    }
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  // sign user out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
