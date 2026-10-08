import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 2 Moderate Q1:
// Build a simple Notes app where a note typed by the user is saved to, and loaded from, a local file.

void main() {
  runApp(const L2Q1NotesFileApp());
}

class L2Q1NotesFileApp extends StatelessWidget {
  const L2Q1NotesFileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q1 - File Notes App',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const FileNotesScreen(),
    );
  }
}

class FileNotesScreen extends StatefulWidget {
  const FileNotesScreen({super.key});

  @override
  State<FileNotesScreen> createState() => _FileNotesScreenState();
}

class _FileNotesScreenState extends State<FileNotesScreen> {
  final TextEditingController _noteController = TextEditingController();
  String _savedNoteText = 'No saved note loaded yet.';

  @override
  void initState() {
    super.initState();
    _loadNoteFromFile();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/my_note.txt');
  }

  Future<void> _saveNoteToFile() async {
    final text = _noteController.text;
    final file = await _getFile();
    await file.writeAsString(text);
    setState(() {
      _savedNoteText = text;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved to local file successfully!')),
      );
    }
  }

  Future<void> _loadNoteFromFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          _savedNoteText = content;
          _noteController.text = content;
        });
      }
    } catch (e) {
      debugPrint('Error loading note: $e');
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q1: Local File Notes App')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Type your note here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Note'),
                  onPressed: _saveNoteToFile,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload Note'),
                  onPressed: _loadNoteFromFile,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Saved Note Content in File:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Text(_savedNoteText, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
