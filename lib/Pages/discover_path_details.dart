import 'package:dream_bridge_app/wigets/homepage_card_details.dart';
import 'package:flutter/material.dart';

class DiscoverPathDetails extends StatelessWidget {
  const DiscoverPathDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageCardDetails(
      title1: 'Discover Path',
      description1: 'Sign in to get the real experience and \nunlock your personalized career roadmap.',
      title2: 'What is it ?',
      description2: 'Discover Path helps users explore different career options based on their interests, skills, and personality.',
      title3: 'How it helps users',
      description3: 'Helps users discover careers they didn’t know about \nMatches interests with real-world career paths \nReduces uncertainty when choosing a career',
      icon: Icons.search,
    );
  }
}
