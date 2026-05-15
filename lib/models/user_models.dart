class StudentModel {
  final String uid;
  final String name;
  final int age;
  final int educationLevel;
  final int stream;
  final bool profileCompleted;

  StudentModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.educationLevel,
    required this.stream,
    required this.profileCompleted,
  });

  factory StudentModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return StudentModel(
      uid: uid,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      educationLevel: data['educationLevel'] ?? 0,
      stream: data['stream'] ?? 0,
      profileCompleted: data['profileCompleted'] ?? false,
    );
  }
}
