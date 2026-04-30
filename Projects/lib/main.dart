import 'package:flutter/material.dart';
import '../utils/images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  LandingPage(),
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
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => FormPage()),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Continue →"),
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
