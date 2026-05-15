import 'package:dream_bridge_app/constants/colors.dart' as Colours;
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoadmapStep {
  final int step;
  final String title;
  final String description;

  RoadmapStep({
    required this.step,
    required this.title,
    required this.description,
  });
}

class RoadmapPage extends StatefulWidget {
  final String selectedCareer;

  const RoadmapPage({super.key, required this.selectedCareer});

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  List<RoadmapStep> steps = [];
  bool isLoading = true;

  // Track completed steps
  Set<int> completedSteps = {};

  @override
  void initState() {
    super.initState();
    loadRoadmap();
  }

  // load roadmap from CSV
  Future<void> loadRoadmap() async {
    final data = await rootBundle.loadString(
      'assets/DataSets/career_roadmaps_75_careers.csv',
    );

    List<List<dynamic>> rows = const CsvToListConverter(
      eol: '\n',
    ).convert(data);

    List<RoadmapStep> tempSteps = [];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.length >= 4) {
        final careerName = row[0].toString().trim();

        if (careerName.toLowerCase() ==
            widget.selectedCareer.trim().toLowerCase()) {
          tempSteps.add(
            RoadmapStep(
              step: int.tryParse(row[1].toString()) ?? 0,
              title: row[2].toString(),
              description: row[3].toString(),
            ),
          );
        }
      }
    }

    tempSteps.sort((a, b) => a.step.compareTo(b.step));

    // load saved completed steps
    await loadCompletedSteps();

    setState(() {
      steps = tempSteps;
      isLoading = false;
    });
  }

  // save completed steps to shared preferences

  Future<void> saveCompletedSteps() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> savedList =
        completedSteps.map((e) => e.toString()).toList();

    await prefs.setStringList(
      "roadmap_${widget.selectedCareer}",
      savedList,
    );
  }

  // load completed steps from shared preferences
  Future<void> loadCompletedSteps() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? savedList =
        prefs.getStringList("roadmap_${widget.selectedCareer}");

    if (savedList != null) {
      completedSteps = savedList.map((e) => int.parse(e)).toSet();
    }
  }

  // toggle step completion
  void toggleDone(int stepNumber) async {
    setState(() {
      if (completedSteps.contains(stepNumber)) {
        completedSteps.remove(stepNumber);
      } else {
        completedSteps.add(stepNumber);
      }
    });

    await saveCompletedSteps();
  }

  // progress calculation

  double get progress {
    if (steps.isEmpty) return 0;

    return completedSteps.length / steps.length;
  }

  int get remainingSteps {
    return steps.length - completedSteps.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.kbtnBlue,

      appBar: CustomAppbar(
        appbar_title: "${widget.selectedCareer} Roadmap",
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Images/road.jpg",
              fit: BoxFit.cover,
            ),
          ),

          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : steps.isEmpty
                  ? const Center(
                      child: Text(
                        "No roadmap found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Column(
                      children: [

                        // top progress card

                        Container(
                          margin: const EdgeInsets.all(15),
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Roadmap Progress",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 10,
                                    backgroundColor:
                                        Colors.grey.shade300,
                                    color: Colours.kbtngreen,
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    "${completedSteps.length} of ${steps.length} steps completed",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    remainingSteps == 0
                                        ? "🎉 All steps completed!"
                                        : "Future steps remaining: $remainingSteps",
                                    style: TextStyle(
                                      color: remainingSteps == 0
                                          ? Colours.kbtngreen
                                          : Colours.kpurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // roadmap steps list
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            itemCount: steps.length,
                            itemBuilder: (context, index) {
                              final step = steps[index];
                              final isLeft = index % 2 == 0;
                              final isDone =
                                  completedSteps.contains(step.step);

                              return Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // LEFT SIDE
                                  if (isLeft)
                                    Expanded(
                                      child: buildCard(
                                        step,
                                        isDone,
                                      ),
                                    )
                                  else
                                    const Expanded(
                                      child: SizedBox(),
                                    ),

                                  // center timeline
                                  Column(
                                    children: [
                                      Container(
                                        width: 2,
                                        height: 40,
                                        color: Colors.white,
                                      ),
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: isDone
                                            ? Colors.green
                                            : Colors.white,
                                      ),
                                      Container(
                                        width: 2,
                                        height: 40,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),

                                  // right side
                                  if (!isLeft)
                                    Expanded(
                                      child: buildCard(
                                        step,
                                        isDone,
                                      ),
                                    )
                                  else
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  // card widget for each roadmap step

  Widget buildCard(RoadmapStep step, bool isDone) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        color: isDone
            ? Colors.green.shade100
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // step number and title

              Text(
                "STEP ${step.step}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colours.kMainTeal3,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(step.description),

              const SizedBox(height: 10),

              // mark as done button

              ElevatedButton.icon(
                onPressed: () =>
                    toggleDone(step.step),

                icon: Icon(
                  isDone
                      ? Icons.check
                      : Icons.done,
                  color: Colors.white,
                ),

                // button label changes based on completion

                label: Text(
                  isDone
                      ? "Completed"
                      : "Mark as Done",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                // button color changes based on completion

                style: ElevatedButton.styleFrom(
                  backgroundColor: isDone
                      ? Colors.green
                      : Colours.kbtnBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}