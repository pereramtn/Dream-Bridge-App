import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';


class SkillCard extends StatelessWidget {
  final String skillName;
  final int value;
  final ValueChanged<int> onChanged;

  const SkillCard({
    super.key,
    required this.skillName,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: kletGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              skillName,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    onChanged(index + 1); // set rating
                  },
                  child: Icon(
                    index < value ? Icons.star : Icons.star_border,
                    color:kbtngreen,
                    size: 32,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}