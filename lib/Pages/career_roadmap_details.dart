import 'package:dream_bridge_app/wigets/homepage_card_details.dart';
import 'package:flutter/material.dart';

class CareerRoadmapDetails extends StatelessWidget {
  const CareerRoadmapDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return HomepageCardDetails(
      title1: 'Career Roadmap',
      description1: 'Sign in to get the real experience and \nunlock your personalized career roadmap.',
      title2: 'What is it ?',
      description2: 'The Career Roadmap feature provides a step-by-step guide that shows users how to reach their dream career. It outlines required skills, education paths, certifications, and milestones based on the selected career field.',
      title3: 'How it helps users',
      description3: 'Gives clear direction instead of confusion \nHelps users plan short-term and long-term career goals \nShows what to learn next and why it matters',
      icon: Icons.map,
    );
  }
}

