import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:dream_bridge_app/Pages/about_us_page.dart';
import 'package:dream_bridge_app/Pages/dream_bot.dart';
import 'package:dream_bridge_app/Pages/help_support.dart';
import 'package:dream_bridge_app/Pages/home_page.dart';
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
      backgroundColor: kMainWhite,

      child: ListView(
        padding: EdgeInsets.zero,

        children: [
          // HEADER
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

                    SizedBox(width: 10),

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

          // ASSESSMENTS
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

          // DREAM BOT
          ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: const Text("Dream Bot"),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DreamBotPage()),
              );
            },
          ),

          const Divider(),
          // ABOUT US
          ListTile(
            leading: const Icon(Icons.face),
            title: const Text("About Us"),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),

          // HELP & SUPPORT
          ListTile(
            leading: const Icon(Icons.help_outline_sharp),
            title: const Text("Help & Support"),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportPage(),
                ),
              );
            },
          ),

          const Divider(),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),

            onTap: () {
              Navigator.pop(context);
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
