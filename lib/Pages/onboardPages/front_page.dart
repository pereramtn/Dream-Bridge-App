import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/Images/Logo.png",
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),

        const SizedBox(height: 20),

        Text(
          "Dream Bridge",
          style: TextStyle(
            fontSize: 40,
            color: kMainGTeal1,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: kbtngray.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                " Smart Educational and Career Matching System for Sri Lankan Students ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: kletdarkgray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}
