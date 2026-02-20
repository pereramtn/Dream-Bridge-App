import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';

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

  final Map<String, String> olSubjects = {
    "Mathematics": "",
    "Science": "",
    "English": "",
    "Sinhala/Tamil": "",
    "History": "",
  };

  final List<String> grades = ["A", "B", "C", "S", "F"];

  String alStream = "Not yet";
  final Map<String, String> alSubjects = {};
  final List<String> alOptions = [
    "Biological Science",
    "Mathematics",
    "Commerce",
    "Arts",
    "Technology",
    "Not yet",
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isSaving = false; // ✅ Disable button while saving

  @override
  void initState() {
    super.initState();
    loadAcademicData();
  }

  Future<void> loadAcademicData() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(widget.userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey("academicInfo")) {
          Map<String, dynamic> academic =
              Map<String, dynamic>.from(data["academicInfo"]);

          setState(() {
            if (academic.containsKey("olResults")) {
              Map<String, dynamic> savedOl =
                  Map<String, dynamic>.from(academic["olResults"]);
              savedOl.forEach((key, value) {
                if (olSubjects.containsKey(key)) olSubjects[key] = value;
              });
            }

            alStream = academic["alStream"] ?? "Not yet";

            if (academic.containsKey("alResults")) {
              alSubjects.clear();
              Map<String, dynamic> savedAl =
                  Map<String, dynamic>.from(academic["alResults"]);
              savedAl.forEach((key, value) {
                alSubjects[key] = value;
              });
            }
          });
        }
      }
    } catch (e) {
      print("Error loading academic data: $e");
    }
  }

  Future<void> submitData() async {
    if (isSaving) return; // Prevent multiple taps

    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      isSaving = true; // Disable button
    });

    Map<String, dynamic> academicData = {
      "olResults": olSubjects,
      "alStream": alStream,
      "alResults": alSubjects,
    };

    try {
      await _firestore.collection("users").doc(widget.userId).set(
            {"academicInfo": academicData},
            SetOptions(merge: true),
          );

      widget.markCompleted("Academic Info");

      // Return true to refresh AssessmentPage
      Navigator.pop(context, true);
    } catch (e) {
      print("Error saving academic info: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error saving data. Please try again."),
        ),
      );
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
      appBar: const CustomAppbar(appbar_title: "ACADEMIC INFO"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kdefaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ordinary Level Results (O/L)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...olSubjects.keys.map((subject) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        value: olSubjects[subject]!.isNotEmpty
                            ? olSubjects[subject]
                            : null,
                        decoration: InputDecoration(
                          labelText: "$subject Grade",
                          border: const OutlineInputBorder(),
                        ),
                        items: grades
                            .map((grade) => DropdownMenuItem(
                                  value: grade,
                                  child: Text(grade),
                                ))
                            .toList(),
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Please select grade for $subject"
                            : null,
                        onChanged: (value) {
                          setState(() {
                            olSubjects[subject] = value!;
                          });
                        },
                        onSaved: (value) {
                          olSubjects[subject] = value!;
                        },
                      ),
                    )),

                const SizedBox(height: 20),
                const Text(
                  "Advanced Level Stream (A/L)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: alStream != "Not yet" ? alStream : null,
                  items: alOptions
                      .map((stream) => DropdownMenuItem(
                            value: stream,
                            child: Text(stream),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      alStream = value!;
                      if (alStream == "Not yet") alSubjects.clear();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select A/L stream";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Select Your A/L Stream",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                if (alStream != "Not yet") ...[
                  const Text(
                    "Enter A/L Subject Results",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (int i = 1; i <= 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        initialValue: alSubjects["Subject $i"],
                        decoration: InputDecoration(
                          labelText: "Subject $i Grade",
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter grade for subject $i";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) alSubjects["Subject $i"] = value;
                        },
                      ),
                    ),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSaving ? Colors.grey : kMainGTeal1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      isSaving ? "Saving..." : "Submit Academic Info",
                      style: const TextStyle(fontSize: 18),
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
