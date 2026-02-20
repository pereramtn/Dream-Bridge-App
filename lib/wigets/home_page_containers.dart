import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:flutter/material.dart';

class HomePageContainers extends StatelessWidget {
  final IconData icon;
  final String title;
  final String descripotion;

  const HomePageContainers({
    super.key,
    required this.icon,
    required this.title,
    required this.descripotion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 180,
        width: 180,
      
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kMainWhite,
      
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, size: 50, color: kMainTeal2),
              ),
      
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: kMainTeal2,
                ),
              ),
              Text(
                descripotion,
                style: TextStyle(fontSize: 11, color: kbtnBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
