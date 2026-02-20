import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalityTestPage extends StatefulWidget {
  final String userId;
  final void Function(String key) markCompleted; // ✅ callback

  const PersonalityTestPage({
    super.key,
    required this.userId,
    required this.markCompleted,
  });

  @override
  State<PersonalityTestPage> createState() => _PersonalityTestPageState();
}

class _PersonalityTestPageState extends State<PersonalityTestPage> {
  int currentQuestion = 0;
  List<String> answers = [];
  bool isSaving = false; // loading indicator
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "Do you prefer working alone or in a team?",
      "options": ["Alone", "Team"],
    },
    {
      "question": "Do you enjoy structured or flexible work?",
      "options": ["Structured", "Flexible"],
    },
    {
      "question": "Are you more introvert or extrovert?",
      "options": ["Introvert", "Extrovert"],
    },
    {
      "question": "Do you prefer practical or theoretical tasks?",
      "options": ["Practical", "Theoretical"],
    },
    {
      "question": "Do you like taking risks or prefer stability?",
      "options": ["Risk taking", "Stable"],
    },
  ];

  void selectAnswer(String answer) {
    if (currentQuestion >= questions.length) return; // prevent double tap
    setState(() {
      answers.add(answer);
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        savePersonality(); // last question → save
      }
    });
  }

  Future<void> savePersonality() async {
    setState(() => isSaving = true);

    Map<String, String> result = {};
    for (int i = 0; i < questions.length; i++) {
      result["q${i + 1}"] = answers[i];
    }

    try {
      await _firestore.collection("users").doc(widget.userId).set({
        "personality": result,
        "assessments": {
          "Personality Test": true, // ✅ mark assessment completed
        }
      }, SetOptions(merge: true));

      widget.markCompleted("Personality Test");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Personality test saved successfully!")),
        );
        Navigator.pop(context); // back to AssessmentPage
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving personality: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "Personality Test"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/Images/personality test.jpg",
                height: 250,
              ),
              const SizedBox(height: 30),
              Text(
                "Question ${currentQuestion + 1} of ${questions.length}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        question["question"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 30),
                      ...List.generate(
                        question["options"].length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainGTeal1,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: isSaving
                                ? null
                                : () => selectAnswer(question["options"][index]),
                            child: Text(
                              question["options"][index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      if (isSaving)
                        const Center(
                          child: CircularProgressIndicator(
                            color: kMainGTeal1,
                          ),
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
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentQuestion == index ? 14 : 10,
                    height: currentQuestion == index ? 14 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentQuestion == index
                          ? kMainGTeal1
                          : Colors.grey[400],
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
