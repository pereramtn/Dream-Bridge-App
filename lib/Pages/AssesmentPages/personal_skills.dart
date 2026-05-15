import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'personal_skills_result_page.dart';

class PersonalSkillsPage extends StatefulWidget {
  final String userId;
  final void Function(String key) markCompleted;

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

  // Skill values (1 = Low, 2 = Medium, 3 = Strong)
  final Map<String, int> skills = {
    "Problem Solving": 0,
    "Communication": 0,
    "Leadership": 0,
    "Creativity": 0,
    "Technical Skills": 0,
    "Numerical Ability": 0,
  };

  bool isSaving = false;

  // Option button widget

  Widget buildOption(String skill, String label, int value) {
    bool selected = skills[skill] == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          skills[skill] = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kMainGTeal1 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: kMainGTeal1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  bool allSelected() => !skills.values.contains(0);

  Future<void> saveSkills() async {
    if (!allSelected()) return;

    setState(() => isSaving = true);

    try {
      int total = skills.values.fold(0, (prev, val) => prev + val);
      double percentage = (total / 18) * 100;

      // Save to Firestore under user's personalSkillsAssessment subcollection
      await _firestore
          .collection("students")
          .doc(widget.userId)
          .collection("personalSkillsAssessment")
          .doc("skills_data")
          .set({
        "personalSkills_id": "skills_data",
        "user_id": widget.userId,
        "skills": skills,
        "total": total,
        "percentage": percentage,
      });

      // Optional: mark assessment as completed in main student doc
      await _firestore.collection("students").doc(widget.userId).set(
        {
          "assessments": {"Personal Skills": true},
        },
        SetOptions(merge: true),
      );

      widget.markCompleted("Personal Skills");

      // Navigate to result page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PersonalSkillsResultPage(
              total: total,
              percentage: percentage,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving skills: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  //Page UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "PERSONAL SKILLS"),
      body: Padding(
        padding: const EdgeInsets.all(kdefaultPadding),
        child: Column(
          children: [
            const Text(
              "Select Your Skill Level",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kMainTeal2,
              ),
            ),
            const SizedBox(height: 20),

            // Skill Cards
            Expanded(
              child: ListView(
                children: skills.keys.map((skill) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skill,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildOption(skill, "Low", 1),
                              buildOption(skill, "Medium", 2),
                              buildOption(skill, "Strong", 3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Submit Button
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: (!allSelected() || isSaving) ? null : saveSkills,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMainGTeal1,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kMainWhite,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}