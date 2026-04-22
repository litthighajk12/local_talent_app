import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String title;
  final String message;
  final String eventTitle;

  const NotificationDetailScreen({
    super.key,
    required this.title,
    required this.message,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Details"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔔 Notification Text
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(message),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🔥 EVENT DETAILS
            if (eventTitle.isNotEmpty)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .where('title', isEqualTo: eventTitle)
                      .snapshots(),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("Event details not found"));
                    }

                    var event = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;

                    String imageUrl = event['imageUrl'] ?? "";
                    String date = event['date'] ?? "";
                    String time = event['time'] ?? "";
                    String location = event['location'] ?? "";
                    String description = event['description'] ?? "";

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // 📷 IMAGE
                              if (imageUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(imageUrl),
                                ),

                              SizedBox(height: 10),

                              Text(eventTitle,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),

                              SizedBox(height: 10),

                              Text("📅 $date • $time"),
                              SizedBox(height: 5),
                              Text("📍 $location"),

                              SizedBox(height: 15),

                              Text("About Event",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(description),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}