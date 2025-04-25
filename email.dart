import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Sender'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.deepPurpleAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            // Navigate to the EmailForm page when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmailForm()),
            );
          },
          child: const Text('Compose New Email'),
        ),
      ),
    );
  }
}

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
    final uri = Uri.parse('http://localhost:5000/send'); // Use 10.0.2.2 for Android emulator
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
        const SnackBar(content: Text('✅ Email sent successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to send email: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Email'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _recipientController,
                decoration: InputDecoration(
                  labelText: 'To',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: const Icon(Icons.subject),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Body',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.message_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 8,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _sendEmail,
                icon: const Icon(Icons.send),
                label: const Text('Send Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
