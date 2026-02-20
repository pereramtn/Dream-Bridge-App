import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class Dashboardimagecard extends StatefulWidget {
  const Dashboardimagecard({super.key});

  @override
  State<Dashboardimagecard> createState() => _DashboardimagecardState();
}

class _DashboardimagecardState extends State<Dashboardimagecard> {
  @override
  Widget build(BuildContext context) {
    return //container with image& hello
    Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: kMainDarkBlue, width: 3),
        borderRadius: BorderRadius.circular(20),
        
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/Images/dashboardmain.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: Text(
                  "Hello, username \n   Welcome Back..!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
