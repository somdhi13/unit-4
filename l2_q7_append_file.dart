import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 2 Moderate Q7:
// Write a function that appends new text to an existing file instead of overwriting its previous content.

void main() {
  runApp(const L2Q7AppendFileApp());
}

class L2Q7AppendFileApp extends StatelessWidget {
  const L2Q7AppendFileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q7 - Append Text to File',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AppendFileScreen(),
    );
  }
}

class AppendFileScreen extends StatefulWidget {
  const AppendFileScreen({super.key});

  @override
  State<AppendFileScreen> createState() => _AppendFileScreenState();
}

class _AppendFileScreenState extends State<AppendFileScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fileContents = 'File is empty';

  Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/app_log.txt');
  }

  Future<void> _appendText() async {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      final file = await _getLogFile();
      // FileMode.append ensures content is appended rather than overwritten
      await file.writeAsString('$text\n', mode: FileMode.append);
      _inputController.clear();
      _readFile();
    }
  }

  Future<void> _readFile() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      setState(() {
        _fileContents = content;
      });
    }
  }

  Future<void> _clearFile() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      await file.writeAsString('');
      _readFile();
    }
  }

  @override
  void initState() {
    super.initState();
    _readFile();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L2Q7: Append Text to File'),
        actions: [
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: _clearFile),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Enter line to append',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.playlist_add),
              label: const Text('Append Line (FileMode.append)'),
              onPressed: _appendText,
            ),
            const SizedBox(height: 25),
            const Text('Entire File Contents:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Text(_fileContents, style: const TextStyle(fontFamily: 'monospace')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
