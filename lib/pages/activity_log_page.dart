import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActivityLogPage extends StatefulWidget {
  @override
  _ActivityLogPageState createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Center(child: Text("Not logged in"));

    final logQuery = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('activity_logs')
        .orderBy('timestamp', descending: true);

    DateTime? start;
    DateTime? end;

    if (selectedDate != null) {
      start = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
      end = start.add(Duration(days: 1));
    }

    final filteredQuery = selectedDate != null
        ? logQuery
            .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start!))
            .where('timestamp', isLessThan: Timestamp.fromDate(end!))
        : logQuery;


    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Log"),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          ),
          if (selectedDate != null)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => setState(() => selectedDate = null),
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: filteredQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No logs found."));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] as Timestamp?;
              final message = data['message'] ?? 'Unknown event';

              return ListTile(
                title: Text(message),
                subtitle: Text(
                  timestamp != null
                      ? DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate())
                      : 'No timestamp',
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
