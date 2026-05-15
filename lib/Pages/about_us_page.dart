import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "ABOUT US"),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kMainWhite,
              const Color.fromARGB(255, 255, 255, 255),
              kMainTeal2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LOGO / MAIN IMAGE
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: const DecorationImage(
                      image: AssetImage("assets/Images/Logo.png"),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // APP NAME
                const Text(
                  "Dream Bridge",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kMainTeal2,
                  ),
                ),

                const SizedBox(height: 20),

                // VISION
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Vision",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kMainTeal3,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "To guide students in Sri Lanka to discover their true career path "
                        "through intelligent assessments, AI support, and personalized roadmaps."
                        "Dream Bridge aims to bridge the gap between education and career success "
                        "by providing smart, accessible, and modern career guidance.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // DEVELOPER INFO
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Developer ",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: kMainDarkBlue,
                        ),
                      ),
                    ),
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          "assets/Images/developer.jpg",
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Mathrage Perera\nSoftware Engineering Student\n NSBM Green University",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kMainDarkBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // APP INFO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "App Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kMainTeal3,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Version: 1.0.0"),
                      Text("Platform: Flutter (Android)"),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // FOOTER
                const Text(
                  "© 2024 Dream Bridge. All rights reserved.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
