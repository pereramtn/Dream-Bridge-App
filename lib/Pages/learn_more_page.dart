import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({super.key});

  @override
  State<LearnMorePage> createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "LEARN MORE"),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kdefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome To Dream Bridge",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: kMainDarkBlue,
                ),
              ),
              Text(
                "Dream Bridge is a platform designed to connect dreamers with oppotunities. Our mission is to bridge the gap between your goals and success through guidence, resources and a supportive community.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kletdarkgray,
                ),
              ),
              Image.asset("assets/Images/learnmore.jpg"),
        
              
        
              Text(
                "What We Offer",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: kMainDarkBlue,
                ),
              ),
        
              const SizedBox(height: 20,),
              
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kMainTeal4,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kdefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person),
                      Text(
                        "Career Guidnce",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kMainDarkBlue,
                        ),
                      ),
                      Text(
                        "Get Mentorship and support to navigate your career path. ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: kletdarkgray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
        
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kMainTeal4,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kdefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.laptop),
                      Text(
                        "Skill development",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kMainDarkBlue,
                        ),
                      ),
                      Text(
                        "Enhance your skills with online courses and workshops ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: kletdarkgray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
        
              Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kMainTeal4,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kdefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.school_sharp),
                      Text(
                        "Internships & Scholarships",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kMainDarkBlue,
                        ),
                      ),
                      Text(
                        "Access oppertunities to grow academically and professionally ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: kletdarkgray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
