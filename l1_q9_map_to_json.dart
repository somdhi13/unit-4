import 'dart:convert';
import 'package:flutter/material.dart';

// Level 1 Easy Q9:
// Convert a simple Dart Map into a JSON string using jsonEncode().

void main() {
  runApp(const L1Q9MapToJsonApp());
}

class L1Q9MapToJsonApp extends StatelessWidget {
  const L1Q9MapToJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q9 - Map to JSON String',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MapToJsonScreen(),
    );
  }
}

class MapToJsonScreen extends StatefulWidget {
  const MapToJsonScreen({super.key});

  @override
  State<MapToJsonScreen> createState() => _MapToJsonScreenState();
}

class _MapToJsonScreenState extends State<MapToJsonScreen> {
  final Map<String, dynamic> _userMap = {
    'id': 101,
    'name': 'Rahul Sharma',
    'email': 'rahul@example.com',
    'isStudent': true,
    'skills': ['Flutter', 'Dart', 'Firebase'],
  };

  String _jsonString = 'Click button to encode Map into JSON string';

  void _convertToJson() {
    final encoded = jsonEncode(_userMap);
    setState(() {
      _jsonString = encoded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q9: jsonEncode() Map to String')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Original Dart Map:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_userMap.toString()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertToJson,
              child: const Text('Convert using jsonEncode()'),
            ),
            const SizedBox(height: 20),
            const Text('Encoded JSON String:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
              _jsonString,
              style: const TextStyle(fontSize: 16, color: Colors.teal, fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }
}
