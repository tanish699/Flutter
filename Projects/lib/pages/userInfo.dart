import 'package:flutter/material.dart';
import '../database/database_helper.dart';

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

  // Load Data from db
  void loadData() async {
    final users = await DataBaseHelper.instance.getAllUsers();

    if (users.isNotEmpty) {
      final latestUser = users.last; // get last inserted user


      setState(() {
        firstName = latestUser['firstName'];
        lastName = latestUser['lastName'];
        email = latestUser['email'];
        contact = latestUser['contact'];
        dob = latestUser['dob'];
        gender = latestUser['gender'];
        country = latestUser['country'];
      });
    }
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


            Text("Hi, ${firstName ?? ""} ${lastName ?? ""}", style: TextStyle(fontSize: 22)),


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
