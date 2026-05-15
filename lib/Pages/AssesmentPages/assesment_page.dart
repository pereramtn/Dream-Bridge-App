import 'package:dream_bridge_app/Pages/main_screen.dart';
import 'package:dream_bridge_app/wigets/custom_appbar_no_back.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dream_bridge_app/Pages/AssesmentPages/acadamic_info_page.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/aptitude_test.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/interest_assessment_page.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/personal_skills.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/personality_test_page.dart';
import 'package:dream_bridge_app/Pages/career_Recomands_page.dart';

import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/wigets/assesment_cards.dart';
import 'package:dream_bridge_app/services/api_service.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
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

      //fetch all assessment data

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

      //vallidate data existence

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


      //prepare data for API

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

      //api call

      final result = await fetchRecommendations(userData);

      if (!mounted) return;



      //navigate to recommendation page with result

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


  //Page UI



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarNoBack(appbarTitle: "ASSESSMENTS "),
      body: SafeArea(
        child: Column(
          children: [
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

                  const SizedBox(height: 10),

                  if (allCompleted)
                    Center(
                      child: ElevatedButton(
                        onPressed: seeRecommendation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kMainTeal2,
                          foregroundColor: kMainWhite,
                        ),
                        child: const Text("See Recommendations"),
                      ),
                    ),

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
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Back to Dashboard",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Assessment Cards
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(kdefaultPadding),
                children: [
                  AssessmentCard(
                    title: "Academic Info",
                    description: "Add your O/L and A/L results",
                    imagePath: "assets/Images/academic.jpg",
                    completed: completed["Academic Info"] ?? false,
                    onTap: () {
                      if (userId == null) return;

                      navigateToAssessment(
                        AcademicInfoPage(
                          userId: userId!,
                          markCompleted: markCompleted,
                        ),
                      );
                    },
                  ),

                  AssessmentCard(
                    title: "Interest Assessment",
                    description: "Discover what type of work you enjoy",
                    imagePath: "assets/Images/interest.jpg",
                    completed: completed["Interest Assessment"] ?? false,
                    onTap: () {
                      if (userId == null) return;

                      navigateToAssessment(
                        InterestAssessmentPage(
                          userId: userId!,
                          markCompleted: markCompleted,
                        ),
                      );
                    },
                  ),

                  AssessmentCard(
                    title: "Personal Skills",
                    description: "Evaluate your key strengths",
                    imagePath: "assets/Images/personal_skills.jpg",
                    completed: completed["Personal Skills"] ?? false,
                    onTap: () {
                      if (userId == null) return;

                      navigateToAssessment(
                        PersonalSkillsPage(
                          userId: userId!,
                          markCompleted: markCompleted,
                        ),
                      );
                    },
                  ),

                  AssessmentCard(
                    title: "Aptitude Test",
                    description: "Test your logical ability",
                    imagePath: "assets/Images/aptitude_test.jpg",
                    completed: completed["Aptitude Test"] ?? false,
                    onTap: () {
                      if (userId == null) return;

                      navigateToAssessment(
                        AptitudeTestPage(
                          userId: userId!,
                          markCompleted: markCompleted,
                        ),
                      );
                    },
                  ),

                  AssessmentCard(
                    title: "Personality Test",
                    description: "Understand your work style",
                    imagePath: "assets/Images/personality.jpg",
                    completed: completed["Personality Test"] ?? false,
                    onTap: () {
                      if (userId == null) return;

                      navigateToAssessment(
                        PersonalityTestPage(
                          userId: userId!,
                          markCompleted: markCompleted,
                        ),
                      );
                    },
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

// Conversion functions for API compatibility

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

// A/L Stream conversion for API

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

// Interest type conversion for API

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


// Personality type conversion for API

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

//  A/L Stream naming for API

String fixALStream(String stream) {
  switch (stream.trim().toLowerCase()) {
    case "biological science":
      return "Biological Science";

    case "mathematics":
      return "Mathematics";

    case "commerce":
      return "Commerce";

    case "arts":
      return "Arts";

    case "technology":
      return "Tech"; // because your model uses Tech
    case "tech":
      return "Tech";

    default:
      return "Commerce"; // fallback safe
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
