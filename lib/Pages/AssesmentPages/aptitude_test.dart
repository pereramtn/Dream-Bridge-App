import 'package:dream_bridge_app/Pages/AssesmentPages/aptitude_test_result.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/models/question.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class AptitudeTestPage extends StatefulWidget {
  final String userId;
  final Function(String) markCompleted;

  const AptitudeTestPage({
    super.key,
    required this.userId,
    required this.markCompleted,
  });

  @override
  State<AptitudeTestPage> createState() => _AptitudeTestPageState();
}

class _AptitudeTestPageState extends State<AptitudeTestPage> {
  int currentIndex = 0;
  List<int?> selectedAnswers = [];

  final List<Question> questions = [
    Question(
      question: 'What is the next number? 3, 6, 12, 24, ?',
      options: ['36', '42', '48', '30'],
      correctIndex: 2,
      category: 'Logical',
    ),
    Question(
      question: 'Find the odd one out',
      options: ['Apple', 'Banana', 'Carrot', 'Mango'],
      correctIndex: 2,
      category: 'Logical',
    ),
    Question(
      question: 'What is 25% of 200?',
      options: ['25', '40', '50', '60'],
      correctIndex: 2,
      category: 'Numerical',
    ),
    Question(
      question: 'If 3 pens cost Rs.90, what is the cost of 5 pens?',
      options: ['120', '150', '180', '200'],
      correctIndex: 1,
      category: 'Numerical',
    ),
    Question(
      question: 'Choose the synonym for "Quick"',
      options: ['Slow', 'Fast', 'Weak', 'Late'],
      correctIndex: 1,
      category: 'Verbal',
    ),
    Question(
      question: 'Choose the antonym for "Success"',
      options: ['Growth', 'Failure', 'Profit', 'Victory'],
      correctIndex: 1,
      category: 'Verbal',
    ),
    Question(
      question: 'Which shape comes next? ⬜ 🔺 ⬜ 🔺 ?',
      options: ['🔺', '⬜', '⚪', '🔵'],
      correctIndex: 1,
      category: 'Spatial',
    ),
    Question(
      question: 'Which object is different from the others?',
      options: ['Circle', 'Square', 'Triangle', 'Line'],
      correctIndex: 3,
      category: 'Spatial',
    ),
    Question(
      question: 'You receive negative feedback. What do you do?',
      options: ['Feel angry', 'Ignore it', 'Accept and improve', 'Quit the task'],
      correctIndex: 2,
      category: 'Situational',
    ),
    Question(
      question: 'You have multiple deadlines. What will you do?',
      options: ['Panic', 'Delay all tasks', 'Prioritize and plan', 'Ignore some work'],
      correctIndex: 2,
      category: 'Situational',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(questions.length, null);
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) setState(() => currentIndex++);
  }

  void previousQuestion() {
    if (currentIndex > 0) setState(() => currentIndex--);
  }

  // ✅ Calculate scores and navigate to Result Page
  Future<void> submitTest() async {
    Map<String, int> scores = {
      'Logical': 0,
      'Numerical': 0,
      'Verbal': 0,
      'Spatial': 0,
      'Situational': 0,
    };

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctIndex) {
        scores[questions[i].category] = scores[questions[i].category]! + 2;
      }
    }

    // Navigate to Result Page and wait for completion
    bool? completed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AptitudeResultPage(
          scores: scores,
          userId: widget.userId,
          markCompleted: widget.markCompleted,
        ),
      ),
    );

    // Refresh progress only if test was marked completed
    if (completed == true) {
      widget.markCompleted("Aptitude Test");
      Navigator.pop(context, true); // Return to AssessmentPage and refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];

    return Scaffold(
      appBar: const CustomAppbar(appbar_title: "Aptitude Test"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              color: kMainTeal2,
              value: (currentIndex + 1) / questions.length,
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${currentIndex + 1} of ${questions.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              color: kletGray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(question.options.length, (index) {
                      return RadioListTile<int>(
                        value: index,
                        groupValue: selectedAnswers[currentIndex],
                        title: Text(question.options[index]),
                        onChanged: (value) {
                          setState(() {
                            selectedAnswers[currentIndex] = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex == 0 ? null : previousQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainGTeal1,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentIndex == questions.length - 1
                      ? submitTest
                      : nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainGTeal1,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    currentIndex == questions.length - 1 ? 'Submit' : 'Next',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
