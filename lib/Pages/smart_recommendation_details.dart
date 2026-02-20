import 'package:dream_bridge_app/wigets/homepage_card_details.dart';
import 'package:flutter/material.dart';

class SmartRecommendationDetails extends StatelessWidget {
  const SmartRecommendationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageCardDetails(
      title1: 'Smart Recommendation',
      description1: 'Sign in to get the real experience and \nunlock your personalized career roadmap.',
      title2: 'What is it ?',
      description2: 'Smart Recommendations uses AI-driven insights and user data to suggest suitable careers, skills, courses, and learning paths tailored to each user..',
      title3: 'How it helps users',
      description3: 'Provides accurate and personalized career suggestions \nSaves time by filtering the best options \nRecommends skills and resources based on user progress',
      icon: Icons.recommend,
    );
  }
}