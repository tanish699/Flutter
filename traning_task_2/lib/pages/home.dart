import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traning_task_2/pages/qr_scanner_page.dart';
import 'package:traning_task_2/utils/images.dart';
import 'package:traning_task_2/widgets/expandable_fab.dart';
import 'package:traning_task_2/widgets/floatingbutton.dart';
import 'package:url_launcher/url_launcher.dart';

import 'barcode_scanner_page.dart';
import 'contact_page.dart';
import 'login.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _currentIndex = 0;
  bool isFabExpanded = false;
  final PageController _pageController = PageController();

  // Titles for AppBar
  final List<String> _titles = ["My Visits", "My Contacts", "Settings"];

  // ================= OPEN IN APP =================

  Future<void> openInAppBrowser() async {

    final Uri url = Uri.parse(
      "https://flutter.dev",
    );

    await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
    );
  }

// ================= OPEN EXTERNAL =================

  Future<void> openExternalBrowser() async {

    final Uri url = Uri.parse(
      "https://flutter.dev",
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  void showAboutDialogBox() {

    showDialog(

      context: context,

      builder: (context) {

        return Dialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Text(
                  "About Us",

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 30),

                // ---------- APP DEVELOPMENT ----------

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: openInAppBrowser,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade300,
                    ),

                    child: const Text(
                      "App Development",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------- MAIN WEBSITE ----------

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: openExternalBrowser,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade300,
                    ),

                    child: const Text(
                      "Main Website",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ---------- BACK ----------

                OutlinedButton(

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= LOGOUT =================

  Future<void> logout() async {

    // Firebase logout
    await FirebaseAuth.instance.signOut();

    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to login page
    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder: (_) => const loginPage(),
      ),

          (route) => false,
    );
  }

  // Pages
  List<Widget> getPages() {

    return [

      // ---------- VISITS ----------

      Center(
        child: Image.asset(AppImages.visit),
      ),

      // ---------- CONTACTS ----------

      const ContactsPage(),

      // ---------- SETTINGS ----------

      Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Container(

              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),

              child: ListTile(

                leading: const Icon(Icons.search),

                title: const Text(
                  "About Us",
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),

                onTap: () {

                  showAboutDialogBox();
                },
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔶 AppBar
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.orange.shade300,
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              logout();
            },

            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // Body with Swipe
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: getPages(),
      ),

      // Floating Button
      floatingActionButton: ExpandableFab(
          onQrTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const QRScannerPage(),
              ),
            );
          },
          onBarTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BarcodeScannerPage(),
              ),
            );
          }
      ),


      // 🔶 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "My Visits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "My Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
