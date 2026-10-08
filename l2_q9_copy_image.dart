import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 2 Moderate Q9:
// Use path_provider to copy an image file picked from gallery/source into the app's own documents directory.

void main() {
  runApp(const L2Q9CopyImageApp());
}

class L2Q9CopyImageApp extends StatelessWidget {
  const L2Q9CopyImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q9 - Copy File to Documents Dir',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const CopyImageScreen(),
    );
  }
}

class CopyImageScreen extends StatefulWidget {
  const CopyImageScreen({super.key});

  @override
  State<CopyImageScreen> createState() => _CopyImageScreenState();
}

class _CopyImageScreenState extends State<CopyImageScreen> {
  String _statusText = 'No image copied yet';

  Future<void> _simulateCopyFile() async {
    try {
      // 1. Get app's documents directory via path_provider
      final Directory docDir = await getApplicationDocumentsDirectory();

      // 2. Create a dummy source file simulating a picked gallery image
      final Directory tempDir = await getTemporaryDirectory();
      final File sourceFile = File('${tempDir.path}/picked_photo.txt');
      await sourceFile.writeAsString('Simulated Image File Data');

      // 3. Copy source file into documents directory
      final String targetPath = '${docDir.path}/app_saved_image.png';
      final File copiedFile = await sourceFile.copy(targetPath);

      setState(() {
        _statusText = 'File copied successfully!\nSource: ${sourceFile.path}\nDestination: ${copiedFile.path}';
      });
    } catch (e) {
      setState(() {
        _statusText = 'Error copying file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q9: Copy File to Documents Dir')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_copy, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              SelectableText(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Simulate Copying Image File'),
                onPressed: _simulateCopyFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
