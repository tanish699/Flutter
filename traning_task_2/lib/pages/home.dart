import 'package:flutter/material.dart';
import 'package:traning_task_2/pages/qr_scanner_page.dart';
import 'package:traning_task_2/utils/images.dart';
import 'package:traning_task_2/widgets/expandable_fab.dart';
import 'package:traning_task_2/widgets/floatingbutton.dart';

import 'barcode_scanner_page.dart';

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

  // Pages
  final List<Widget> _pages = [
    Center(child: Image.asset(AppImages.visit)),
    Center(child: Image.asset(AppImages.contact)),
    Center(child: Image.asset(AppImages.settings)),
  ];

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
      ),

      // Body with Swipe
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
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
