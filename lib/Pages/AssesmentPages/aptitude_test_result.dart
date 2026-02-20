import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AptitudeResultPage extends StatelessWidget {
  final Map<String, int> scores;
  final String userId;
  final Function(String) markCompleted;

  const AptitudeResultPage({
    super.key,
    required this.scores,
    required this.userId,
    required this.markCompleted,
  });

  // ✅ Save results to Firestore and mark assessment complete
  Future<void> saveResult() async {
    int totalMarks = scores.values.reduce((a, b) => a + b);
    int maxMarks = 20;
    double percentage = (totalMarks / maxMarks) * 100;

    await FirebaseFirestore.instance.collection("users").doc(userId).set({
      "aptitudeTest": {
        "scores": scores,
        "totalMarks": totalMarks,
        "percentage": percentage,
        "completedAt": FieldValue.serverTimestamp(),
      },
      "assessments": {
        "Aptitude Test": true, // mark completed in Firestore
      }
    }, SetOptions(merge: true));

    markCompleted("Aptitude Test"); // Update parent page state
  }

  @override
  Widget build(BuildContext context) {
    int totalMarks = scores.values.reduce((a, b) => a + b);
    int maxMarks = 20;
    double percentage = (totalMarks / maxMarks) * 100;

    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "Aptitude Test Results"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aptitude Test Scores',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ...scores.entries.map(
              (entry) => Card(
                child: ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value} / 20'),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Divider(),

            Text(
              'Total Marks: $totalMarks / $maxMarks',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              'Percentage: ${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                // ✅ Save results
                await saveResult();

                // ✅ Pop this page and return true to parent
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainTeal2,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text("Back to Assessment"),
            ),
          ],
        ),
      ),
    );
  }
}
