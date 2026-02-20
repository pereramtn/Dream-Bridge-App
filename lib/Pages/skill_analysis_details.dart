import 'package:dream_bridge_app/wigets/homepage_card_details.dart';
import 'package:flutter/material.dart';

class SkillAnalysisDetails extends StatelessWidget {
  const SkillAnalysisDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageCardDetails(
      title1: 'Personalized Skills Analysis',
      description1: 'Sign in to get the real experience and \nunlock your personalized career roadmap.',
      title2: 'What is it ?',
      description2: 'Personalized Skills Analysis evaluates a user’s current skills, strengths, and weaknesses using assessments and activity data to create a unique skill profile.',
      title3: 'How it helps users',
      description3: 'Identifies skill gaps \nHighlights strengths to build confidence \nSuggests skills to improve for career growth',
      icon: Icons.analytics,
    );
  }
}