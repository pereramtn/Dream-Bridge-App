import 'package:dream_bridge_app/Pages/AssesmentPages/aptitude_test.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/personal_skills.dart';
import 'package:flutter/material.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/acadamic_info_page.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/career_preferences_page.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/interest_assessment_page.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/personality_test_page.dart';

import 'package:dream_bridge_app/wigets/assesment_cards.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    "Career Preferences": false,
  };

  @override
  void initState() {
    super.initState();
    loadAssessmentStatus();
  }

  /// Load assessment status for the currently logged-in user
  Future<void> loadAssessmentStatus() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('assessments')) {
          Map<String, dynamic> saved =
              Map<String, dynamic>.from(data['assessments']);

          setState(() {
            completed = completed.map((key, value) {
              return MapEntry(
                  key, saved.containsKey(key) ? saved[key] == true : false);
            });
          });
        } else {
          // If no assessments exist, reset to default
          setState(() {
            completed.updateAll((key, value) => false);
          });
        }
      }
    } catch (e) {
      print("Error loading assessment status: $e");
    }
  }

  /// Mark an assessment as completed for the current user
  Future<void> markCompleted(String key) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'assessments': {key: true}
      }, SetOptions(merge: true));

      setState(() {
        completed[key] = true;
      });
    } catch (e) {
      print("Error saving assessment status: $e");
    }
  }

  /// Calculate progress
  double get progress {
    int total = completed.length;
    int done = completed.values.where((v) => v).length;
    return done / total;
  }

  /// Helper to navigate to assessment pages
  Future<void> navigateToAssessment(Widget page) async {
    bool? updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (updated == true) {
      loadAssessmentStatus(); // Refresh after completing assessment
    }
  }

  /// Clear local assessment state (call on logout)
  void clearAssessmentState() {
    setState(() {
      completed.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "ASSESSMENT"),
      body: SafeArea(
        child: Column(
          children: [
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
                    borderRadius: BorderRadius.circular(10),
                    value: progress,
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
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(kdefaultPadding),
                children: [
                  AssessmentCard(
                    title: "Academic Info",
                    description: "Add your O/L and A/L results",
                    imagePath: "assets/Images/academic.jpg",
                    completed: completed["Academic Info"]!,
                    onTap: () async {
                      await navigateToAssessment(AcademicInfoPage(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        markCompleted: markCompleted,
                      ));
                    },
                  ),
                  AssessmentCard(
                    title: "Interest Assessment",
                    description: "Discover what type of work you enjoy",
                    imagePath: "assets/Images/interest.jpg",
                    completed: completed["Interest Assessment"]!,
                    onTap: () async {
                      await navigateToAssessment(InterestAssessmentPage(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        markCompleted: markCompleted,
                      ));
                    },
                  ),
                  AssessmentCard(
                    title: "Personal Skills",
                    description: "Evaluate your key strengths",
                    imagePath: "assets/Images/personal_skills.jpg",
                    completed: completed["Personal Skills"]!,
                    onTap: () async {
                      await navigateToAssessment(PersonalSkillsPage(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        markCompleted: markCompleted,
                      ));
                    },
                  ),
                  AssessmentCard(
                    title: "Aptitude Test",
                    description: "Test your logical & numerical ability",
                    imagePath: "assets/Images/aptitude_test.jpg",
                    completed: completed["Aptitude Test"]!,
                    onTap: () async {
                      await navigateToAssessment(AptitudeTestPage(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        markCompleted: markCompleted,
                      ));
                    },
                  ),
                  AssessmentCard(
                    title: "Personality Test",
                    description: "Understand your work style",
                    imagePath: "assets/Images/personality.jpg",
                    completed: completed["Personality Test"]!,
                    onTap: () async {
                      await navigateToAssessment(PersonalityTestPage(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        markCompleted: markCompleted,
                      ));
                    },
                  ),
                  AssessmentCard(
                    title: "Career Preferences",
                    description: "Set salary & work environment preferences",
                    imagePath: "assets/Images/preferences.jpg",
                    completed: completed["Career Preferences"]!,
                    onTap: () async {
                      await navigateToAssessment(CareerPreferencesPage(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        markCompleted: markCompleted,
                      ));
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
