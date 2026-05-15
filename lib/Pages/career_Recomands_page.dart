import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:dream_bridge_app/Pages/roadmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dream_bridge_app/services/api_service.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Career {
  final String name;
  final String description;
  final String link;

  Career({required this.name, required this.description, required this.link});

  Null get steps => null;
}

class CareersPage extends StatefulWidget {
  final CareerRecommendation careerData;

  const CareersPage({super.key, required this.careerData});

  @override
  State<CareersPage> createState() => _CareersPageState();
}

class _CareersPageState extends State<CareersPage> {
  String? selectedCareer;

  List<Career> allCareers = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadCSV();
    loadSavedCareer();
  }

  Future<void> loadSavedCareer() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()!.containsKey('selectedCareer')) {
        setState(() {
          selectedCareer = doc['selectedCareer'];
        });
      }
    } catch (e) {
      print("Error loading career: $e");
    }
  }

  Future<void> saveSelectedCareer(String careerName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'selectedCareer': careerName,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving career: $e");
    }
  }

  Future<void> loadCSV() async {
    final data = await rootBundle.loadString(
      'assets/DataSets/career_dataset_75.csv',
    );

    List<List<dynamic>> rows = const CsvToListConverter().convert(data);

    List<Career> temp = [];

    for (int i = 1; i < rows.length; i++) {
      if (rows[i].length >= 3) {
        temp.add(
          Career(
            name: rows[i][0].toString().trim(),
            description: rows[i][1].toString().trim(),
            link: rows[i][2].toString().trim(),
          ),
        );
      }
    }

    setState(() {
      allCareers = temp;
      isLoaded = true;
    });
  }

  Career? getSelectedCareer() {
    if (selectedCareer == null) return null;

    try {
      return allCareers.firstWhere(
        (c) => c.name.trim() == selectedCareer!.trim(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final career = getSelectedCareer();

    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "Career Recommendations"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kMainWhite, kMainTeal4, kMainGTeal1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text(
                widget.careerData.careerCategory,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kMainTeal2,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount: widget.careerData.topCareers.length,
                  itemBuilder: (context, index) {
                    final careerItem = widget.careerData.topCareers[index];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kMainTeal2,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          careerItem,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.star, color: Colors.amber),
                      ),
                    );
                  },
                ),
              ),

              Text(
                "Select a career for more details:",
                style: TextStyle(
                  fontSize: 17,
                  color: kletdarkgray,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 15),

              // DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: widget.careerData.topCareers.contains(selectedCareer)
                    ? selectedCareer
                    : null,
                decoration: const InputDecoration(
                  labelText: "Select your chosen Career",
                  border: OutlineInputBorder(),
                ),
                items: widget.careerData.topCareers
                .toSet() //REMOVE DUPLICATES
                .map((career) {
                  return DropdownMenuItem(value: career, child: Text(career));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCareer = value;
                  });

                  if (value != null) {
                    saveSelectedCareer(value); // ✅ SAVE TO FIRESTORE
                  }
                },
              ),

              const SizedBox(height: 25),
              if (selectedCareer != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      "Your selected career is: $selectedCareer",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: kMainDarkBlue,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // 🔥 ALWAYS SHOW AREA (FIXED)
              if (!isLoaded)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (selectedCareer != null && career != null)
                //  SHOW CAREER DETAILS
                Center(
                  child: Card(
                    color: kletGray,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text(
                            career.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),

                          ElevatedButton(
                            onPressed: () async {
                              final url = Uri.parse(career.link);
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kbtngreen,
                            ),
                            child: const Text(
                              "Click for More Information",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (selectedCareer != null && career == null)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Career details not found in CSV (check name match).",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                // VIEW ROADMAP BUTTON
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kMainDarkBlue,
                      foregroundColor: kMainWhite,
                    ),
                    onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoadmapPage(selectedCareer: selectedCareer!, ),
                        ),
                      ); },
                    child: const Text("View Roadmap"),
                  ),
                ),
              ),

              

              // Back to assessment button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kMainTeal2,
                      foregroundColor: kMainWhite,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Back to Assessment",
                      style: TextStyle(fontSize: 16),
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
