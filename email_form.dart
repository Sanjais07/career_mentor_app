import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  Future<void> _sendEmail() async {
    final uri = Uri.parse('http://10.0.2.2:3000/send'); // for Android emulator use 10.0.2.2
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'to': _recipientController.text,
        'subject': _subjectController.text,
        'text': _bodyController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compose Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _recipientController,
              decoration: const InputDecoration(labelText: 'To'),
            ),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendEmail,
              child: const Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
