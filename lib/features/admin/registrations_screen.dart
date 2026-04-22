import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationsScreen extends StatelessWidget {
  final String eventTitle;

  const RegistrationsScreen({super.key, required this.eventTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrations"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('registrations')
            .where('eventTitle', isEqualTo: eventTitle)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          if (users.isEmpty) {
            return Center(child: Text("No registrations"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {

              var u = users[index];

              return ListTile(
                title: Text(u['name']),
                subtitle: Text("${u['phone']} | ${u['email']}"),
              );
            },
          );
        },
      ),
    );
  }
}