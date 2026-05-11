import 'package:flutter/material.dart';
// import 'package:registration_flow/pages/login.dart';
// import 'package:registration_flow/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traning_task_2/pages/home.dart';
import 'package:traning_task_2/pages/login.dart';
import 'package:traning_task_2/pages/userdetail.dart';
import '../utils/images.dart';
// import '../widgets/custombutton.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("accessToken");


  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  isLoggedIn ?  home() : loginPage(),
    );
    // return MaterialApp(home: LandingPage());
  }
}

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      // Nav bar
      appBar: AppBar(
          title: Text("Greetings Developer"),
          bottom: PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1,thickness: 1,))
      ),

      // main Screen
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(AppImages.welcome,width: 400,height: 400, fit: BoxFit.contain,),
                SizedBox(height: 20,),
                Text("We are excited to have you here!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                // Text("We're excited to have you here!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
                SizedBox(height: 10,),
                Text("This app is crafted to teach you the fundamentals and get you comfortable with building mobile applications using Flutter.!", textAlign: TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.grey), ),
                SizedBox(height: 30,),

                //Button
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: CustomButton(
                //     text: "Continue →",
                //     width: 150,
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => loginPage(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                SizedBox(height: 20),
              ],
            ),

          ),

        ),

      ),
    );

  }
}