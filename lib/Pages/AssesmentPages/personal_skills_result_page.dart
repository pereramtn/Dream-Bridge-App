import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonalSkillsResultPage extends StatelessWidget {
  final int total;
  final double percentage;

  const PersonalSkillsResultPage({
    super.key,
    required this.total,
    required this.percentage,
  });

  //Page UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "Personal Skills Result"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Personal Skills Score",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Icon(
              FontAwesomeIcons.solidCircleCheck,
              color: kbtngreen,
              size: 80,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 350,
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$total / 18",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${percentage.toStringAsFixed(1)} %",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: kMainTeal2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

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
    );
  }
}
