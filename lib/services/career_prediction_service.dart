import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PredictionService {
  final CollectionReference _predictions =
      FirebaseFirestore.instance.collection('predictions');

  // Save prediction
  Future<void> savePrediction(String career) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _predictions.add({
      'userId': uid,
      'career': career,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get last prediction for current user
  Future<String?> getLastPrediction() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final query = await _predictions
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first['career'] as String;
      } else {
        return null; // No prediction yet
      }
    } catch (e) {
      print('Error fetching last prediction: $e');
      return null;
    }
  }
}
