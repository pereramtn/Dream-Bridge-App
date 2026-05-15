import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_bridge_app/Pages/discover_your_path.dart';
import 'package:dream_bridge_app/Pages/dream_bot.dart';
import 'package:dream_bridge_app/Pages/roadmap.dart';
import 'package:dream_bridge_app/Pages/skillgap_analyzer.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:dream_bridge_app/wigets/custom_appbar_no_back.dart';
import 'package:dream_bridge_app/wigets/custom_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String? selectedCareer;

  Future<void> loadSelectedCareer() async {
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

  @override
  void initState() {
    super.initState();
    loadSelectedCareer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kMainTeal4, kMainWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Explore Your Career Options",
                      style: TextStyle(
                        color: kMainTeal2,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    GestureDetector(
                      onTap: () {
                        if (selectedCareer != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RoadmapPage(selectedCareer: selectedCareer!),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a career first"),
                            ),
                          );
                        }
                      },
        
                      child: CustomContainer(
                        imageURL: 'assets/Images/Roadmap.jpg',
                        title: 'CAREER ROADMAP',
                        description: 'Visualize Your Path To Success.',
                        color: kMainWhite,
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SkillGapAnalyzerPage(),
                          ),
                        );
                      },
        
                      child: CustomContainer(
                        imageURL: 'assets/Images/skillgap.jpg',
                        title: 'SKILLGAP ANALYZER',
                        description: 'Identify Skills You Need To Improve.',
                        color: kMainWhite,
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiscoverYourPathPage(),
                          ),
                        );
                      },
        
                      child: CustomContainer(
                        imageURL: 'assets/Images/discoverpath.jpg',
                        title: 'DISCOVER YOUR PATH',
                        description: 'Explore Careers Based On Your Interests.',
                        color: kMainWhite,
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DreamBotPage()),
                        );
                      },
        
                      child: CustomContainer(
                        imageURL: 'assets/Images/dreambot.jpg',
                        title: 'DREAM BOT',
                        description: 'AI Chatbot Help You.',
                        color: kMainWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
