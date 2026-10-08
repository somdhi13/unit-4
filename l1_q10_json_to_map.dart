import 'dart:convert';
import 'package:flutter/material.dart';

// Level 1 Easy Q10:
// Convert a JSON string back into a Dart Map using jsonDecode() and print its values.

void main() {
  runApp(const L1Q10JsonToMapApp());
}

class L1Q10JsonToMapApp extends StatelessWidget {
  const L1Q10JsonToMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q10 - JSON String to Map',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const JsonToMapScreen(),
    );
  }
}

class JsonToMapScreen extends StatefulWidget {
  const JsonToMapScreen({super.key});

  @override
  State<JsonToMapScreen> createState() => _JsonToMapScreenState();
}

class _JsonToMapScreenState extends State<JsonToMapScreen> {
  final String _rawJsonString = '{"id": 501, "title": "Flutter Developer", "salary": 75000, "active": true}';
  Map<String, dynamic>? _parsedMap;

  void _decodeJson() {
    final Map<String, dynamic> decoded = jsonDecode(_rawJsonString);
    setState(() {
      _parsedMap = decoded;
    });

    debugPrint('ID: ${decoded['id']}');
    debugPrint('Title: ${decoded['title']}');
    debugPrint('Salary: ${decoded['salary']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q10: jsonDecode() String to Map')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Raw JSON String:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_rawJsonString, style: const TextStyle(fontFamily: 'monospace')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _decodeJson,
              child: const Text('Decode using jsonDecode()'),
            ),
            const SizedBox(height: 20),
            if (_parsedMap != null) ...[
              const Text('Parsed Map Key-Values:', style: TextStyle(fontWeight: FontWeight.bold)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _parsedMap!.entries
                        .map((entry) => Text('${entry.key} : ${entry.value}'))
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
