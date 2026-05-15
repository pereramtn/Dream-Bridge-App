
import 'package:dream_bridge_app/wigets/custom_appbar_no_back.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dream_bridge_app/Pages/career_Recomands_page.dart';

import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/services/api_service.dart';

class CareerResult extends StatefulWidget {
  const CareerResult({super.key});

  @override
  State<CareerResult> createState() => _CareerResultState();
}

class _CareerResultState extends State<CareerResult> {
  Map<String, bool> completed = {
    "Academic Info": false,
    "Interest Assessment": false,
    "Personal Skills": false,
    "Aptitude Test": false,
    "Personality Test": false,
  };

  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    loadAssessmentStatus();
  }

  // Load saved assessment progress
  Future<void> loadAssessmentStatus() async {
    if (userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(userId)
          .get();

      if (!snapshot.exists) return;

      final data = snapshot.data();
      if (data == null || !data.containsKey('assessments')) return;

      final saved = Map<String, dynamic>.from(data['assessments']);

      setState(() {
        completed.updateAll((key, value) {
          return saved[key] == true;
        });
      });
    } catch (e) {
      debugPrint("Error loading assessments: $e");
    }
  }

  // Mark assessment as completed
  Future<void> markCompleted(String key) async {
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('students').doc(userId).set({
        'assessments': {key: true},
      }, SetOptions(merge: true));

      setState(() {
        completed[key] = true;
      });
    } catch (e) {
      debugPrint("Error saving completion: $e");
    }
  }

  // Progress calculation
  double get progress {
    int total = completed.length;
    int done = completed.values.where((v) => v).length;
    return total == 0 ? 0 : done / total;
  }

  bool get allCompleted => progress >= 1.0;

  // Navigate to assessment page
  Future<void> navigateToAssessment(Widget page) async {
    if (userId == null) return;

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    if (updated == true) {
      await loadAssessmentStatus();
    }
  }

  Future<void> seeRecommendation() async {
    if (!allCompleted || userId == null) return;

    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch all assessment data

      final academicSnap = await firestore
          .collection('students')
          .doc(userId)
          .collection('academicInfo')
          .doc('academic_data')
          .get();

      final interestSnap = await firestore
          .collection('students')
          .doc(userId)
          .collection('interestAssessment')
          .doc('interest_data')
          .get();

      final skillsSnap = await firestore
          .collection('students')
          .doc(userId)
          .collection('personalSkillsAssessment')
          .doc('skills_data')
          .get();

      final aptitudeSnap = await firestore
          .collection('students')
          .doc(userId)
          .collection('aptitudeTest')
          .doc('aptitude_data')
          .get();

      final personalitySnap = await firestore
          .collection('students')
          .doc(userId)
          .collection('personalityAssessment')
          .doc('personality_data')
          .get();

      // Check if all data exists

      if (!academicSnap.exists ||
          !interestSnap.exists ||
          !skillsSnap.exists ||
          !aptitudeSnap.exists ||
          !personalitySnap.exists) {
        throw Exception("Some assessment data is missing");
      }

      final academic = academicSnap.data()!;
      final interest = interestSnap.data()!;
      final skills = skillsSnap.data()!;
      final aptitude = aptitudeSnap.data()!;
      final personality = personalitySnap.data()!;

      // Prepare data for API

      Map<String, dynamic> userData = {
        "ol_mathamatics": fixGrade(academic["olResults"]?["Mathematics"] ?? ""),
        "ol_science": fixGrade(academic["olResults"]?["Science"] ?? ""),
        "ol_english": fixGrade(academic["olResults"]?["English"] ?? ""),

        "al_stream": fixALStream(academic["alStream"] ?? ""),

        "interest_type": getTopInterest(interest["scores"] ?? {}),

        "personal_skill_score": (skills["percentage"] is int)
            ? skills["percentage"]
            : int.tryParse(skills["percentage"].toString()) ?? 0,

        "aptitude_test_score": getTotalAptitude(aptitude["scores"] ?? {}),

        "personality_type": personality["type"] ?? "",
      };
      print("FINAL USER DATA: $userData");

      //call API

      final result = await fetchRecommendations(userData);

      if (!mounted) return;

      // Navigate to recommendations page with results

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CareersPage(careerData: result)),
      );
    } catch (e) {
      debugPrint("ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarNoBack(appbarTitle: "SEE CAREER RESULTS"),
      body: SafeArea(
        child: Column(
          children: [
            //image
            Image.asset(
              "assets/Images/careerResult.jpg",
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            // Progress Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Assessment Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: progress,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.grey[300],
                    color: kMainGTeal1,
                    minHeight: 12,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${(progress * 100).round()}% Completed",
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 20),

                  if (allCompleted)
                    Center(
                      child: ElevatedButton(
                        onPressed: seeRecommendation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kMainTeal2,
                          foregroundColor: kMainWhite,
                        ),
                        child: const Text(
                          "See Your Recommended Careers",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Get highest interest category
String getTopInterest(Map<String, dynamic> scores) {
  if (scores.isEmpty) return "";

  String top = scores.keys.first;
  int max = scores[top];

  scores.forEach((key, value) {
    if (value > max) {
      max = value;
      top = key;
    }
  });

  return top;
}

// Sum aptitude scores
int getTotalAptitude(Map<String, dynamic> scores) {
  int total = 0;
  scores.forEach((key, value) {
    total += (value as int);
  });
  return total;
}

int convertGrade(String grade) {
  switch (grade) {
    case "A":
      return 5;
    case "B":
      return 4;
    case "C":
      return 3;
    case "S":
      return 2;
    case "F":
      return 1;
    default:
      return 0;
  }
}

int convertALStream(String stream) {
  switch (stream) {
    case "Biological Science":
      return 0;
    case "Mathematics":
      return 1;
    case "Commerce":
      return 2;
    case "Arts":
      return 3;
    case "Technology":
      return 4;
    default:
      return 0;
  }
}

int convertInterestType(String type) {
  switch (type) {
    case "Realistic":
      return 0;
    case "Investigative":
      return 1;
    case "Artistic":
      return 2;
    case "Social":
      return 3;
    case "Enterprising":
      return 4;
    case "Conventional":
      return 5;
    default:
      return 0;
  }
}

int convertPersonalityType(String type) {
  switch (type) {
    case "R":
      return 0;
    case "I":
      return 1;
    case "A":
      return 2;
    case "S":
      return 3;
    default:
      return 0;
  }
}

// FIX A/L Stream naming for API
String fixALStream(String stream) {
  switch (stream) {
    case "Technology":
      return "Tech";
    default:
      return stream;
  }
}

// convert fail to lowest valid grade
String fixGrade(String grade) {
  switch (grade) {
    case "F":
      return "S";
    default:
      return grade;
  }
}
