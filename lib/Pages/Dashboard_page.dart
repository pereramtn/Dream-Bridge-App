import 'package:dream_bridge_app/Pages/Profile_page.dart';
import 'package:dream_bridge_app/Pages/notification.dart';
import 'package:dream_bridge_app/wigets/app_drawer.dart';
import 'package:dream_bridge_app/wigets/progresscard.dart';
import 'package:dream_bridge_app/services/career_prediction_service.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _recommendedCareer;
  bool _isLoading = true;

  @override
void initState() {
  super.initState();
  fetchRecommendedCareer();
}

Future<void> fetchRecommendedCareer() async {
  setState(() => _isLoading = true);
  try {
    String? career = await PredictionService().getLastPrediction();
    setState(() => _recommendedCareer = career);
  } catch (e) {
    setState(() => _recommendedCareer = null);
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00919C),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Dream Bridge",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xffD1D1D1).withOpacity(0.5),
                    ),
                    child: const Icon(Icons.notifications, color: Colors.white, size: 30),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xffD1D1D1).withOpacity(0.5),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard image container
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff002782), width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/Images/dashboardmain.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                const Text(
                  "Recommended Career",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff33425b),
                  ),
                ),

                const SizedBox(height: 10),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Text(
                          _recommendedCareer ?? "No recommended career yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _recommendedCareer != null ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),

                const SizedBox(height: 20),
                ProgressCard(progressValue: 0.3, total: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
