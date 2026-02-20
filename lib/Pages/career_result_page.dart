import 'package:flutter/material.dart';
import '../services/career_prediction_service.dart';

class CareerResultPage extends StatefulWidget {
  final String recommendedCareer;

  const CareerResultPage({super.key, required this.recommendedCareer});

  @override
  State<CareerResultPage> createState() => _CareerResultPageState();
}

class _CareerResultPageState extends State<CareerResultPage> {
  final PredictionService _predictionService = PredictionService();

  @override
  void initState() {
    super.initState();
    _savePrediction();
  }

  /// Save prediction to Firebase when page loads
  void _savePrediction() async {
    await _predictionService.savePrediction(widget.recommendedCareer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Recommendation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.workspace_premium,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              "Congratulations!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Based on your inputs, your ideal career is:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Text(
                widget.recommendedCareer,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // go back to previous screen
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Retake Quiz",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
