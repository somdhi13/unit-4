import 'dart:convert';
import 'package:flutter/material.dart';

// Level 2 Moderate Q2:
// Create a Student class with toJson() and fromJson() methods and test converting an object both ways.

void main() {
  runApp(const L2Q2StudentJsonApp());
}

class Student {
  final String name;
  final int rollNo;
  final double marks;

  Student({required this.name, required this.rollNo, required this.marks});

  // Convert Student object to Map / JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rollNo': rollNo,
      'marks': marks,
    };
  }

  // Factory constructor to create Student from Map / JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] as String,
      rollNo: json['rollNo'] as int,
      marks: (json['marks'] as num).toDouble(),
    );
  }
}

class L2Q2StudentJsonApp extends StatelessWidget {
  const L2Q2StudentJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q2 - Student toJson and fromJson',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const StudentJsonScreen(),
    );
  }
}

class StudentJsonScreen extends StatefulWidget {
  const StudentJsonScreen({super.key});

  @override
  State<StudentJsonScreen> createState() => _StudentJsonScreenState();
}

class _StudentJsonScreenState extends State<StudentJsonScreen> {
  final Student _originalStudent = Student(name: 'Aarav Patel', rollNo: 105, marks: 94.5);
  String _jsonOutput = '';
  Student? _reconstructedStudent;

  void _testSerialization() {
    // 1. Convert Student to JSON string
    final Map<String, dynamic> mapData = _originalStudent.toJson();
    final String jsonStr = jsonEncode(mapData);

    // 2. Decode JSON string back to Student
    final Map<String, dynamic> decodedMap = jsonDecode(jsonStr);
    final Student restoredStudent = Student.fromJson(decodedMap);

    setState(() {
      _jsonOutput = jsonStr;
      _reconstructedStudent = restoredStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q2: Student toJson / fromJson')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Original Object: ${_originalStudent.name}, Roll: ${_originalStudent.rollNo}, Marks: ${_originalStudent.marks}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testSerialization,
              child: const Text('Test Serialization Both Ways'),
            ),
            const SizedBox(height: 20),
            Text('JSON Output (toJson()):\n$_jsonOutput', style: const TextStyle(fontFamily: 'monospace', color: Colors.teal)),
            const SizedBox(height: 20),
            if (_reconstructedStudent != null) ...[
              const Text('Reconstructed Object (fromJson()):', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Name: ${_reconstructedStudent!.name}'),
              Text('Roll No: ${_reconstructedStudent!.rollNo}'),
              Text('Marks: ${_reconstructedStudent!.marks}'),
            ],
          ],
        ),
      ),
    );
  }
}
