import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get logs => _db.collection('activity_logs');

  /// Get app-wide logs for a specific date
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

  /// Stream user-specific activity logs, optionally filtered by date
  Stream<QuerySnapshot> getUserLogs(String uid, {DateTime? date}) {
    Query query = _db
        .collection('Users')
        .doc(uid)
        .collection('activity_logs')
        .orderBy('timestamp', descending: true);

    if (date != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(Duration(days: 1));

      query = query
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('timestamp', isLessThan: Timestamp.fromDate(end));
    }

    return query.snapshots();
  }
}
