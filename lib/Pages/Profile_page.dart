import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? selectedEducationLevel;
  bool isLoading = true;

  final List<String> educationLevels = [
    'School Leaver',
    'Diploma',
    'Undergraduate',
    'Graduate',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No user logged in!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Auto-fill email
    _emailController.text = currentUser!.email ?? '';

    try {
      final doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        selectedEducationLevel = data['educationLevel'];
      }
    } catch (e) {
      print("Error fetching profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No user logged in!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final educationLevel = selectedEducationLevel ?? 'School Leaver';

      await _firestore.collection('users').doc(currentUser!.uid).set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "educationLevel": educationLevel,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error saving profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "PROFILE"),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Profile First,\nProgress Next!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: kMainTeal2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Fill out your profile to get smarter recommendations.",
                        style: TextStyle(fontSize: 13, color: kMainDarkBlue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: kMainWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: kletdarkgray, width: 3),
                      ),
                      child: const
                    Icon(FontAwesomeIcons.userEdit, size: 70, color: kletdarkgray),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter your name"
                                : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Enter your email"
                                : null,
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: selectedEducationLevel,
                            decoration: InputDecoration(
                              labelText: "Education Level",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: educationLevels
                                .map((level) => DropdownMenuItem(
                                      value: level,
                                      child: Text(level),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedEducationLevel = value;
                              });
                            },
                            validator: (value) => value == null
                                ? "Select education level"
                                : null,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainTeal2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Save Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
    );
  }
}
