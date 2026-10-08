import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 1 Easy Q2:
// Create a text file and write the string "Hello Flutter" into it using writeAsString().

void main() {
  runApp(const L1Q2WriteFileApp());
}

class L1Q2WriteFileApp extends StatelessWidget {
  const L1Q2WriteFileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q2 - Write String to File',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const WriteFileScreen(),
    );
  }
}

class WriteFileScreen extends StatefulWidget {
  const WriteFileScreen({super.key});

  @override
  State<WriteFileScreen> createState() => _WriteFileScreenState();
}

class _WriteFileScreenState extends State<WriteFileScreen> {
  String _status = 'File not created yet';

  Future<void> _writeHelloFlutter() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/hello.txt');
      await file.writeAsString('Hello Flutter');

      setState(() {
        _status = 'Successfully wrote "Hello Flutter" to:\n${file.path}';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to write file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q2: Write File')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_document, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Write "Hello Flutter" to File'),
                onPressed: _writeHelloFlutter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
