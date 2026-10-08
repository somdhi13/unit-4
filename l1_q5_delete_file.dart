import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 1 Easy Q5:
// Delete a file using file.delete() and show a confirmation message to the user.

void main() {
  runApp(const L1Q5DeleteFileApp());
}

class L1Q5DeleteFileApp extends StatelessWidget {
  const L1Q5DeleteFileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q5 - Delete File',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const DeleteFileScreen(),
    );
  }
}

class DeleteFileScreen extends StatefulWidget {
  const DeleteFileScreen({super.key});

  @override
  State<DeleteFileScreen> createState() => _DeleteFileScreenState();
}

class _DeleteFileScreenState extends State<DeleteFileScreen> {
  String _info = 'Create a file then delete it.';

  Future<void> _createFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/temp_file.txt');
    await file.writeAsString('This file will be deleted.');
    setState(() {
      _info = 'File temp_file.txt created!';
    });
  }

  Future<void> _deleteFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/temp_file.txt');

    if (await file.exists()) {
      await file.delete();
      setState(() {
        _info = 'File temp_file.txt has been deleted!';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted successfully!'), backgroundColor: Colors.red),
        );
      }
    } else {
      setState(() {
        _info = 'Cannot delete: File does not exist!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q5: Delete File')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_info, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Create File'),
                onPressed: _createFile,
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.delete),
                label: const Text('Delete File using file.delete()'),
                onPressed: _deleteFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
