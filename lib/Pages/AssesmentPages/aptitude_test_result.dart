import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class AptitudeResultPage extends StatelessWidget {
  final Map<String, int> scores;

  const AptitudeResultPage({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    int total = scores.values.reduce((a, b) => a + b);



    //calculate percentage out of 10 
    double percentage = (total / 10) * 100;

    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "Aptitude Result"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Aptitude Scores',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...scores.entries.map((e) => Card(
                  child: ListTile(
                    title: Text(e.key),
                    trailing: Text('${e.value} / 2'), // each category max 2
                  ),
                )),
            const SizedBox(height: 20),
            Text('Total Score: $total / 10',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 10),

                    

            // Percentage Display
            Text(
              'Percentage: ${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kMainTeal2,
              ),
            ),

              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMainTeal2,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true); // return true to indicate update
                },
                child: const Text("Back to Assessment"),
              ),      
          ],
        ),
      ),
    );
  }
}
