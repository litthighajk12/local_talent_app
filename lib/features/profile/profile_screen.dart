import 'package:flutter/material.dart';
import '../../services/registration_service.dart';
import '../../services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var events = RegistrationService.getRegisteredEvents();
    var user = UserService.getUser();

    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),

      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.pink.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          children: [

            // 👤 USER DETAILS CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.person, size: 35),
                    ),

                    SizedBox(height: 10),

                    Text(
                      user["name"] ?? "No Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(user["email"] ?? ""),

                    SizedBox(height: 5),

                    Text(user["phone"] ?? ""),

                    SizedBox(height: 10),

                    Text(
                      "Talents: ${user["talents"]?.join(", ") ?? "None"}",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 📌 TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Registered Events",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            // 📋 EVENTS LIST
            Expanded(
              child: events.isEmpty
                  ? Center(child: Text("No registrations yet"))
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        var event = events[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: Icon(Icons.event),
                            title: Text(event["title"]),
                            subtitle: Text(event["date"]),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}