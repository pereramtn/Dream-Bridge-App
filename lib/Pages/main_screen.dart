import 'package:dream_bridge_app/Pages/Dashboard_page.dart';
import 'package:dream_bridge_app/Pages/Profile_page.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:dream_bridge_app/Pages/explore_page.dart';
import 'package:dream_bridge_app/Pages/progress_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //current page index
  int _currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    //screens list
    final List<Widget> pages = [
      DashboardPage(),
      ProgressPage(),
      ExplorePage(),
      AssessmentPage(),
      ProfilePage(),
    ];

    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),

        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: kMainGTeal1,
          selectedItemColor: kMainWhite,
          unselectedItemColor: kletGray,
        
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "Progress"),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: kMainWhite,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.explore, color: kMainGTeal1, size: 30),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: "Assessment",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
      body: pages[_currentPageIndex],
    );
  }
}
