import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InterestAssessmentResultPage extends StatelessWidget {
  final String userId;

  const InterestAssessmentResultPage({super.key, required this.userId});

  // Fetch interest scores from Firestore

  Future<Map<String, int>> fetchResults() async {
    var doc = await FirebaseFirestore.instance
        .collection("students")
        .doc(userId)
        .collection("interestAssessment")
        .doc("interest_data")
        .get();

    Map<String, dynamic> rawData = doc.data()?["scores"] ?? {};

    return {
      "Realistic": rawData["Realistic"] ?? 0,
      "Investigative": rawData["Investigative"] ?? 0,
      "Artistic": rawData["Artistic"] ?? 0,
      "Social": rawData["Social"] ?? 0,
      "Enterprising": rawData["Enterprising"] ?? 0,
      "Conventional": rawData["Conventional"] ?? 0,
    };
  }


  // Page UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "YOUR INTEREST RESULTS"),
      body: FutureBuilder<Map<String, int>>(
        future: fetchResults(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!;
          const int maxScore = 6; // 2 questions * 3 points max

          // Find highest score category
          String topCategory = data.entries
              .reduce((a, b) => a.value >= b.value ? a : b)
              .key;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Highest interest card
                Card(
                  color: kMainDarkBlue,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.trophy,
                          color: kletYellow,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Highest Interest: $topCategory",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kMainWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



                // List all scores
                ...data.entries.map((entry) {
                  return SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "${entry.key}: ${entry.value} / $maxScore",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),



                
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
          );
        },
      ),
    );
  }
}