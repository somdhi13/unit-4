import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 1 Easy Q3:
// Read the contents of an existing file using readAsString() and display it in a Text widget.

void main() {
  runApp(const L1Q3ReadFileApp());
}

class L1Q3ReadFileApp extends StatelessWidget {
  const L1Q3ReadFileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q3 - Read File Contents',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const ReadFileScreen(),
    );
  }
}

class ReadFileScreen extends StatefulWidget {
  const ReadFileScreen({super.key});

  @override
  State<ReadFileScreen> createState() => _ReadFileScreenState();
}

class _ReadFileScreenState extends State<ReadFileScreen> {
  String _fileContent = 'Click Read button to load content';

  Future<void> _readFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/sample_note.txt');

      if (!await file.exists()) {
        await file.writeAsString('Default Sample File Content - Read Success!');
      }

      final content = await file.readAsString();
      setState(() {
        _fileContent = content;
      });
    } catch (e) {
      setState(() {
        _fileContent = 'Error reading file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q3: Read File Contents')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'File Contents:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _fileContent,
                  style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_open),
              label: const Text('Read File using readAsString()'),
              onPressed: _readFile,
            ),
          ],
        ),
      ),
    );
  }
}
