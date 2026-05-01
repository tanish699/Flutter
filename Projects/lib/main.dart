import 'package:flutter/material.dart';
import 'package:registration_flow/pages/login.dart';
import 'package:registration_flow/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/images.dart';
import '../widgets/custombutton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString("email");


  runApp(MyApp(isLoggedIn: email != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  isLoggedIn ? const userProfile() : LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      // Nav bar
      appBar: AppBar(
          title: Text("Welcome Developer"),
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
                Text("Greetings Developer!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Text("We're excited to have you here!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
                SizedBox(height: 10,),
                Text("Congratulations on sucessfully setting up your first app!", textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                SizedBox(height: 30,),

                //Button
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    text: "Continue →",
                    width: 150,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => loginPage(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),

          ),

        ),

      ),
    );

  }
}
