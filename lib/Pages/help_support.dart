import 'package:flutter/material.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  // YouTube link
  final String youtubeUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";

  Future<void> openYouTube() async {
    final Uri url = Uri.parse(youtubeUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Could not open YouTube";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainGTeal1,
        title: const Text(
          "Help & Support",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kMainWhite,
              const Color.fromARGB(255, 255, 255, 255),
              kMainTeal2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Icon(Icons.help_outline, size: 80, color: kMainTeal3),

              const SizedBox(height: 20),

              // TITLE
              const Text(
                "Need Help?",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: kMainTeal3,
                ),
              ),

              const SizedBox(height: 10),

              // DESCRIPTION
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Dream Bridge helps you discover your ideal career path using assessments, AI chatbot, and personalized roadmaps.\n\n"
                  "If you face any issues or need guidance on how to use the app, watch the tutorial video below or contact support.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, height: 1.5),
                ),
              ),

              const SizedBox(height: 30),

              //  VIDEO COVER PHOTO
              GestureDetector(
                onTap: openYouTube,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 190,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage("assets/Images/yt_cover.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Dark overlay
                    Container(
                      height: 190,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.black.withOpacity(0.35),
                      ),
                    ),

                    // Play button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),

                    // Video Text
                    const Positioned(
                      bottom: 15,
                      left: 15,
                      child: Text(
                        "Watch Tutorial Video",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // CONTACT INFO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  children: [
                    Text(
                      "📩 Contact Support",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kMainTeal3,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Email: support@dreambridge.com"),
                    Text("Phone: +94 77 123 4567"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
