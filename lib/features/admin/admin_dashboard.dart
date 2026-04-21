import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // This takes the admin back to the login screen
              Navigator.of(context).pop(); 
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Admin!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // STATS CARDS
            Row(
              children: [
                _buildStatCard("Total Events", "12", Colors.blue),
                const SizedBox(width: 10),
                _buildStatCard("Pending", "3", Colors.orange),
              ],
            ),
            
            const SizedBox(height: 30),
            const Text(
              "Management Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Divider(),
            
            // ACTION BUTTONS
            ListTile(
              leading: const Icon(Icons.event, color: Colors.deepPurple),
              title: const Text("Verify New Events"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Future: Navigate to verification screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.deepPurple),
              title: const Text("Manage Users"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Future: Navigate to user management
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Future: Add a direct 'Add Event' shortcut
        },
        label: const Text("Add Official Event"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // Helper widget to keep the code clean
  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}