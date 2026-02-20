import 'package:dream_bridge_app/Pages/Profile_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileCompletionPage extends StatefulWidget {
  final Map<String, dynamic>? preFilledData;
  const ProfileCompletionPage({super.key, this.preFilledData});

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Read-only fields for assessment scores
  final TextEditingController quizeScoreController = TextEditingController();
  final TextEditingController personalSkillsScoreController = TextEditingController();
  final TextEditingController aptitudeTestScoreController = TextEditingController();

  // Dropdown selections
  String? education_level;
  String? stream;
  String? mathsLikeliness;
  String? englishLikeliness;

  // Dropdown options
  final List<String> educationLevels = [
    'School Leaver',
    'Diploma',
    'Undergraduate',
    'Graduate',
  ];

  final List<String> streams = [
    'Science',
    'Commerce',
    'Arts',
    'Engineering',
    'Medical',
    'ICT',
  ];

  final List<String> likelynessValue = ['Low', 'Medium', 'High'];

  
  


  @override
  void initState() {
    super.initState();
    if (widget.preFilledData != null) {
      final data = widget.preFilledData!;
      nameController.text = data['name'] ?? '';
      ageController.text = data['age']?.toString() ?? '';
      education_level = data['educationLevel'] != null
          ? educationLevels[(data['educationLevel'] - 1)]
          : null;
      stream = data['stream'] != null ? streams[(data['stream'] - 1)] : null;
      mathsLikeliness = data['mathsLikeliness'] != null
          ? likelynessValue[(data['mathsLikeliness'] - 1)]
          : null;
      englishLikeliness = data['englishLikeliness'] != null
          ? likelynessValue[(data['englishLikeliness'] - 1)]
          : null;
      quizeScoreController.text = data['quizRate']?.toString() ?? '';
      personalSkillsScoreController.text = data['personalSkillsRate']?.toString() ?? '';
      aptitudeTestScoreController.text = data['aptitudeRate']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    quizeScoreController.dispose();
    personalSkillsScoreController.dispose();
    aptitudeTestScoreController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "Complete Profile"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Your Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your name' : null,
                        ),
                      ),

                      // Age
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: TextFormField(
                          controller: ageController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Your Age',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your age' : null,
                        ),
                      ),

                      // Education Level Dropdown
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Education Level',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: education_level,
                          validator: (value) =>
                              value == null ? 'Please select education level' : null,
                          items: educationLevels
                              .map((level) => DropdownMenuItem<String>(
                                    value: level,
                                    child: Text(level),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => education_level = value),
                        ),
                      ),

                      // Stream Dropdown
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Your Favourite Stream',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: stream,
                          validator: (value) => value == null ? 'Please select stream' : null,
                          items: streams
                              .map((stream) => DropdownMenuItem<String>(
                                    value: stream,
                                    child: Text(stream),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => stream = value),
                        ),
                      ),

                      // Maths Likeliness
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Maths Likeliness',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: mathsLikeliness,
                          validator: (value) =>
                              value == null ? 'Please select Maths likeliness' : null,
                          items: likelynessValue
                              .map((val) => DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => mathsLikeliness = value),
                        ),
                      ),

                      // English Likeliness
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'English Likeliness',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: englishLikeliness,
                          validator: (value) =>
                              value == null ? 'Please select English likeliness' : null,
                          items: likelynessValue
                              .map((val) => DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => englishLikeliness = value),
                        ),
                      ),

                      // Quiz Score (read-only)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: TextFormField(
                          controller: quizeScoreController, // USE EXISTING CONTROLLER
                          decoration: const InputDecoration(
                            labelText: 'Quiz Score',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                        ),
                      ),

                      // Personal Skills Score (read-only)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: TextFormField(
                          controller: personalSkillsScoreController,
                          decoration: const InputDecoration(
                            labelText: 'Personal Skills Score',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                        ),
                      ),

                      // Aptitude Test Score (read-only)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: TextFormField(
                          controller: aptitudeTestScoreController,
                          decoration: const InputDecoration(
                            labelText: 'Aptitude Test Score',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                        ),
                      ),

                      // SAVE BUTTON
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final uid = FirebaseAuth.instance.currentUser!.uid;

                              Map<String, dynamic> profileData = {
                                'name': nameController.text,
                                'age': int.tryParse(ageController.text) ?? 0,
                                'educationLevel': educationLevels.indexOf(education_level!) + 1,
                                'stream': streams.indexOf(stream!) + 1,
                                'mathsLikeliness':
                                    likelynessValue.indexOf(mathsLikeliness!) + 1,
                                'englishLikeliness':
                                    likelynessValue.indexOf(englishLikeliness!) + 1,
                                'quizRate': int.tryParse(quizeScoreController.text) ?? 0,
                                'personalSkillsRate':
                                    int.tryParse(personalSkillsScoreController.text) ?? 0,
                                'aptitudeRate':
                                    int.tryParse(aptitudeTestScoreController.text) ?? 0,
                                'profileCompleted': true,
                              };

                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .set(profileData, SetOptions(merge: true));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Profile Saved Successfully')),
                                );

                                
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => ProfilePage()
                                ));

                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error saving profile: $e')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please complete all fields')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kMainTeal4,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'SAVE PROFILE',
                            style: TextStyle(
                                color: kletdarkgray,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
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
