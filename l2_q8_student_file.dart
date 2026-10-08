import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 2 Moderate Q8:
// Build a small app that stores a list of Student objects as JSON in a file and reads them back into a usable list.

void main() {
  runApp(const L2Q8StudentFileApp());
}

class Student {
  final String name;
  final int rollNo;

  Student({required this.name, required this.rollNo});

  Map<String, dynamic> toJson() => {'name': name, 'rollNo': rollNo};

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(name: json['name'] as String, rollNo: json['rollNo'] as int);
  }
}

class L2Q8StudentFileApp extends StatelessWidget {
  const L2Q8StudentFileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q8 - Student JSON File Storage',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const StudentFileScreen(),
    );
  }
}

class StudentFileScreen extends StatefulWidget {
  const StudentFileScreen({super.key});

  @override
  State<StudentFileScreen> createState() => _StudentFileScreenState();
}

class _StudentFileScreenState extends State<StudentFileScreen> {
  final List<Student> _students = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudentsFromFile();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/students.json');
  }

  Future<void> _saveStudentsToFile() async {
    final file = await _getFile();
    final jsonList = _students.map((s) => s.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await file.writeAsString(jsonString);
  }

  Future<void> _loadStudentsFromFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final List<dynamic> decodedList = jsonDecode(content);
          setState(() {
            _students.clear();
            _students.addAll(decodedList.map((e) => Student.fromJson(e as Map<String, dynamic>)));
          });
        }
      }
    } catch (e) {
      debugPrint('Error reading students file: $e');
    }
  }

  void _addStudent() {
    final name = _nameController.text.trim();
    final roll = int.tryParse(_rollController.text.trim());
    if (name.isNotEmpty && roll != null) {
      setState(() {
        _students.add(Student(name: name, rollNo: roll));
      });
      _saveStudentsToFile();
      _nameController.clear();
      _rollController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q8: Student List JSON in File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _rollController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Roll Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addStudent,
              child: const Text('Add & Save to File'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _students.isEmpty
                  ? const Center(child: Text('No students saved in file.'))
                  : ListView.builder(
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final s = _students[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${s.rollNo}')),
                            title: Text(s.name),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
