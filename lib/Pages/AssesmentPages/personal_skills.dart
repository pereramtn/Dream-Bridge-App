import 'package:flutter/material.dart';
import 'package:dream_bridge_app/wigets/SkillsCards.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalSkillsPage extends StatefulWidget {
  final String userId;
  final void Function(String key) markCompleted; // ✅ callback

  const PersonalSkillsPage({
    super.key,
    required this.userId,
    required this.markCompleted,
  });

  @override
  State<PersonalSkillsPage> createState() => _PersonalSkillsPageState();
}

class _PersonalSkillsPageState extends State<PersonalSkillsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize skills to 1
  final Map<String, int> skills = {
    "Problem Solving": 1,
    "Communication": 1,
    "Leadership": 1,
    "Creativity": 1,
    "Technical Skills": 1,
    "Numerical Ability": 1,
  };

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadSkills(); // ✅ load existing data if any
  }

  Future<void> loadSkills() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(widget.userId).get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey("personalSkills")) {
          Map<String, dynamic> savedSkills =
              Map<String, dynamic>.from(data["personalSkills"]);

          setState(() {
            skills.forEach((key, value) {
              String firestoreKey = key.toLowerCase().replaceAll(" ", "");
              if (savedSkills.containsKey(firestoreKey)) {
                skills[key] = savedSkills[firestoreKey];
              }
            });
          });
        }
      }
    } catch (e) {
      print("Error loading skills: $e");
    }
  }

  Future<void> saveSkills() async {
    setState(() {
      isSaving = true;
    });

    try {
      await _firestore.collection("users").doc(widget.userId).set({
        "personalSkills": {
          "problemsolving": skills["Problem Solving"],
          "communication": skills["Communication"],
          "leadership": skills["Leadership"],
          "creativity": skills["Creativity"],
          "technicalSkills": skills["Technical Skills"],
          "numericalability": skills["Numerical Ability"],
        },
        "assessments": {
          "Personal Skills": true, // ✅ mark assessment completed
        },
      }, SetOptions(merge: true));

      // ✅ Call callback to update progress in AssessmentPage
      widget.markCompleted("Personal Skills");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Skills saved successfully!")),
        );
        Navigator.pop(context); // Return to AssessmentPage
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving skills: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "PERSONAL SKILLS"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kdefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Rate Your Skills (1–5)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kMainTeal2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: skills.keys.map((skill) {
                    return SkillCard(
                      skillName: skill,
                      value: skills[skill]!,
                      onChanged: (val) {
                        setState(() {
                          skills[skill] = val;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: kMainGTeal1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: isSaving ? null : saveSkills,
                    child: isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
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
