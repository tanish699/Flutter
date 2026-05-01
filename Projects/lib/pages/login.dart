import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registration_flow/pages/userInfo.dart';
import 'package:registration_flow/utils/images.dart';
import 'package:registration_flow/widgets/custombutton.dart';
import 'package:registration_flow/widgets/textfield.dart';
import 'package:registration_flow/pages/userInfo.dart';


import '../widgets/custombutton.dart';


class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              AppImages.loginbg,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40,),

                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 40,),

                      // Email
                      CustomTextField(
                          label: "Email",
                          controller: emailController,
                      ),

                      const SizedBox(height: 20),

                      // Password
                      CustomTextField(
                          label: "Password",
                          controller: passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 30,),

                      //button
                      CustomButton(
                          text: "Login",
                          onTap: (){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => userinfo()
                                 ),
                             );
                          }
                      ),

                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );


  }
}

