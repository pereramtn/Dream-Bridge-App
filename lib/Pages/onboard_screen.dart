
import 'package:dream_bridge_app/Pages/onboardPages/front_page.dart';
import 'package:dream_bridge_app/Pages/onboardPages/shared_onboard.dart';
import 'package:dream_bridge_app/Pages/signin_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/data/onboarding_data.dart';
import 'package:dream_bridge_app/wigets/custm_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardState();
}

class _OnboardState extends State<OnboardScreen> {
  //page controller

  final PageController _controller = PageController();
  bool showDetailsPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kdefaultPadding),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // onboard screen
                  PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        showDetailsPage = index == 3;
                      });
                    },
                    children: [
                      const FrontPage(),
                      SharedOnboard(
                        title: onboardingData.onboardingDataList[0].title,
                        imagepath:
                            onboardingData.onboardingDataList[0].imagepath,
                        description:
                            onboardingData.onboardingDataList[0].description,
                      ),
                      SharedOnboard(
                        title: onboardingData.onboardingDataList[1].title,
                        imagepath:
                            onboardingData.onboardingDataList[1].imagepath,
                        description:
                            onboardingData.onboardingDataList[1].description,
                      ),
                      SharedOnboard(
                        title: onboardingData.onboardingDataList[2].title,
                        imagepath:
                            onboardingData.onboardingDataList[2].imagepath,
                        description:
                            onboardingData.onboardingDataList[2].description,
                      ),
                    ],
                  ),

                  //page dot indicator
                  Container(
                    alignment: const Alignment(0, 0.75),
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: const WormEffect(
                        activeDotColor: kMainTeal2,
                        dotColor: kletGray,
                      ),
                    ),
                  ),

                  //navigation button
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: !showDetailsPage 
                      ? GestureDetector(
                        onTap: () {
                          _controller.animateToPage(
                            _controller.page!.toInt() + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child:  CustmButton(
                          btncolour: kMainTeal2,
                          btnname:showDetailsPage ? "Get Started": "Next",
                        ),
                      )
                      : GestureDetector(
                        onTap: () {
                           //navigate to the user data screens
                          Navigator.push(context, MaterialPageRoute(builder:(context) =>SigninPage(),)); 
                        },
                        child:  CustmButton(
                          btncolour: kMainGTeal1,
                          btnname:showDetailsPage ? "Get Started": "Next",
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
