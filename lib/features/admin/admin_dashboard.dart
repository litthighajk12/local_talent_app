import 'package:flutter/material.dart';
import 'add_event_screen.dart';
import 'view_events_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Admin"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            card(context, "Create Event", Icons.add, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEventScreen()),
              );
            }),
            card(context, "Manage Events", Icons.event, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ViewEventsScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget card(context, title, icon, onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}