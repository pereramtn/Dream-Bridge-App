import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class QuizesPage extends StatefulWidget {
  const QuizesPage({super.key});

  @override
  State<QuizesPage> createState() => _QuizesPageState();
}

class _QuizesPageState extends State<QuizesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "QUIZES"),
    );
  }
}