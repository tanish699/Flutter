import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= REGISTER =================

  Future<String?> registerUser({

    required String name,
    required String email,
    required String password,

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

        "name": name,
        "email": email,
        "uid": userCredential.user!.uid,
      });

      return null;

    } on FirebaseAuthException catch (e) {

      debugPrint(e.message);
      return e.message;
    }
  }
}