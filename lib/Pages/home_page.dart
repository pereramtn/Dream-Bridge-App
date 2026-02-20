import 'package:dream_bridge_app/Pages/career_roadmap_details.dart';
import 'package:dream_bridge_app/Pages/create_account_page.dart';
import 'package:dream_bridge_app/Pages/discover_path_details.dart';
import 'package:dream_bridge_app/Pages/dream_bot_details.dart';
import 'package:dream_bridge_app/Pages/learn_more_page.dart';
import 'package:dream_bridge_app/Pages/quizes_details.dart';
import 'package:dream_bridge_app/Pages/signin_page.dart';
import 'package:dream_bridge_app/Pages/skill_analysis_details.dart';
import 'package:dream_bridge_app/Pages/smart_recommendation_details.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/providers/theam_provider.dart';
import 'package:dream_bridge_app/wigets/boaderbutton.dart';
import 'package:dream_bridge_app/wigets/custm_button.dart';
import 'package:dream_bridge_app/wigets/home_page_containers.dart';
import 'package:dream_bridge_app/wigets/slideshow_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: AlignmentGeometry.bottomLeft,
            colors: [kMainTeal3, kletGray],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //light dark mode button
                Padding(
                  padding: const EdgeInsets.fromLTRB(280, 18, 5, 5),
                  child: Container(
                    height: 45,
                    width: 80,

                    decoration: BoxDecoration(
                      border: Border.all(color: kMainTeal2, width: 3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Provider.of<TheamProvider>(
                          context,
                          listen: false,
                        ).toggleTheme(
                          Theme.of(context).brightness != Brightness.dark,
                        );
                      },
                      icon: Icon(
                        Theme.of(context).brightness == Brightness.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                    ),
                  ),
                ),
                //title text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "DISCOVER YOUR PERFECT \n CAREER PATH ",
                    style: TextStyle(
                      fontSize: 38,
                      color: kMainTeal2,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),

                //slideshow images
                SlideShowImages(),

                const SizedBox(height: 25),

                //login button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninPage(),
                      ),
                    );
                  },

                  child: CustmButton(btncolour: kbtngreen, btnname: "SIGN IN"),
                ),

                const SizedBox(height: 20),

                //create account button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountPage(),
                      ),
                    );
                  },
                  child: CustmButton(
                    btncolour: kbtnBlue,
                    btnname: "CREATE ACCOUNT",
                  ),
                ),

                const SizedBox(height: 20),

                //learnmore button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LearnMorePage(),
                      ),
                    );
                  },
                  child: Boaderbutton(
                    btnname: 'LEARN MORE',
                    bodercolour: kMainDarkBlue,
                    txtcolour: kMainDarkBlue,
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Dream Bridge is a smart and friendly career guidance app that helps you turn your dreams into real career paths. By understanding your interests and education, it connects you with the right opportunities and clear directions for your future building a strong bridge between who you are today and who you want to become.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ),

                Divider(color: kletdarkgray, thickness: 2),

                const SizedBox(height: 20),

                //container cards
                Text(
                  "Why Choose DREAM BRIDGE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: kMainWhite,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Our platform offers comprehensive tools to help students make informed decisions about their future careers.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CareerRoadmapDetails(),
                          ),
                        );
                      },
                      child: HomePageContainers(
                        icon: Icons.map,
                        title: "Career Road Map",
                        descripotion:
                            "Visualize your academic and career journey step by step",
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SkillAnalysisDetails(),
                          ),
                        );
                      },
                      child: HomePageContainers(
                        icon: Icons.analytics,
                        title: "Personalized Skills Analysis",
                        descripotion:
                            "Discover which skills you should develop to succeed.",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiscoverPathDetails(),
                          ),
                        );
                      },

                      child: HomePageContainers(
                        icon: Icons.search,
                        title: "Discover Path",
                        descripotion: "Find your ideal career direction. ",
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DreamBotDetails(),
                          ),
                        );
                      },
                      child: HomePageContainers(
                        icon: Icons.chat,
                        title: "Dream Bot",
                        descripotion:
                            "Chat with our AI bot to get career sugessions.",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizesDetails(),
                          ),
                        );
                      },
                      child: HomePageContainers(
                        icon: Icons.quiz,
                        title: "Quizes",
                        descripotion: "Test your knowledge and personality. ",
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SmartRecommendationDetails(),
                          ),
                        );
                      },
                      child: HomePageContainers(
                        icon: Icons.recommend_outlined,
                        title: "Smart Recommendations",
                        descripotion: "Get career suggestions ",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Divider(color: kletdarkgray, thickness: 2),

                const SizedBox(height: 20),

                // how it works part
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(kdefaultPadding),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kbtngray,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Text(
                        "How It Works",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: kMainGTeal1,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "Our simple three-step process helps you discover and plan your ideal career path.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),

                      //number 1 container
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: kMainTeal3,
                        ),
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: kMainWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/Images/profilecomplete.jpg",
                          height: 300,
                        ),
                      ),

                      Text(
                        "Complete Your Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: kMainTeal2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "Fill out a comprehensive profile with your academic background, skills, interests, and career preferences.",
                          style: TextStyle(fontSize: 15, color: kbtnBlue),
                        ),
                      ),

                      //number 2 container
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: kMainTeal3,
                        ),
                        child: Text(
                          "2",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: kMainWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/Images/getrecommondations.jpg",
                          height: 300,
                        ),
                      ),

                      Text(
                        "Get Recommendations",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: kMainTeal2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          "Our AI analyzes your profile and matches you with suitable career paths based on your unique attributes.",
                          style: TextStyle(fontSize: 15, color: kbtnBlue),
                        ),
                      ),

                      //number 3 container
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: kMainTeal3,
                        ),
                        child: Text(
                          "3",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: kMainWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/Images/plan.jpg",
                          height: 300,
                        ),
                      ),

                      Text(
                        "Explore & Plan",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: kMainTeal2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          "Explore detailed career information, required skills, and educational pathways to achieve your goals.",
                          style: TextStyle(fontSize: 15, color: kbtnBlue),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //Start Your Journey
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: kMainDarkBlue),

                  child: Padding(
                    padding: const EdgeInsets.all(kdefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Text(
                          "Start Your Journey",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: kMainWhite,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Take the first step towards discovering your perfect career path today.",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: kMainTeal3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SigninPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: kbtngreen,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(kdefaultPadding),
                              child: Text(
                                "Get Started Now",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: kMainDarkBlue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
      ),
    );
  }
}
