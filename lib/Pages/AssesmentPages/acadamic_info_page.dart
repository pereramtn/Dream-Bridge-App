import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_bridge_app/constants/colors.dart';

class AcademicInfoPage extends StatefulWidget {
  final String userId;
  final void Function(String key) markCompleted;

  const AcademicInfoPage({
    super.key,
    required this.userId,
    required this.markCompleted,
  });

  @override
  State<AcademicInfoPage> createState() => _AcademicInfoPageState();
}

class _AcademicInfoPageState extends State<AcademicInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isSaving = false;

  // O/L Subjects
  final Map<String, String> olSubjects = {
    "Mathematics": "",
    "Science": "",
    "English": "",
  };

  final List<String> grades = ["A", "B", "C", "S", "F"];

  // A/L
  String alStream = "";
  final Map<String, String> alSubjects = {};

  final List<String> alOptions = [
    "Biological Science",
    "Mathematics",
    "Commerce",
    "Arts",
    "Technology",
  ];

  @override
  void initState() {
    super.initState();
    loadAcademicData();
  }

  // ================= LOAD DATA =================
  Future<void> loadAcademicData() async {
    try {
      final snapshot = await _firestore
          .collection("students")
          .doc(widget.userId)
          .collection("academicInfo")
          .doc("academic_data")
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final academic = snapshot.data()!;

        setState(() {
          // Load O/L
          if (academic.containsKey("olResults")) {
            Map<String, dynamic> savedOl = Map<String, dynamic>.from(
              academic["olResults"],
            );

            for (var subject in olSubjects.keys) {
              if (savedOl.containsKey(subject)) {
                olSubjects[subject] = savedOl[subject];
              }
            }
          }

          // Load A/L Stream
          alStream = academic["alStream"] ?? "";

          // Load A/L subjects
          if (academic.containsKey("alResults")) {
            alSubjects.clear();
            Map<String, dynamic> savedAl = Map<String, dynamic>.from(
              academic["alResults"],
            );

            savedAl.forEach((key, value) {
              alSubjects[key] = value;
            });
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading academic data: $e");
    }
  }

  // save academic info to Firestore
  Future<void> submitData() async {
    if (isSaving) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      Map<String, dynamic> academicData = {
        "academic_id": "academic_data",
        "user_id": widget.userId,
        "olResults": olSubjects,
        "alStream": alStream,
        "alResults": alSubjects,
      };

      await _firestore
          .collection("students") 
          .doc(widget.userId)
          .collection("academicInfo")
          .doc("academic_data")
          .set(academicData, SetOptions(merge: true));

      widget.markCompleted("Academic Info");

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint("Error saving academic info: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error saving data. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }



  // Page UI



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "ACADEMIC INFO"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                

                // O/L Section
                const Text(
                  "Ordinary Level Results (O/L)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                ...olSubjects.keys.map(
                  (subject) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: DropdownButtonFormField<String>(
                      initialValue: olSubjects[subject]!.isNotEmpty
                          ? olSubjects[subject]
                          : null,
                      decoration: InputDecoration(
                        labelText: "$subject Grade",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: grades
                          .map(
                            (grade) => DropdownMenuItem(
                              value: grade,
                              child: Text(grade),
                            ),
                          )
                          .toList(),
                      validator: (value) => value == null || value.isEmpty
                          ? "Select grade for $subject"
                          : null,
                      onChanged: (value) {
                        setState(() {
                          olSubjects[subject] = value!;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 25),



                // A/L Section
                const Text(
                  "Advanced Level Stream (A/L)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  initialValue: alStream.isNotEmpty ? alStream : null,
                  decoration: InputDecoration(
                    labelText: "Select Your A/L Stream",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: alOptions
                      .map(
                        (stream) => DropdownMenuItem(
                          value: stream,
                          child: Text(stream),
                        ),
                      )
                      .toList(),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please select A/L stream"
                      : null,
                  onChanged: (value) {
                    setState(() {
                      alStream = value!;
                      alSubjects.clear();
                    });
                  },
                ),

                const SizedBox(height: 35),



                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSaving ? Colors.grey : kMainTeal2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      isSaving ? "Saving..." : "Submit Academic Info",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
