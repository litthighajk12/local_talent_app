import 'package:flutter/material.dart';
import '../../services/registration_service.dart';
import 'map_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map event;

  EventDetailsScreen({required this.event});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(event["title"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 EVENT IMAGE
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              child: Image.network(
                event["image"],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    event["title"],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  // DATE
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 8),
                      Text(event["date"]),
                    ],
                  ),

                  SizedBox(height: 8),

                  // LOCATION
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 8),
                      Text(event["location"]),
                    ],
                  ),

                  SizedBox(height: 15),

                  // MAP BUTTON
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MapScreen(location: event["location"]),
                        ),
                      );
                    },
                    icon: Icon(Icons.map),
                    label: Text("View on Map"),
                  ),

                  SizedBox(height: 20),

                  // DESCRIPTION
                  Text(
                    "About Event",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Join this exciting event and showcase your talent. Participate, compete, and connect with others in your area!",
                  ),

                  SizedBox(height: 25),

                  // REGISTRATION SECTION
                  Text(
                    "Register Now",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Your Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        RegistrationService.registerEvent(event);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "🎉 Registered Successfully! Notification will be sent."),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text("Confirm Registration"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}