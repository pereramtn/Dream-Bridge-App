import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CareerRecommendation {
  final String careerCategory;
  final String recommendedCareer1;
  final String recommendedCareer2;
  final String recommendedCareer3;

  CareerRecommendation({
    required this.careerCategory,
    required this.recommendedCareer1,
    required this.recommendedCareer2,
    required this.recommendedCareer3,
  });

  //  Convert JSON safely
  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    print("API RESPONSE JSON: $json"); // DEBUG

    return CareerRecommendation(
      careerCategory: json['career_category'] ?? 'Unknown Category',
      recommendedCareer1: json['recommended_career_1'] ?? 'No Career 1',
      recommendedCareer2: json['recommended_career_2'] ?? 'No Career 2',
      recommendedCareer3: json['recommended_career_3'] ?? 'No Career 3',
    );
  }

  // convert to list for UI
  List<String> get topCareers => [
        recommendedCareer1,
        recommendedCareer2,
        recommendedCareer3,
      ];
}

Future<CareerRecommendation> fetchRecommendations(
    Map<String, dynamic> userData) async {
  final String apiUrl = 'http://10.0.2.2:8000/predict'; 

  try {
    print("SENDING DATA: $userData"); // DEBUG

    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userData),
        )
        .timeout(const Duration(seconds: 15));

    print("STATUS CODE: ${response.statusCode}");
    print("RAW RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return CareerRecommendation.fromJson(jsonData);
    } else {
      throw Exception("Server Error: ${response.statusCode}");
    }
  } on SocketException {
    throw Exception(
        "Cannot reach server. Check Wi-Fi & IP address (same network).");
  } catch (e) {
    print("FULL ERROR: $e");
    rethrow;
  }
}