class CareerRecommendation {
  String career;
  double match;

  CareerRecommendation({required this.career, required this.match});

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      career: json['career'] ?? '',
      match: (json['match'] ?? 0).toDouble(), 
    );
  }

  Null get topCareers => null;

  String? get careerCategory => null;
}