import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ================= REGISTER =================

  Future<bool> register({

    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String dob,
    required String gender,

  }) async {

    try {

      // CREATE AUTH USER

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // SAVE USER DATA TO FIRESTORE

      await _firestore.collection("users").doc(uid).set({

        "uid": uid,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "dob": dob,
        "gender": gender,

      });

      return true;

    } catch (e) {

      print("Register Error: $e");
      return false;
    }
  }

  // ================= LOGIN =================

  Future<String?> login({

    required String email,
    required String password,

  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ================= GET USER DATA =================
      DocumentSnapshot userData = await _firestore.collection("users").doc(userCredential.user!.uid).get();
      // Return first name
      return userData["firstName"];
    }

    on FirebaseAuthException catch (e) {
      debugPrint("Login Error: ${e.message}",);
      return null;
    }
  }

  // ================= LOGOUT =================//

  Future<void> logout() async {
    await _auth.signOut();
  }
}