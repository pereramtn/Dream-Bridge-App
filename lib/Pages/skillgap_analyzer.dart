import 'package:dream_bridge_app/Pages/explore_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SkillGapAnalyzerPage extends StatefulWidget {
  const SkillGapAnalyzerPage({super.key});

  @override
  State<SkillGapAnalyzerPage> createState() => _SkillGapAnalyzerPageState();
}

class _SkillGapAnalyzerPageState extends State<SkillGapAnalyzerPage> {
  String? selectedCareer;

  Map<String, List<String>> careerData = {};

  Map<String, Set<String>> completedItems = {
    "ol_required": {},
    "al_stream": {},
    "degree_or_required": {},
    "certifications": {},
    "skills": {},
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSavedCareer();
  }

  // LOAD CAREER + SAVED PROGRESS FROM FIRESTORE
  Future<void> loadSavedCareer() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data()!.containsKey('selectedCareer')) {
      selectedCareer = doc['selectedCareer'];

      // LOAD SAVED SKILL PROGRESS
      if (doc.data()!.containsKey('skillGapProgress')) {
        final data = doc['skillGapProgress'];

        completedItems = {
          "ol_required":
              Set<String>.from(data["ol_required"] ?? []),
          "al_stream":
              Set<String>.from(data["al_stream"] ?? []),
          "degree_or_required":
              Set<String>.from(data["degree_or_required"] ?? []),
          "certifications":
              Set<String>.from(data["certifications"] ?? []),
          "skills":
              Set<String>.from(data["skills"] ?? []),
        };
      }

      await loadCSV();
    }
  }

  // SAVE PROGRESS TO FIRESTORE
  Future<void> saveProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      "skillGapProgress": {
        "ol_required": completedItems["ol_required"]!.toList(),
        "al_stream": completedItems["al_stream"]!.toList(),
        "degree_or_required":
            completedItems["degree_or_required"]!.toList(),
        "certifications": completedItems["certifications"]!.toList(),
        "skills": completedItems["skills"]!.toList(),
      }
    }, SetOptions(merge: true));
  }

  // LOAD CSV
  Future<void> loadCSV() async {
    final rawData = await rootBundle.loadString(
      'assets/DataSets/skill_gap_75_careers.csv',
    );

    List<List<dynamic>> rows =
        const CsvToListConverter().convert(rawData);

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row[0].toString().toLowerCase().trim() ==
          selectedCareer!.toLowerCase().trim()) {
        careerData = {
          "ol_required": parseValues(row[1]),
          "al_stream": parseValues(row[2]),
          "degree_or_required": parseValues(row[3]),
          "certifications": parseValues(row[4]),
          "skills": parseValues(row[5]),
        };
        break;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  List<String> parseValues(String value) {
    return value.split(',').map((e) => e.trim()).toList();
  }

  // TOGGLE ITEM + SAVE
  void toggleItem(String category, String item) {
    if (completedItems[category]!.contains(item)) {
      completedItems[category]!.remove(item);
    } else {
      completedItems[category]!.add(item);
    }

    setState(() {});

    // ✅ SAVE AFTER EVERY CHANGE
    saveProgress();
  }

  List<String> getMissingItems() {
    List<String> missing = [];

    careerData.forEach((category, items) {
      for (var item in items) {
        if (!completedItems[category]!.contains(item)) {
          missing.add("$category → $item");
        }
      }
    });

    return missing;
  }

  double get progress {
    int total = 0;
    int done = 0;

    careerData.forEach((key, list) {
      total += list.length;
      done += completedItems[key]!.length;
    });

    if (total == 0) return 0;
    return done / total;
  }

  Widget buildSection(String title, String key) {
    final items = careerData[key] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        ...items.map((item) {
          bool isDone = completedItems[key]!.contains(item);

          return Card(
            color: isDone
                ? const Color.fromARGB(255, 175, 222, 179)
                : Colors.grey.shade200,
            child: ListTile(
              title: Text(item),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDone ? Colors.green : Colors.grey,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => toggleItem(key, item),
                child: Text(isDone ? "Done" : "Mark Done"),
              ),
            ),
          );
        }),

        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final missing = getMissingItems();

    return Scaffold(
      appBar: CustomAppbar(appbar_title: "Skill Gap Analyzer"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset("assets/Images/skillgapp.jpg"),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Career: $selectedCareer",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kMainDarkBlue,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                          "Progress: ${(progress * 100).toStringAsFixed(1)}%"),
                      LinearProgressIndicator(value: progress, minHeight: 7),

                      const SizedBox(height: 20),

                      buildSection("O/L Requirements", "ol_required"),
                      buildSection("A/L Stream", "al_stream"),
                      buildSection(
                          "Degree Required", "degree_or_required"),
                      buildSection("Certifications", "certifications"),
                      buildSection("Skills", "skills"),

                      const SizedBox(height: 20),

                      const Text(
                        "Your Skill Gap",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kbtnRed,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: missing.isEmpty
                              ? const Text("You completed everything!")
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: missing
                                      .map((e) => Text("• $e"))
                                      .toList(),
                                ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ExplorePage(),
                            ),
                          );
                        },
                        child: const Text("Go To Explore Page",
                            style: TextStyle(
                                color: kMainTeal2,
                                fontWeight: FontWeight.w800)),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}