import 'package:dream_bridge_app/wigets/PreferenceCard.dart';
import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CareerPreferencesPage extends StatefulWidget {
  final String userId;
  final Function(String key) markCompleted;

  const CareerPreferencesPage({
    super.key,
    required this.userId,
    required this.markCompleted,
  });

  @override
  State<CareerPreferencesPage> createState() => _CareerPreferencesPageState();
}

class _CareerPreferencesPageState extends State<CareerPreferencesPage> {
  String salary = 'Medium';
  String workEnvironment = 'Private';
  String studyDuration = '3-4 Years';
  String location = 'Local';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> salaryOptions = ['Low', 'Medium', 'High'];
  final List<String> workEnvOptions = ['Government', 'Private', 'Abroad'];
  final List<String> durationOptions = ['1-2 Years', '3-4 Years', '5+ Years'];
  final List<String> locationOptions = ['Local', 'Abroad'];

  @override
  void initState() {
    super.initState();
    loadSavedPreferences();
  }

  // Load saved preferences
  Future<void> loadSavedPreferences() async {
    try {
      DocumentSnapshot doc = await _firestore.collection("users").doc(widget.userId).get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("careerPreferences")) {
          var prefs = data["careerPreferences"];
          setState(() {
            salary = prefs["salaryExpectation"] ?? salary;
            workEnvironment = prefs["workEnvironment"] ?? workEnvironment;
            studyDuration = prefs["studyduration"] ?? studyDuration;
            location = prefs["locationPreference"] ?? location;
          });
        }
      }
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  // Save preferences
  Future<void> savePreferences() async {
    try {
      await _firestore.collection("users").doc(widget.userId).set({
        "careerPreferences": {
          "salaryExpectation": salary,
          "workEnvironment": workEnvironment,
          "studyduration": studyDuration,
          "locationPreference": location,
        },
        "assessments": {
          "Career Preferences": true, // ✅ Use same key as AssessmentPage
        }
      }, SetOptions(merge: true));

      // Mark completed in AssessmentPage
      widget.markCompleted("Career Preferences");

      // Return to AssessmentPage
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving preferences: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "CAREER PREFERENCES"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kdefaultPadding, vertical: 20),
          child: Column(
            children: [
              PreferenceCard(
                title: "Salary Expectation",
                options: salaryOptions,
                selected: salary,
                color: kMainDarkBlue,
                onChanged: (val) => setState(() => salary = val),
              ),
              PreferenceCard(
                title: "Work Environment",
                options: workEnvOptions,
                selected: workEnvironment,
                color: kbtnBlue,
                onChanged: (val) => setState(() => workEnvironment = val),
              ),
              PreferenceCard(
                title: "Study Duration",
                options: durationOptions,
                selected: studyDuration,
                color: kMainTeal3,
                onChanged: (val) => setState(() => studyDuration = val),
              ),
              PreferenceCard(
                title: "Location Preference",
                options: locationOptions,
                selected: location,
                color: kMainTeal2,
                onChanged: (val) => setState(() => location = val),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMainTeal2,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: savePreferences,
                child: const Text(
                  "Save Preferences",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
