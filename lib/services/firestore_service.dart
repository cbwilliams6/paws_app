import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference logs = FirebaseFirestore.instance.collection('activity_logs');

  Future<List<Map<String, dynamic>>> getLogsForDate(DateTime selectedDate) async {
    final start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final end = start.add(Duration(days: 1));

    final querySnapshot = await logs
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThan: end)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
