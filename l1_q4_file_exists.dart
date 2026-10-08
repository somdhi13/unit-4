import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 1 Easy Q4:
// Check whether a file exists using exists() before attempting to read from it.

void main() {
  runApp(const L1Q4FileExistsApp());
}

class L1Q4FileExistsApp extends StatelessWidget {
  const L1Q4FileExistsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q4 - Check File Exists',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const CheckFileExistsScreen(),
    );
  }
}

class CheckFileExistsScreen extends StatefulWidget {
  const CheckFileExistsScreen({super.key});

  @override
  State<CheckFileExistsScreen> createState() => _CheckFileExistsScreenState();
}

class _CheckFileExistsScreenState extends State<CheckFileExistsScreen> {
  String _statusMessage = 'Check if test_data.txt exists';

  Future<void> _checkAndReadFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/test_data.txt');

    final bool isExisting = await file.exists();

    if (isExisting) {
      final content = await file.readAsString();
      setState(() {
        _statusMessage = 'File EXISTS! Content:\n"$content"';
      });
    } else {
      setState(() {
        _statusMessage = 'File DOES NOT EXIST at:\n${file.path}';
      });
    }
  }

  Future<void> _createDummyFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/test_data.txt');
    await file.writeAsString('Dummy Data inside test_data.txt');
    setState(() {
      _statusMessage = 'Created test_data.txt file successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q4: Check file.exists()')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _checkAndReadFile,
              child: const Text('Check Exists & Read'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _createDummyFile,
              child: const Text('Create File first'),
            ),
          ],
        ),
      ),
    );
  }
}
