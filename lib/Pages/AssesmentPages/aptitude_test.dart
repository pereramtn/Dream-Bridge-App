import 'package:dream_bridge_app/Pages/AssesmentPages/aptitude_test_result.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Question model
class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String category;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.category,
  });
}

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
  late List<int?> selectedAnswers;

  // Sample questions for the aptitude test

  final List<Question> questions = [
    Question(
      question: 'Find the next number: 2, 4, 8, 16, ?',
      options: ['20', '32', '24', '30'],
      correctIndex: 1,
      category: 'Logical',
    ),
    Question(
      question: 'Which one is odd out?',
      options: ['Dog', 'Cat', 'Bird', 'Car'],
      correctIndex: 3,
      category: 'Logical',
    ),
    Question(
      question: 'What is 15% of 200?',
      options: ['20', '25', '30', '35'],
      correctIndex: 2,
      category: 'Numerical',
    ),
    Question(
      question: 'If 5 pens cost 150, 8 pens cost?',
      options: ['200', '240', '250', '260'],
      correctIndex: 1,
      category: 'Numerical',
    ),
    Question(
      question: 'Synonym of "Happy"?',
      options: ['Sad', 'Joyful', 'Angry', 'Tired'],
      correctIndex: 1,
      category: 'Verbal',
    ),
    Question(
      question: 'Antonym of "Strong"?',
      options: ['Weak', 'Powerful', 'Firm', 'Tough'],
      correctIndex: 0,
      category: 'Verbal',
    ),
    Question(
      question: 'Which shape comes next? ◻️ 🔺 ◻️ 🔺 ?',
      options: ['◻️', '🔺', '⚪', '🔵'],
      correctIndex: 0,
      category: 'Spatial',
    ),
    Question(
      question: 'Which object is different?',
      options: ['Circle', 'Square', 'Triangle', 'Line'],
      correctIndex: 3,
      category: 'Spatial',
    ),
    Question(
      question: 'You have multiple tasks, what do you do?',
      options: ['Panic', 'Do randomly', 'Prioritize and plan', 'Ignore some'],
      correctIndex: 2,
      category: 'Situational',
    ),
    Question(
      question: 'Negative feedback received, you:',
      options: ['Angry', 'Ignore', 'Accept & improve', 'Quit'],
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
    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }


// Calculate scores and save apptitude test data to Firestore
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
        scores[questions[i].category] =
            scores[questions[i].category]! + 1;
      }
    }

    try {
      await FirebaseFirestore.instance
          .collection("students")
          .doc(widget.userId)
          .collection("aptitudeTest")
          .doc("aptitude_data")
          .set({
        "aptitude_id": "aptitude_data",
        "user_id": widget.userId,
        "scores": scores,
      });

      widget.markCompleted("Aptitude Test");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AptitudeResultPage(scores: scores),
          ),
        );
      }
    } catch (e) {
      print("Error saving aptitude test: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error saving test. Please try again."),
          ),
        );
      }
    }
  }
  

  // Page UI

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
            Expanded(
              child: Card(
                elevation: 4,
                color: kletGray,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
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
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      currentIndex == 0 ? null : previousQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainGTeal1,
                    foregroundColor: kMainWhite,
                  ),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: selectedAnswers[currentIndex] == null
                      ? null
                      : (currentIndex == questions.length - 1
                          ? submitTest
                          : nextQuestion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedAnswers[currentIndex] == null
                            ? Colors.grey
                            : kMainGTeal1,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    currentIndex == questions.length - 1
                        ? 'Submit'
                        : 'Next',
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