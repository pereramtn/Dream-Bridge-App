import 'package:flutter/material.dart';

class PreferenceCard extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final Color color;
  final Function(String) onChanged;

  const PreferenceCard({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selected,
              isExpanded: true,
              dropdownColor: color,
              underline: Container(),
              style: const TextStyle(color: Colors.white),
              items: options
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
