import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registration_flow/pages/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../services/passEncryptor.dart';
import '../utils/countries.dart';
import '../utils/emailvalidator.dart';
import '../utils/images.dart';
import '../utils/toastbar.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/custom_date_field.dart';
import '../widgets/custom_radio_group.dart';
import '../widgets/custombutton.dart';
import '../widgets/textfield.dart';
import 'package:registration_flow/widgets/customdropdown.dart';

SharedPreferences? prefs;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Variables
  String? selectedGender;
  bool showGenderError = false;
  Country? selectedCountry;
  bool isChecked = false;
  bool showCheckboxError = false;

  final formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
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

                    // Country DropDown
                    SizedBox(height: 20),
                    CustomDropdown<Country>(
                      label: "Select Country *",
                      value: selectedCountry,
                      items: countryList.map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(country.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedCountry = value);
                      },
                      validator: (value) =>
                          value == null ? "Select country" : null,
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
                        setState(() {
                          showGenderError = selectedGender == null;
                          showCheckboxError = !isChecked;
                        });

                        bool isFormValid =
                            formKey.currentState?.validate() ?? false;

                        bool isGenderValid = selectedGender != null;

                        bool isCountryValid = selectedCountry != null;

                        bool isTermsAccepted = isChecked;

                        if (isFormValid &&
                            isGenderValid &&
                            isCountryValid &&
                            isTermsAccepted) {
                          final hashedPassword = HashUtil.hashPassword(
                            passwordController.text,
                          );

                          final user = {
                            'firstName': firstNameController.text,
                            'lastName': lastNameController.text,
                            'email': emailController.text.trim(),
                            'contact': contactController.text,
                            'dob': dobController.text,
                            'gender': selectedGender,
                            'country': selectedCountry!.name,
                            'password': hashedPassword,
                          };

                          await DataBaseHelper.instance.insertUser(user);

                          // ✅ Save email to SharedPrefs
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                            "email",
                            emailController.text.trim(),
                          );

                          FlushbarUtil.showSuccess(
                            context,
                            "Registered successfully",
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => userinfo()),
                          );
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
