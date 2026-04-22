import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No notifications yet"));
          }

          var notifs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifs.length,
            itemBuilder: (context, index) {

              var data = notifs[index];

              String title = data['title'] ?? "";
              String message = data['message'] ?? "";
              String eventTitle = data['eventTitle'] ?? ""; // ✅ NEW

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text(title),
                  subtitle: Text(message),

                  // ✅ NAVIGATE WITH EVENT DATA
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationDetailScreen(
                          title: title,
                          message: message,
                          eventTitle: eventTitle, // ✅ PASS THIS
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}