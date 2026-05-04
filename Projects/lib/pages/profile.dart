import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../widgets/custombutton.dart';
import 'editprofile.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';
import '../widgets/image_source_sheet.dart';
import '../widgets/profile_avatar.dart';
import 'dart:io';

class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<userProfile> {
  String? email;
  String? contact;
  String? dob;
  String? gender;
  String? country;
  String? firstName;
  String? lastName;
  String? _profileImagePath;

  bool isLoading = true;

  final ImageService _imageService = ImageService();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("email");

    if (savedEmail == null) {
      setState(() => isLoading = false);
      return;
    }

    final user = await DataBaseHelper.instance.getUserByEmail(savedEmail);

    if (user != null) {
      setState(() {
        firstName = user['firstName'];
        lastName = user['lastName'];
        email = user['email'];
        contact = user['contact'];
        dob = user['dob'];
        gender = user['gender'];
        country = user['country'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }

    _profileImagePath = prefs.getString("profile_image_$savedEmail");
    setState(() {});
  }

  Future<void> _handleProfileImageUpload(ImageSource source) async {
    final File? image = await _imageService.pickAndCropImage(
      source: source,
      context: context,
    );

    if (image == null) return;

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("email");
    if (savedEmail != null) {
      await prefs.setString("profile_image_$savedEmail", image.path);
    }

    setState(() => _profileImagePath = image.path);
  }

  //Calculate age
  int calculateAge(String dobString) {
    final dob = DateFormat('dd/MM/yyyy').parse(dobString);
    final today = DateTime.now();

    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
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
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await _logout();
              },
              child: const Text("Yes", style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("email"); // clear session

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => loginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.orange,
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfilePage(),
                ),
              );
              loadUser();
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    //Profile Icon
                    ProfileAvatar(
                      imagePath: _profileImagePath,
                      onTap: () => ImageSourceSheet.show(
                        context,
                        onSourceSelected: _handleProfileImageUpload,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name
                    Text(
                      "${firstName ?? ""} ${lastName ?? ""}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    //Details
                    _buildTile("Email", email ?? "-"),
                    _buildTile("Phone", contact ?? "-"),
                    _buildTile(
                      "DOB",
                      dob != null ? "$dob (${calculateAge(dob!)} yrs)" : "-",
                    ),
                    _buildTile("Nationality", country ?? "-"),
                    _buildTile("Gender", gender ?? "-"),
                    const SizedBox(height: 40),

                    const SizedBox(height: 80),

                    Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        text: "Logout",
                        borderRadius: 10,
                        color: Colors.red,
                        onTap: () {
                          _showLogoutDialog();
                        },
                      ),
                    ),

                  ],


                ),


              ),
          ),
    );
  }
}

Widget _buildTile(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15)),
        ),
      ],
    ),
  );
}
