import 'package:dream_bridge_app/Pages/career_roadmap.dart';
import 'package:dream_bridge_app/Pages/discover_your_path.dart';
import 'package:dream_bridge_app/Pages/dream_bot.dart';
import 'package:dream_bridge_app/Pages/skillgap_analyzer.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:dream_bridge_app/wigets/custom_container.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "EXPLORE"),
      body: SafeArea(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CareerRoadmap(),
                        ),
                      );
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
                          builder: (context) => const SkillgapAnalyzer(),
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
                          builder: (context) => const DiscoverYourPath(),
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
                        MaterialPageRoute(
                          builder: (context) => const DreamBot(),
                        ),
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
    );
  }
}
