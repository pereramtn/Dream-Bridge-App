import 'package:flutter/material.dart';

class SkillsPercentage extends StatelessWidget {
  final Map<String, String> skills;
  final double skillPercentage;

  const SkillsPercentage({
    super.key,
    required this.skills,
    required this.skillPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skill Assessment"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "You have completed ${skillPercentage.toStringAsFixed(1)}% of your skill selection!",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: skillPercentage / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                  ),
                  Center(
                    child: Text(
                      "${skillPercentage.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Selected Skills:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: skills.entries.map((entry) {
                  return Card(
                    child: ListTile(
                      title: Text(entry.key),
                      trailing: Text(entry.value),
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
