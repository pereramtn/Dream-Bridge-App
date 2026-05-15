import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course_item.dart';

class CourseCard extends StatelessWidget {
  final CourseItem item;

  const CourseCard({super.key, required this.item});

  void openWebsite() async {
    final Uri url = Uri.parse(item.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Could not launch ${item.url}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openWebsite,
      child: Card(
        
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: kMainTeal4,
        
        child: Column(
          children: [
            Image.asset(item.image, height: 150, width: double.infinity, fit: BoxFit.cover),
            ListTile(
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold,color: kMainTeal2,fontSize: 18),),
              subtitle: Text(item.description, style: const TextStyle(color: Colors.black,fontSize: 16),),
              
            ),
          ],
        ),
      ),
    );
  }
}