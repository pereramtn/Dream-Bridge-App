import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "PROGRESS"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("CHACK")
          ],
        ),
      ),
    );
  }
}