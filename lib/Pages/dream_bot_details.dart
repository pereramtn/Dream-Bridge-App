import 'package:dream_bridge_app/wigets/homepage_card_details.dart';
import 'package:flutter/material.dart';

class DreamBotDetails extends StatelessWidget {
  const DreamBotDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageCardDetails(
      title1: 'Career Roadmap',
      description1: 'Sign in to get the real experience and \nunlock your personalized career roadmap.',
      title2: 'What is it ?',
      description2: 'DreamBot is an intelligent AI-powered assistant that answers career-related questions, gives guidance, and supports users 24/7.',
      title3: 'How it helps users',
      description3: 'Provides instant career advice \nAnswers questions anytime \nHelps users make informed decisions',
      icon: Icons.chat,
    );
  }
}
