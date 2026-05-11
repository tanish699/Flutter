import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= REGISTER =================

  Future<String?> registerUser({

    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String dob,
    required String gender,

  }) async {

    try {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({

        "uid": userCredential.user!.uid,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "dob": dob,
        "gender": gender,
      });

      return null;

    } on FirebaseAuthException catch (e) {

      debugPrint("Firebase error: ${e.message}",);
      return e.message;
    }  catch (e) {
      debugPrint(
        "Register Error: $e",
      );
      return e.toString();
    }
  }

  // ================= LOGIN =================

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        "Login Error: ${e.message}",
      );
      return false;
    }

  }
}