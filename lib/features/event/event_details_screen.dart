import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'map_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  EventDetailsScreen({required this.event});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 🔥 SAFE DATA (NO CRASH)
    String title = (event['title'] ?? "No Title").toString();
    String imageUrl = (event['imageUrl'] ?? "").toString();
    String date = (event['date'] ?? "").toString();
    String time = (event['time'] ?? "").toString();
    String location = (event['location'] ?? "").toString();
    String description = (event['description'] ??
            "Join this exciting event and showcase your talent.")
        .toString();
    String phone = (event['contactPhone'] ?? "").toString();
    String email = (event['contactEmail'] ?? "").toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 IMAGE
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.image)),
                  ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 8),
                      Text("$date • $time"),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 8),
                      Text(location),
                    ],
                  ),

                  SizedBox(height: 15),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MapScreen(location: location),
                        ),
                      );
                    },
                    icon: Icon(Icons.map),
                    label: Text("View on Map"),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "About Event",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(description),

                  SizedBox(height: 20),

                  Text(
                    "Contact",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("📞 $phone"),
                  Text("📧 $email"),

                  SizedBox(height: 25),

                  Text(
                    "Register Now",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                  SizedBox(height: 10),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {

                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please fill all fields")),
                          );
                          return;
                        }

                        // 🔥 SAVE REGISTRATION
                        await FirebaseFirestore.instance
                            .collection('registrations')
                            .add({
                          'eventTitle': title,
                          'name': nameController.text.trim(),
                          'phone': phoneController.text.trim(),
                          'email': emailController.text.trim(),
                          'timestamp': Timestamp.now(),
                        });

                        // 🔔 ADD NOTIFICATION (NEW)
                        await FirebaseFirestore.instance
                            .collection('notifications')
                            .add({
                          "title": "Registration Successful ✅",
                          "message": "You registered for $title",
                          "type": "registration",
                          "eventTitle": title,
                          "timestamp": Timestamp.now(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("🎉 Registered Successfully!"),
                          ),
                        );

                        nameController.clear();
                        phoneController.clear();
                        emailController.clear();
                      },
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