import 'package:dream_bridge_app/Pages/AssesmentPages/interest_assesment_result.dart';
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
    required this.markCompleted,
  });

  @override
  State<InterestAssessmentPage> createState() => _InterestAssessmentPageState();
}

// This page implements a simple interest assessment based on 6 categories (RIASEC model).

class _InterestAssessmentPageState extends State<InterestAssessmentPage> {
  Map<String, int> interestScores = {
    "Realistic": 0,
    "Investigative": 0,
    "Artistic": 0,
    "Social": 0,
    "Enterprising": 0,
    "Conventional": 0,
  };


  // Sample questions for the interest assessment

  final List<Map<String, String>> questions = [
    {
      "question": "I enjoy working with tools or machines.",
      "type": "Realistic",
    },
    {"question": "I like outdoor or practical work.", "type": "Realistic"},
    {"question": "I enjoy solving complex problems.", "type": "Investigative"},
    {
      "question": "I like science experiments and research.",
      "type": "Investigative",
    },
    {"question": "I enjoy drawing, designing, or music.", "type": "Artistic"},
    {"question": "I like expressing myself creatively.", "type": "Artistic"},
    {"question": "I enjoy helping people solve problems.", "type": "Social"},
    {"question": "I like teaching or guiding others.", "type": "Social"},
    {"question": "I enjoy leading teams.", "type": "Enterprising"},
    {"question": "I like persuading or selling ideas.", "type": "Enterprising"},
    {"question": "I like organizing data and files.", "type": "Conventional"},
    {
      "question": "I enjoy planning and scheduling work.",
      "type": "Conventional",
    },
  ];

  // State variables for question navigation and answer tracking

  int currentIndex = 0;
  bool isAnswered = false;
  bool isSaving = false;

  void answer(int score) {
    if (isAnswered) return;

    String type = questions[currentIndex]["type"]!;
    interestScores[type] = interestScores[type]! + score;

    setState(() {
      isAnswered = true;
    });
  }

  void nextQuestion() {
    if (!isAnswered) return;

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
      });
    }
  }



  // save interest assessment results to Firestore
  Future<void> submitAssessment() async {
    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(widget.userId)
          .collection("interestAssessment")
          .doc("interest_data")
          .set({
            "interest_id": "interest_data",
            "user_id": widget.userId,
            "scores": interestScores,
          })
          .then((_) {
            print("Saved successfully!");
          })
          .catchError((e) {
            print("Error saving: $e");
          });

      widget.markCompleted("Interest Assessment");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InterestAssessmentResultPage(userId: widget.userId),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error saving assessment")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  //Page UI
  

  @override
  Widget build(BuildContext context) {
    var question = questions[currentIndex];

    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "INTEREST ASSESSMENT"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset("assets/Images/interestassesment.jpg", height: 150),

              const SizedBox(height: 10),

              Text(
                "Question ${currentIndex + 1} of ${questions.length}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        question["question"]!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => answer(3),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: kMainGTeal1,
                        ),
                        child: const Text("Strongly Agree"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () => answer(2),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: kMainTeal4,
                        ),
                        child: const Text("Agree"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () => answer(1),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.grey[400],
                        ),
                        child: const Text("Neutral"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (currentIndex < questions.length - 1)
                ElevatedButton(
                  onPressed: isAnswered ? nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: kMainGTeal1,
                    foregroundColor: kMainWhite,
                  ),
                  child: const Text("Next"),
                ),

              if (currentIndex == questions.length - 1)
                ElevatedButton(
                  onPressed: isAnswered && !isSaving ? submitAssessment : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: kbtngreen,
                    foregroundColor: kMainWhite,
                  ),
                  child: Text(isSaving ? "Saving..." : "Submit"),
                ),

              const SizedBox(height: 15),

              Text(
                "if you complete this assessment before, you can see your results here",
                style: TextStyle(fontSize: 14, color: kletdarkgray),
                textAlign: TextAlign.center,
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InterestAssessmentResultPage(userId: widget.userId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: kMainDarkBlue,
                  foregroundColor: kMainWhite,
                ),
                child: const Text(
                  "See Results",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
