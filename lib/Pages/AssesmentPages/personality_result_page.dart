import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonalityResultPage extends StatelessWidget {
  final String personalityType;

  const PersonalityResultPage({super.key, required this.personalityType});

  // Convert personality type to description

  String getPersonalityDescription() {
    switch (personalityType) {
      case "S":
        return "Social – You enjoy helping and working with others.";
      case "I":
        return "Investigative – You enjoy analyzing, researching, and problem solving.";
      case "A":
        return "Artistic – You enjoy creativity, design, and self-expression.";
      case "R":
        return "Realistic – You enjoy practical, hands-on work.";
      default:
        return "Unknown personality type.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "Personality Result"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.solidCircleCheck,
                color: kbtngreen,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                "Your Personality Type",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                personalityType,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: kMainTeal2,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                getPersonalityDescription(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Back to assessment button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainGTeal1,
                    foregroundColor: kMainWhite,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AssessmentPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Back to Assessment",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
