import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../services/passEncryptor.dart';
import '../utils/countries.dart';
import '../utils/toastbar.dart';
import '../widgets/custombutton.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? email;
  String? selectedGender;
  Country? selectedCountry;

  bool changePassword = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("email");

    if (savedEmail == null) return;

    final user =
    await DataBaseHelper.instance.getUserByEmail(savedEmail);

    if (user != null) {
      setState(() {
        email = user['email'];
        firstNameController.text = user['firstName'];
        lastNameController.text = user['lastName'];
        contactController.text = user['contact'] ?? "";
        dobController.text = user['dob'] ?? "";
        selectedGender = user['gender'];
        selectedCountry = countryList
            .firstWhere((c) => c.name == user['country']);

        isLoading = false;
      });
    }
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DataBaseHelper.instance.database;

    Map<String, dynamic> updatedData = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'contact': contactController.text,
      'dob': dobController.text,
      'gender': selectedGender,
      'country': selectedCountry?.name,
    };

    if (changePassword) {
      final hashedPassword =
      HashUtil.hashPassword(passwordController.text);
      updatedData['password'] = hashedPassword;
    }

    await db.update(
      'users',
      updatedData,
      where: 'email = ?',
      whereArgs: [email],
    );

    // FlushbarUtil.showSuccess(context, "Profile Updated");

    Navigator.pop(context); // go back
    Future.delayed(const Duration(milliseconds: 200), () {

      FlushbarUtil.showSuccess(context, "Profile Updated");

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // 👤 Profile
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person,
                      size: 60, color: Colors.white),
                ),

                const SizedBox(height: 20),

                // First Name
                TextFormField(
                  controller: firstNameController,
                  decoration:
                  const InputDecoration(labelText: "First Name"),
                  validator: (v) =>
                  v!.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 15),

                // Last Name
                TextFormField(
                  controller: lastNameController,
                  decoration:
                  const InputDecoration(labelText: "Last Name"),
                ),

                const SizedBox(height: 15),

                // Contact
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration:
                  const InputDecoration(labelText: "Contact"),
                ),

                const SizedBox(height: 15),

                // DOB
                TextFormField(
                  controller: dobController,
                  readOnly: true,
                  decoration:
                  const InputDecoration(labelText: "Date of Birth"),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      dobController.text =
                          DateFormat('dd/MM/yyyy').format(picked);
                    }
                  },
                ),

                const SizedBox(height: 15),

                // Country
                DropdownButtonFormField<Country>(
                  value: selectedCountry,
                  items: countryList.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedCountry = val);
                  },
                  decoration: const InputDecoration(
                      labelText: "Country"),
                ),

                const SizedBox(height: 15),

                // Gender
                Row(
                  children: ["Male", "Female", "Other"]
                      .map((g) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = g;
                        });
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<String>(
                            value: g,
                            groupValue: selectedGender,
                            onChanged: (val) {
                              setState(() {
                                selectedGender = val;
                              });
                            },
                            activeColor: Colors.orange,
                            visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          Flexible(
                            child: Text(
                              g,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                      .toList(),
                ),

                // Change password
                CheckboxListTile(
                  value: changePassword,
                  onChanged: (val) {
                    setState(() {
                      changePassword = val!;
                    });
                  },
                  title: const Text("Change Password"),
                ),

                if (changePassword) ...[
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration:
                    const InputDecoration(labelText: "Password"),
                    validator: (v) {
                      if (!changePassword) return null;
                      if (v == null || v.length < 6) {
                        return "Min 6 chars";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Confirm Password"),
                    validator: (v) {
                      if (changePassword &&
                          v != passwordController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 30),

                CustomButton(
                  text: "Update",
                  onTap: updateUser,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}