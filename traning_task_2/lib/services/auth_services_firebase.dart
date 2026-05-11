import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    } catch (e) {

      print("Login Error: $e");
      return false;
    }
  }

  // ================= GET USER =================

  Future<Map<String, dynamic>?> getUser() async {

    try {

      User? user = _auth.currentUser;

      if (user == null) return null;

      final doc = await _firestore
          .collection("users")
          .doc(user.uid)
          .get();

      return doc.data();

    } catch (e) {

      print("Get User Error: $e");
      return null;
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {

    await _auth.signOut();
  }
}