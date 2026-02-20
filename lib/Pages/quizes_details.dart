import 'package:dream_bridge_app/wigets/homepage_card_details.dart';
import 'package:flutter/material.dart';

class QuizesDetails extends StatelessWidget {
  const QuizesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageCardDetails(
      title1: 'Quizzes',
      description1:
          'Sign in to get the real experience and \nunlock your personalized career roadmap.',
      title2: 'What is it ?',
      description2:
          'The Quizzes feature includes interactive tests designed to understand a user’s interests, abilities, personality traits, and career preferences through simple and engaging questions.',
      title3: 'How it helps users',
      description3:
          'Helps users understand themselves better \nIdentifies interests and natural abilities \nMakes career exploration fun and interactive',
      icon: Icons.quiz,
    );
  }
}
