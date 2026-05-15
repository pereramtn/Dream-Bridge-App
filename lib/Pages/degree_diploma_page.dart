import 'package:dream_bridge_app/data/Srilankan_courses_data.dart';
import 'package:dream_bridge_app/wigets/course_card.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class DegreePage extends StatelessWidget {
  const DegreePage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = SriLankaCoursesData.degreePrograms;

    return Scaffold(
      appBar: CustomAppbar(appbar_title: "Degree & Diploma Programs"),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return CourseCard(item: data[index]);
        },
      ),
    );
  }
}