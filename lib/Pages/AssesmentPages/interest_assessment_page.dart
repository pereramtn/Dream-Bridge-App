import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestAssessmentPage extends StatefulWidget {
  final String userId;
  final void Function(String key) markCompleted;

  const InterestAssessmentPage({
    super.key,
    required this.userId,
    required this.markCompleted, // ✅ pass the callback
  });

  @override
  State<InterestAssessmentPage> createState() => _InterestAssessmentPageState();
}

class _InterestAssessmentPageState extends State<InterestAssessmentPage> {
  Map<String, int> interestScores = {
    "Realistic": 0,
    "Investigative": 0,
    "Artistic": 0,
    "Social": 0,
    "Enterprising": 0,
    "Conventional": 0,
  };

  final List<Map<String, dynamic>> questions = [
    {"question": "I enjoy building, fixing, or working with machines.", "type": "Realistic"},
    {"question": "I like solving problems and researching new ideas.", "type": "Investigative"},
    {"question": "I enjoy painting, music, or other creative activities.", "type": "Artistic"},
    {"question": "I like helping and teaching people.", "type": "Social"},
    {"question": "I like leading, persuading, or managing others.", "type": "Enterprising"},
    {"question": "I like organizing, planning, or working with data.", "type": "Conventional"},
  ];

  int currentQuestionIndex = 0;

  void answerQuestion(int score) {
    String type = questions[currentQuestionIndex]["type"]!;
    interestScores[type] = interestScores[type]! + score;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Completed all questions → save to Firebase
      saveInterestScores();
    }
  }

  Future<void> saveInterestScores() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .set({
        "interests": interestScores.map((key, value) => MapEntry(key.toLowerCase(), value)),
        "assessments": {
          "Interest Assessment": true, // ✅ same key as AssessmentPage
        },
      }, SetOptions(merge: true));

      // ✅ Mark completed in AssessmentPage
      widget.markCompleted("Interest Assessment");

      Navigator.pop(context, true); // Go back to AssessmentPage
    } catch (e) {
      print("Error saving interests: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to save data")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "INTEREST ASSESSMENT"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Images/interestassesment.jpg", height: 200),
              const SizedBox(height: 20),
              Text(
                "Question ${currentQuestionIndex + 1} of ${questions.length}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: kMainTeal4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        currentQuestion["question"],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => answerQuestion(3),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              foregroundColor: kMainTeal2,
                            ),
                            child: const Text("Strongly Agree"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => answerQuestion(2),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              foregroundColor: kMainTeal2,
                            ),
                            child: const Text("Agree"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => answerQuestion(1),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              foregroundColor: kMainTeal2,
                            ),
                            child: const Text("Neutral"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Dot Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  questions.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentQuestionIndex ? kMainGTeal1 : Colors.grey[400],
                    ),
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
