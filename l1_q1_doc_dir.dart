import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Level 1 Easy Q1:
// Write a Dart function that prints the path returned by getApplicationDocumentsDirectory().

void main() {
  runApp(const L1Q1DocDirApp());
}

class L1Q1DocDirApp extends StatelessWidget {
  const L1Q1DocDirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q1 - Documents Directory Path',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DocDirScreen(),
    );
  }
}

class DocDirScreen extends StatefulWidget {
  const DocDirScreen({super.key});

  @override
  State<DocDirScreen> createState() => _DocDirScreenState();
}

class _DocDirScreenState extends State<DocDirScreen> {
  String _path = 'Press button to fetch directory path';

  Future<void> _fetchDirectoryPath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      setState(() {
        _path = directory.path;
      });
      debugPrint('Application Documents Directory: ${directory.path}');
    } catch (e) {
      setState(() {
        _path = 'Error fetching directory: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q1: Get Documents Directory')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.folder, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Application Documents Path:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SelectableText(
                _path,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.folder_open),
                label: const Text('Get Path'),
                onPressed: _fetchDirectoryPath,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
