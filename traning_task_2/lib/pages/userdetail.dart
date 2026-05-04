import 'package:flutter/material.dart';
import 'package:traning_task_2/pages/login.dart';
// import '../database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_services.dart';


class userinfo extends StatefulWidget {

  @override
  State<userinfo> createState() => _userinfoState();
}

class _userinfoState extends State<userinfo> {
  String? email;
  String? contact;
  String? dob;
  String? gender;
  String? country;
  String? firstName;
  String? lastName;


  @override
  void initState(){
    super.initState();
    loadData();
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString("firstName");
      lastName  = prefs.getString("lastName");
      email     = prefs.getString("email");
    });

    final authService = AuthService();
    final user = await authService.getUser();

    if (user != null) {
      setState(() {
        firstName = user['firstName'];
        lastName  = user['lastName'];
        email     = user['email'];
        contact   = user['phone'];    // dummyjson uses 'phone'
        dob       = user['birthDate'];
        gender    = user['gender'];
        country   = user['address']?['country'];
      });
    }
  }

  // Logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () async {
                await _logout();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear(); // clear session

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => loginPage()),
          (route) => false,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hi, ${firstName ?? ""} ${lastName ?? ""}", style: TextStyle(fontSize: 22)),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    _showLogoutDialog();
                  },
                ),
              ],
            ),


            SizedBox(height: 30),


            Center(
              child: Icon(Icons.assignment_ind, color: Colors.orange, size: 120),
            ),


            SizedBox(height: 20),


            Center(
              child: Text(
                "Welcome to the Developer Community", style: TextStyle(fontSize: 18),
              ),
            ),


            SizedBox(height: 30),
            Text("My Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),


            SizedBox(height: 20),
            Text("Email Address    ${email ?? ""}"),


            SizedBox(height: 10),
            Text("Contact Number    ${contact ?? ""}"),

            SizedBox(height: 10),
            Text("Date of Birth    ${dob ?? ""}"),

            SizedBox(height: 10),
            Text("Gender           ${gender ?? ""}"),

            SizedBox(height: 10),
            Text("Country          ${country ?? ""}"),
          ],
        ),
      ),
    );


  }
}