import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {

  final List notifications = [
    "🎉 New Dance Battle event added!",
    "🔥 Music Festival is happening near you!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),

      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text(notifications[index]),
            ),
          );
        },
      ),
    );
  }
}