import 'package:flutter/material.dart';

class RoadmapStepCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isDone;
  final VoidCallback onTap;

  const RoadmapStepCard({
    super.key,
    required this.title,
    required this.description,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDone ? Colors.green.shade50 : Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(description),
        trailing: Checkbox(value: isDone, onChanged: (_) => onTap()),
      ),
    );
  }
}
