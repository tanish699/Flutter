import 'package:flutter/material.dart';
import 'package:traning_task_2/pages/home.dart';
import '../services/email_services.dart';
import '../services/passEncryptor.dart';
import '../utils/emailvalidator.dart';
import '../utils/images.dart';
import '../utils/toastbar.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/custom_date_field.dart';
import '../widgets/custom_radio_group.dart';
import '../widgets/custombutton.dart';
import '../widgets/textfield.dart';
import '../services/auth_services_firebase.dart';
import 'dart:math';

import 'otp_verification_page.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Variables
  String? selectedGender;
  bool showGenderError = false;
  bool isChecked = false;
  bool showCheckboxError = false;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  // To generate OTP
  String generateOtp() {

    Random random = Random();

    return (100000 + random.nextInt(900000))
        .toString();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    contactController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // key: formKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.registrationHeader),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    SizedBox(height: 120),
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),
                    Text("Create your new account"),
                    SizedBox(height: 30),

                    // First Name Text Field
                    CustomTextField(
                      label: "First Name *",
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "First Name is required";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    //Last Name Text Field
                    CustomTextField(
                      label: "Last Name",
                      controller: lastNameController,
                    ),

                    SizedBox(height: 20),

                    // Email Text Field
                    CustomTextField(
                      label: "Email *",
                      controller: emailController,
                      validator: Validator.validateEmail,
                    ),

                    //Contact Number field
                    SizedBox(height: 20),

                    CustomTextField(
                      label: "Contact Number",
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (value.length < 10) return "Enter valid number";
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // Age selecter
                    CustomDateField(
                      label: "Date of Birth *",
                      controller: dobController,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      onDateSelected: (pickedDate) {
                        int calculateAge(DateTime dob) {
                          final today = DateTime.now();
                          int age = today.year - dob.year;
                          if (today.month < dob.month ||
                              (today.month == dob.month && today.day < dob.day)) {
                            age--;
                          }
                          return age;
                        }
                        final age = calculateAge(pickedDate);
                        if (age < 18) {
                          dobController.clear();
                          FlushbarUtil.showError(context, "Must be 18+");
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Date of Birth is required";
                        }
                        return null;
                      },
                    ),


                    // Radio buttons
                    SizedBox(height: 20),

                    CustomRadioGroup(
                      options: ["Male", "Female", "Others"],
                      selectedValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                          showGenderError = false;
                        });
                      },
                    ),
                    if (showGenderError)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please select gender",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                    // Passwords
                    SizedBox(height: 20),

                    CustomTextField(
                      label: "Password *",
                      controller: passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Password required";
                        if (value.length < 6) return "Min 6 chars";
                        return null;
                      },
                    ),

                    // confirm Password
                    SizedBox(height: 20),

                    CustomTextField(
                      label: "Confirm Password *",
                      controller: confirmPasswordController,
                      isPassword: true,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    // T&C cgheckbox
                    SizedBox(height: 20),

                    CustomCheckbox(
                      value: isChecked,
                      showError: showCheckboxError,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                          showCheckboxError = false;
                        });
                      },
                    ),

                    // Box
                    SizedBox(height: 30),

                    CustomButton(
                      text: "Register",
                      onTap: () async {
                        if (isLoading) return;

                        setState(() {

                          isLoading = true;

                        });
                        setState(() {
                          showGenderError = selectedGender == null;
                          showCheckboxError = !isChecked;
                        });

                        bool isFormValid =
                            formKey.currentState?.validate() ?? false;

                        bool isGenderValid = selectedGender != null;

                        bool isTermsAccepted = isChecked;

                        if (isFormValid &&
                            isGenderValid &&
                            isTermsAccepted) {

                          try {

                            // ================= API CALL =================

                            bool success = await _authService.register(

                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text.trim().toLowerCase(),
                              password: passwordController.text.trim(),

                              phone: contactController.text,
                              dob: dobController.text,
                              gender: selectedGender!,
                            );

                            if (success) {
                              // ================= GENERATE OTP =================
                              String otp = generateOtp();
                              debugPrint("OTP: $otp");
                              // ================= SEND EMAIL =================
                              final emailService = EmailService();

                              bool emailSent = await emailService.sendOtpEmail(
                                toEmail: emailController.text.trim(),
                                otp: otp,
                              );
                              print("EMAIL SENT STATUS: $emailSent");

                              FlushbarUtil.showSuccess(
                                context,

                                "Registered Successfully",
                              );

                              if (emailSent) {

                                FlushbarUtil.showSuccess(
                                  context,
                                  "OTP Sent Successfully",
                                );

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) => OtpVerificationPage(
                                      generatedOtp: otp,
                                    ),
                                  ),
                                );

                              } else {

                                FlushbarUtil.showError(
                                  context,
                                  "Failed to send OTP email",
                                );
                              }

                            } else {

                              FlushbarUtil.showError(
                                context,
                                "Registration Failed",
                              );
                            }

                          } catch (e) {

                            FlushbarUtil.showError(
                              context,
                              "Something went wrong",
                            );
                          }

                        } else {

                          FlushbarUtil.showError(
                            context,
                            "Please fill all fields correctly",
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}