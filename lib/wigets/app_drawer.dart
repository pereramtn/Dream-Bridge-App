import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:dream_bridge_app/Pages/career_roadmap.dart';
import 'package:dream_bridge_app/Pages/discover_your_path.dart';
import 'package:dream_bridge_app/Pages/dream_bot.dart';
import 'package:dream_bridge_app/Pages/home_page.dart';
import 'package:dream_bridge_app/Pages/skillgap_analyzer.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _signOut(BuildContext context) async {
    await AuthServices().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kletGray,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          DrawerHeader(
            decoration: const BoxDecoration(color: kMainGTeal1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Image(
                      image: AssetImage("assets/Images/Logo.png"),
                      height: 60,
                    ),
                    Text(
                      "Dream Bridge",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: const Icon(Icons.route),
            title: const Text("Career Roadmap"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CareerRoadmap()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text("Assessments"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AssessmentPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text("Dream Bot"),
           onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DreamBot()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text("Skillgap Analyzer"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SkillgapAnalyzer()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.navigation),
            title: const Text("Discover Your Path"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiscoverYourPath()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: () {
              Navigator.pop(context);      
              AuthServices().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              
              
            },
          ),
        ],
      ),
    );
  }
}
