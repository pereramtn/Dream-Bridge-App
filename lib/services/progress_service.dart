import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markStepDone(
      String userId, String career, String stepId, bool value) async {
    await _firestore
        .collection('progress')
        .doc(userId)
        .collection(career)
        .doc(stepId)
        .set({'done': value});
  }

  Future<bool> isStepDone(
      String userId, String career, String stepId) async {
    final doc = await _firestore
        .collection('progress')
        .doc(userId)
        .collection(career)
        .doc(stepId)
        .get();

    return doc.exists && doc['done'] == true;
  }
}