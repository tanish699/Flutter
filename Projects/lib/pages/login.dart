import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registration_flow/pages/profile.dart';
import 'package:registration_flow/pages/registration.dart';
import 'package:registration_flow/pages/userInfo.dart';
import 'package:registration_flow/services/authentication.dart';
import 'package:registration_flow/utils/images.dart';
import 'package:registration_flow/widgets/custombutton.dart';
import 'package:registration_flow/widgets/textfield.dart';
import 'package:registration_flow/pages/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/emailvalidator.dart';
import '../widgets/custombutton.dart';
import 'package:registration_flow/utils/toastbar.dart';



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
                          onChanged: (value){
                            _formKey.currentState!.validate();
                          },
                        validator: Validator.validateEmail,
                      ),

                      const SizedBox(height: 20),

                      // Password
                      CustomTextField(
                          label: "Password",
                          controller: passwordController,
                          isPassword: true,
                        validator: (value){
                            if(value == null || value.isEmpty){
                              return "Password is required";
                            }
                            return null;
                        },
                      ),

                      const SizedBox(height: 30,),

                      //button
                      CustomButton(
                          text: "Login",
                          borderRadius: 10,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final authService = AuthService();

                              final isLoggedIn = await authService.login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if(isLoggedIn){

                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString("email", emailController.text.trim());

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => userProfile()
                                  ),
                                );
                              } else {
                                   FlushbarUtil.showError(context, "Invalid email or password");

                              }
                            }

                          }
                      ),

                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have account ?",
                            style: TextStyle(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],

                      )

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

