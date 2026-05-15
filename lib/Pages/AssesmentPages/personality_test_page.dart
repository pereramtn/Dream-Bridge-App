import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'personality_result_page.dart';

class PersonalityTestPage extends StatefulWidget {
  final String userId;
  final void Function(String key) markCompleted;

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
  bool isSaving = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sample questions for the personality test based on SIAR model

  final List<Map<String, dynamic>> questions = [
    {
      "question": "When solving a problem, you usually:",
      "options": {
        "Ask others for help": "S",
        "Analyze details yourself": "I",
        "Try creative solutions": "A",
        "Use practical methods": "R",
      },
    },
    {
      "question": "In a group project, your role is usually:",
      "options": {
        "Coordinator / motivator": "S",
        "Researcher / planner": "I",
        "Designer / idea person": "A",
        "Task executor": "R",
      },
    },
    {
      "question": "Your hobbies are mostly:",
      "options": {
        "Volunteering / social activities": "S",
        "Reading / experiments": "I",
        "Painting / music / writing": "A",
        "Sports / DIY / building things": "R",
      },
    },
    {
      "question": "When facing a challenge, you prefer:",
      "options": {
        "Working with people": "S",
        "Thinking logically": "I",
        "Trying something new": "A",
        "Following step-by-step instructions": "R",
      },
    },
    {
      "question": "Your ideal job environment:",
      "options": {
        "Teamwork / helping others": "S",
        "Research / problem solving": "I",
        "Creative / flexible": "A",
        "Hands-on / practical": "R",
      },
    },
  ];

  void selectAnswer(String type) {
    if (currentQuestion >= questions.length) return;

    setState(() {
      answers.add(type);
    });

    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
    } else {
      savePersonalityResult();
    }
  }

  String calculateDominantType() {
    Map<String, int> counts = {"S": 0, "I": 0, "A": 0, "R": 0};
    for (var t in answers) {
      counts[t] = counts[t]! + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  Future<void> savePersonalityResult() async {
  setState(() => isSaving = true);

  String dominantType = calculateDominantType();

  try {
    // Save in a subcollection under the user document
    await _firestore
        .collection("students")
        .doc(widget.userId)
        .collection("personalityAssessment")
        .doc("personality_data")
        .set({
      "personality_id": "personality_data",
      "user_id": widget.userId,
      "type": dominantType,
    });

    // Optionally, mark the assessment completed in the main student doc
    await _firestore.collection("students").doc(widget.userId).set(
      {
        "assessments": {"Personality Test": true},
      },
      SetOptions(merge: true),
    );

    widget.markCompleted("Personality Test");

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PersonalityResultPage(
            personalityType: dominantType,
          ),
        ),
      );
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
    if (currentQuestion >= questions.length) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentQuestion];
    final Map<String, String> options =
        Map<String, String>.from(question["options"]);

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
                height: 170,
              ),
              const SizedBox(height: 10),
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
                  borderRadius: BorderRadius.circular(20),
                ),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Answer options
                      ...options.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainGTeal1,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: isSaving
                                ? null
                                : () => selectAnswer(entry.value),
                            child: Text(
                              entry.key,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      if (isSaving)
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Center(
                            child: CircularProgressIndicator(color: kMainGTeal1),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
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