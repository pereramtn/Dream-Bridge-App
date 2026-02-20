import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getCareerRecommendation({
  required int age,
  required int educationLevel,
  required int stream,
  required double mathScore,
  required double englishScore,
  required double quizRate,
  required double skillRate,
  required double aptitudeRate,
}) async {
  var url = Uri.parse("http://127.0.0.1:8000/predict"); // your API URL

  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "age": age,
      "education_level": educationLevel,
      "stream": stream,
      "math_score": mathScore,
      "english_score": englishScore,
      "quiz_rate": quizRate,
      "skill_rate": skillRate,
      "aptitude_rate": aptitudeRate
    }),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['recommended_career'];
  } else {
    throw Exception('Failed to get recommendation');
  }
}
