import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventScreen extends StatefulWidget {
  final DocumentSnapshot doc;

  const EditEventScreen({super.key, required this.doc});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {

  late TextEditingController title;
  late TextEditingController type;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.doc['title']);
    type = TextEditingController(text: widget.doc['type']);
  }

  void update() async {
    await widget.doc.reference.update({
      "title": title.text,
      "type": type.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Event")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: title),
            TextField(controller: type),
            SizedBox(height: 20),
            ElevatedButton(onPressed: update, child: Text("Update"))
          ],
        ),
      ),
    );
  }
}