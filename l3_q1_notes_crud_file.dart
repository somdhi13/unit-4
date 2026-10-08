import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 3 Hard Q1:
// Build a complete Notes app with Create, Read, Update, and Delete operations, storing all notes as a single JSON-encoded list in a file.

void main() {
  runApp(const L3Q1NotesCrudApp());
}

class Note {
  String id;
  String title;
  String content;

  Note({required this.id, required this.title, required this.content});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'content': content};

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}

class L3Q1NotesCrudApp extends StatelessWidget {
  const L3Q1NotesCrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q1 - Full CRUD Notes File',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const NotesCrudScreen(),
    );
  }
}

class NotesCrudScreen extends StatefulWidget {
  const NotesCrudScreen({super.key});

  @override
  State<NotesCrudScreen> createState() => _NotesCrudScreenState();
}

class _NotesCrudScreenState extends State<NotesCrudScreen> {
  final List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotesFromFile();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/all_notes.json');
  }

  Future<void> _saveNotesToFile() async {
    final file = await _getFile();
    final jsonList = _notes.map((n) => n.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> _loadNotesFromFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final List<dynamic> decoded = jsonDecode(content);
          setState(() {
            _notes.clear();
            _notes.addAll(decoded.map((e) => Note.fromJson(e as Map<String, dynamic>)));
          });
        }
      }
    } catch (e) {
      debugPrint('Error reading notes file: $e');
    }
  }

  void _showNoteDialog({Note? existingNote}) {
    final titleController = TextEditingController(text: existingNote?.title ?? '');
    final contentController = TextEditingController(text: existingNote?.content ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingNote == null ? 'Add Note' : 'Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text.trim();
                if (title.isNotEmpty) {
                  setState(() {
                    if (existingNote == null) {
                      _notes.add(Note(id: DateTime.now().toString(), title: title, content: content));
                    } else {
                      existingNote.title = title;
                      existingNote.content = content;
                    }
                  });
                  _saveNotesToFile();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((n) => n.id == id);
    });
    _saveNotesToFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3Q1: JSON File Notes CRUD')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes stored in file. Tap + to add.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _showNoteDialog(existingNote: note)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteNote(note.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
