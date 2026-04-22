import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {

  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final type = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final location = TextEditingController();
  final description = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final imageUrl = TextEditingController();
  final lat = TextEditingController();
  final lng = TextEditingController();

  bool loading = false;

  Future<void> addEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    // 🔥 ADD EVENT
    await FirebaseFirestore.instance.collection('events').add({
      "title": title.text,
      "type": type.text,
      "date": date.text,
      "time": time.text,
      "location": location.text,
      "description": description.text,
      "contactPhone": phone.text,
      "contactEmail": email.text,
      "imageUrl": imageUrl.text,
      "latitude": double.parse(lat.text),
      "longitude": double.parse(lng.text),
      "createdAt": Timestamp.now(),
    });

    // 🔔 ADD NOTIFICATION (NEW)
    await FirebaseFirestore.instance.collection('notifications').add({
      "title": "New Event Added 🎉",
      "message": "${title.text} is now live!",
      "type": "event",
      "eventTitle": title.text,
      "timestamp": Timestamp.now(),
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Event Added Successfully")),
    );

    Navigator.pop(context);
  }

  Widget input(label, controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              input("Title", title),
              input("Type", type),
              input("Date", date),
              input("Time", time),
              input("Location", location),
              input("Description", description),
              input("Contact Phone", phone),
              input("Contact Email", email),
              input("Image URL", imageUrl),
              input("Latitude", lat),
              input("Longitude", lng),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : addEvent,
                child: loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Add Event"),
              )
            ],
          ),
        ),
      ),
    );
  }
}