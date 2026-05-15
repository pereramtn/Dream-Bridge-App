import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_bridge_app/Pages/AssesmentPages/assesment_page.dart';
import 'package:dream_bridge_app/Pages/Profile_page.dart';
import 'package:dream_bridge_app/Pages/career_Recomands_page.dart';
import 'package:dream_bridge_app/Pages/dream_bot.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/services/api_service.dart';
import 'package:dream_bridge_app/wigets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _quoteController = PageController();
  int _quoteIndex = 0;

  // CAREER RECOMMENDATION DATA
  CareerRecommendation? careerData;
  bool isLoadingCareer = false;

  // USER ID
  String? userId;

  // ✅ YouTube link
  final String youtubeUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";

  final List<String> quotes = [
    "Education is the passport to the future.",
    "Your career is built step by step.",
    "Dream big, start small, act now.",
    "Success starts with self assessment.",
  ];

  final PageController _bannerController = PageController();
  int _bannerIndex = 0;

  final List<String> banners = [
    "assets/Images/dashboard.jpg",
    "assets/Images/dashboard2.jpeg",
    "assets/Images/dashboard3.jpeg",
    "assets/Images/dashboard4.jpeg",
  ];

  Timer? _quoteTimer;

  // REAL ASSESSMENT STATUS
  Map<String, bool> completedAssessments = {
    "Academic Info": false,
    "Interest Assessment": false,
    "Personal Skills": false,
    "Aptitude Test": false,
    "Personality Test": false,
  };

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning ☀️";
    } else if (hour < 17) {
      return "Good Afternoon 🌤️";
    } else {
      return "Good Evening 🌙";
    }
  }

  // LOAD REAL FIRESTORE ASSESSMENT STATUS
  Future<void> loadAssessmentStatus() async {
    if (userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(userId)
          .get();

      if (!snapshot.exists) return;

      final data = snapshot.data();

      if (data == null || !data.containsKey('assessments')) return;

      final saved = Map<String, dynamic>.from(data['assessments']);

      setState(() {
        completedAssessments.updateAll((key, value) {
          return saved[key] == true;
        });
      });
    } catch (e) {
      debugPrint("Dashboard assessment loading error: $e");
    }
  }

  //  OPEN YOUTUBE
  Future<void> openYouTube() async {
    final Uri url = Uri.parse(youtubeUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Could not open YouTube";
    }
  }

  @override
  void initState() {
    super.initState();

    userId = FirebaseAuth.instance.currentUser?.uid;

    _startQuoteAutoSlide();

    loadAssessmentStatus();
  }

  void _startQuoteAutoSlide() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_quoteController.hasClients) {
        _quoteIndex = (_quoteIndex + 1) % quotes.length;

        _quoteController.animateToPage(
          _quoteIndex,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });

    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        _bannerIndex++;

        if (_bannerIndex >= banners.length) {
          _bannerIndex = 0;
        }

        _bannerController.animateToPage(
          _bannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _quoteController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  double get progress {
    int total = completedAssessments.length;
    int done = completedAssessments.values.where((v) => v).length;

    return total == 0 ? 0 : done / total;
  }

  bool get allCompleted => progress >= 1.0;

  String? get careerCategory => null;

  Future<void> openAssessment() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AssessmentPage()),
    );

    // REFRESH AFTER RETURNING
    loadAssessmentStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00919C),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Dream Bridge",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),

            // chatbot icon button
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DreamBotPage()),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              ),
            ),
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kMainWhite, kMainTeal4, kMainWhite],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting text
                Text(
                  "${getGreeting()}, ",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 230,
                  width: double.infinity,

                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: banners.length,

                    onPageChanged: (index) {
                      setState(() {
                        _bannerIndex = index;
                      });
                    },

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),

                          child: Image.asset(
                            banners[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                //Assessment progress card
                GestureDetector(
                  onTap: openAssessment,

                  child: Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),

                      gradient: LinearGradient(colors: [kMainTeal3, kbtnBlue]),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Assessment Completion",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Please complete your profile to unlock more accurate and personalized results!",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: kbtngray,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: const Color.fromARGB(
                              202,
                              224,
                              224,
                              224,
                            ),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "${(progress * 100).round()}% Completed",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kMainWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Auto sliding quotes section
                Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),

                    color: kMainWhite.withOpacity(0.18),

                    border: Border.all(
                      color: kMainWhite.withOpacity(0.3),
                      width: 1.2,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),

                      BoxShadow(
                        color: kMainWhite.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                  ),

                  child: SizedBox(
                    height: 80,

                    child: PageView.builder(
                      controller: _quoteController,
                      itemCount: quotes.length,

                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(
                            quotes[index],
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                              color: kletdarkgray,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                //youtube section
                const Text(
                  "How to use Dream Bridge",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: openYouTube,

                  child: Stack(
                    alignment: Alignment.center,

                    children: [
                      Container(
                        height: 190,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],

                          image: const DecorationImage(
                            image: AssetImage("assets/Images/yt_cover.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Container(
                        height: 190,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),

                        child: const Padding(
                          padding: EdgeInsets.all(12),

                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                      ),

                      const Positioned(
                        bottom: 15,
                        left: 15,

                        child: Text(
                          "Watch Tutorial Video",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
