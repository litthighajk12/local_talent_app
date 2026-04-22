import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../event/event_details_screen.dart';
import '../profile/profile_screen.dart';
import '../notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  String? lastNotificationId; // 🔔 NEW

  @override
  void initState() {
    super.initState();

    // 🔔 LISTEN FOR NEW NOTIFICATIONS
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {

      if (snapshot.docs.isNotEmpty) {
        var latest = snapshot.docs.first;

        if (lastNotificationId != latest.id) {
          lastNotificationId = latest.id;

          String title = latest['title'] ?? "";
          String message = latest['message'] ?? "";

          // 🔔 SHOW POPUP
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$title\n$message"),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Events"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              searchController.clear();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationScreen()),
              );
            },
          ),
        ],
      ),

      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          children: [

            // 🔍 SEARCH
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search events",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),

            // 🔥 EVENTS LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading events"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No events available"));
                  }

                  var events = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {

                      var doc = events[index];
                      var event = doc.data() as Map<String, dynamic>;

                      String title = (event['title'] ?? "No Title").toString();
                      String type = (event['type'] ?? "General").toString();
                      String date = (event['date'] ?? "").toString();
                      String time = (event['time'] ?? "").toString();
                      String location = (event['location'] ?? "").toString();
                      String imageUrl = (event['imageUrl'] ?? "").toString();

                      if (!title.toLowerCase().contains(
                          searchController.text.toLowerCase())) {
                        return SizedBox();
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 160,
                                      color: Colors.grey[300],
                                      child: Center(child: Icon(Icons.image)),
                                    ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          type,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue.shade800),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 5),

                                  Text("$date • $time"),

                                  SizedBox(height: 5),

                                  Text("📍 $location"),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: Text("View Details"),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EventDetailsScreen(event: event),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}