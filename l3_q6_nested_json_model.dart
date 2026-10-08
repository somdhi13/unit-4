import 'dart:convert';
import 'package:flutter/material.dart';

// Level 3 Hard Q6:
// Build a JSON-based data model containing a nested object (Student with a list of Marks) and implement custom toJson()/fromJson() for the nested structure.

void main() {
  runApp(const L3Q6NestedJsonApp());
}

class Mark {
  final String subject;
  final double score;

  Mark({required this.subject, required this.score});

  Map<String, dynamic> toJson() => {'subject': subject, 'score': score};

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      subject: json['subject'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }
}

class Student {
  final String name;
  final int rollNo;
  final List<Mark> marksList;

  Student({required this.name, required this.rollNo, required this.marksList});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rollNo': rollNo,
      'marksList': marksList.map((m) => m.toJson()).toList(),
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    final rawList = json['marksList'] as List<dynamic>;
    final marks = rawList.map((e) => Mark.fromJson(e as Map<String, dynamic>)).toList();
    return Student(
      name: json['name'] as String,
      rollNo: json['rollNo'] as int,
      marksList: marks,
    );
  }
}

class L3Q6NestedJsonApp extends StatelessWidget {
  const L3Q6NestedJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q6 - Nested JSON Model',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const NestedJsonScreen(),
    );
  }
}

class NestedJsonScreen extends StatefulWidget {
  const NestedJsonScreen({super.key});

  @override
  State<NestedJsonScreen> createState() => _NestedJsonScreenState();
}

class _NestedJsonScreenState extends State<NestedJsonScreen> {
  final Student _originalStudent = Student(
    name: 'Vikram Joshi',
    rollNo: 201,
    marksList: [
      Mark(subject: 'Flutter', score: 95.0),
      Mark(subject: 'Dart', score: 92.5),
      Mark(subject: 'Database', score: 88.0),
    ],
  );

  String _encodedJson = '';
  Student? _parsedStudent;

  void _testNestedJson() {
    // Encode nested structure
    final map = _originalStudent.toJson();
    final jsonStr = jsonEncode(map);

    // Decode nested structure
    final decodedMap = jsonDecode(jsonStr);
    final restoredStudent = Student.fromJson(decodedMap);

    setState(() {
      _encodedJson = jsonStr;
      _parsedStudent = restoredStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3Q6: Nested JSON Object Serialization')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _testNestedJson,
                child: const Text('Test Custom Nested toJson() / fromJson()'),
              ),
              const SizedBox(height: 20),
              const Text('Encoded JSON String:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_encodedJson, style: const TextStyle(fontFamily: 'monospace', color: Colors.teal)),
              const SizedBox(height: 20),
              if (_parsedStudent != null) ...[
                const Text('Restored Student Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Name: ${_parsedStudent!.name} | Roll: ${_parsedStudent!.rollNo}'),
                const SizedBox(height: 10),
                const Text('Nested Marks List:', style: TextStyle(fontWeight: FontWeight.bold)),
                ..._parsedStudent!.marksList.map(
                  (m) => ListTile(
                    dense: true,
                    title: Text(m.subject),
                    trailing: Text('${m.score} Marks'),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
