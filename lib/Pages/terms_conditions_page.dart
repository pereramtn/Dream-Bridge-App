import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "Terms & Conditions"),
      body: Padding(padding: const EdgeInsets.all(16.0),
       child: Column(
        children: [

          // Introduction Section

          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: const Center(
              child: Text(
                'Introduction',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Text("Welcome to Dream Bridge. These Terms and Conditions govern your use of our application and services. By accessing or using our app, you agree to be bound by these terms. If you do not agree, please do not use our services.",
          style: TextStyle(fontWeight: FontWeight.w300),),

          SizedBox(height: 20,),

          // User Eligibility Section

          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: const Center(
              child: Text(
                'User Eligibility',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Text("You must be at least 18 years old or have permission from a parent or legal guardian to use this application. By using the app, you confirm that you meet this requirement.",
          style: TextStyle(fontWeight: FontWeight.w300),),
        ],
       ),
      ),
    );
  }
}