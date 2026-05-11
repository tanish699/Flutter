import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custombutton.dart';
import 'home.dart';
import 'login.dart';

class WelcomePage extends StatelessWidget {

  final String firstName;

  const WelcomePage({
    super.key,
    required this.firstName,
  });

  // ================= LOGOUT =================

  Future<void> logout(BuildContext context) async {

    // Firebase logout
    await FirebaseAuth.instance.signOut();

    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to Login
    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder: (_) => const loginPage(),
      ),

          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade300,
      ),

      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              // ================= WELCOME TEXT =================

              Text(
                "Welcome $firstName",
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              // ================= LOGOUT =================

              CustomButton(

                text: "Logout",

                color: Colors.red,

                onTap: () {

                  logout(context);
                },
              ),


              // ================= GO TO HOME =================
              const SizedBox(height: 20),

              CustomButton(

                text: "Go To Home",
                color: Colors.orange,
                bordercolor: Colors.orange,

                onTap: () {

                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(
                      builder: (_) => home(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}