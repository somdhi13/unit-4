import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Level 3 Hard Q8:
// Build a file-based logging system that appends timestamped log entries to a file and allows the user to export or share the log file.

void main() {
  runApp(const L3Q8FileLoggerApp());
}

class L3Q8FileLoggerApp extends StatelessWidget {
  const L3Q8FileLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q8 - File Logger System',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const FileLoggerScreen(),
    );
  }
}

class FileLoggerScreen extends StatefulWidget {
  const FileLoggerScreen({super.key});

  @override
  State<FileLoggerScreen> createState() => _FileLoggerScreenState();
}

class _FileLoggerScreenState extends State<FileLoggerScreen> {
  final TextEditingController _msgController = TextEditingController();
  String _logs = '';

  @override
  void initState() {
    super.initState();
    _readLogs();
  }

  Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/app_system_logs.log');
  }

  Future<void> _addLogEntry() async {
    final msg = _msgController.text.trim();
    if (msg.isNotEmpty) {
      final file = await _getLogFile();
      final timestamp = DateTime.now().toIso8601String();
      final entry = '[$timestamp] INFO: $msg\n';
      await file.writeAsString(entry, mode: FileMode.append);
      _msgController.clear();
      _readLogs();
    }
  }

  Future<void> _readLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      setState(() {
        _logs = content;
      });
    }
  }

  Future<void> _shareLogFile() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Exported App Logs');
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3Q8: File Logging & Export'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareLogFile),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(labelText: 'Log Message', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _addLogEntry, child: const Text('Add Log')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Timestamped System Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Export / Share Log File'),
                  onPressed: _shareLogFile,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                color: Colors.black,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Text(_logs, style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace')),
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
