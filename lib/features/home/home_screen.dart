import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../event/event_details_screen.dart';
import '../profile/profile_screen.dart';
import '../../main.dart';
import '../notification/notification_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List events = [
    {
      "title": "Dance Battle 2026",
      "date": "April 2 • 5:00 PM",
      "location": "Neyveli",
      "lat": 11.6088,
      "lng": 79.4766,
      "image":
          "https://images.unsplash.com/photo-1515169067868-5387ec356754"
    },
    {
      "title": "Music Festival Live",
      "date": "April 5 • 6:30 PM",
      "location": "Chennai",
      "lat": 13.0827,
      "lng": 80.2707,
      "image":
          "https://images.unsplash.com/photo-1511379938547-c1f69419868d"
    },
    {
      "title": "Art Workshop",
      "date": "April 10 • 3:00 PM",
      "location": "Pondicherry",
      "lat": 11.9416,
      "lng": 79.8083,
      "image":
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee"
    },
    {
      "title": "Coding Hackathon",
      "date": "April 12 • 9:00 AM",
      "location": "Bangalore",
      "lat": 12.9716,
      "lng": 77.5946,
      "image":
          "https://images.unsplash.com/photo-1518770660439-4636190af475"
    },
    {
      "title": "Photography Contest",
      "date": "April 15 • 4:00 PM",
      "location": "Coimbatore",
      "lat": 11.0168,
      "lng": 76.9558,
      "image":
          "https://images.unsplash.com/photo-1504208434309-cb69f4fe52b0"
    },
    {
      "title": "Drama & Theatre Fest",
      "date": "April 18 • 7:00 PM",
      "location": "Madurai",
      "lat": 9.9252,
      "lng": 78.1198,
      "image":
          "https://images.unsplash.com/photo-1503095396549-807759245b35"
    },
    {
      "title": "Startup Pitch Event",
      "date": "April 20 • 2:00 PM",
      "location": "Hyderabad",
      "lat": 17.3850,
      "lng": 78.4867,
      "image":
          "https://images.unsplash.com/photo-1552664730-d307ca884978"
    },
    {
      "title": "Singing Competition",
      "date": "April 25 • 6:00 PM",
      "location": "Trichy",
      "lat": 10.7905,
      "lng": 78.7047,
      "image":
          "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91"
    },
  ];

  List filteredEvents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredEvents = events;
  }

  void searchEvents(String query) async {
    if (query.isEmpty) {
      setState(() => filteredEvents = events);
      return;
    }

    if (query.toLowerCase().contains("near")) {
      Position position = await Geolocator.getCurrentPosition();
      double userLat = position.latitude;
      double userLng = position.longitude;

      List nearby = events.where((event) {
        double distance = Geolocator.distanceBetween(
          userLat,
          userLng,
          event["lat"],
          event["lng"],
        );
        return distance < 500000;
      }).toList();

      setState(() => filteredEvents = nearby);
      return;
    }

    setState(() {
      filteredEvents = events.where((event) =>
          event["title"].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Events"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => searchEvents("near me"),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                filteredEvents = events;
                searchController.clear();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => MyApp.of(context)!.toggleTheme(),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.pink.shade100],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),

            // 🔥 Firebase Test Button
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('test').add({
                  "name": "Akila",
                  "time": DateTime.now(),
                });
                print("Data added");
              },
              child: Text("Test Firebase"),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                onChanged: searchEvents,
                decoration: InputDecoration(
                  hintText: "Search or type 'near me'",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  var event = filteredEvents[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            event["image"],
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event["title"],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(event["date"]),
                              SizedBox(height: 5),
                              Text("📍 ${event["location"]}"),

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
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
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