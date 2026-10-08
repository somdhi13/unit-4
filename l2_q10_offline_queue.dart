import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Level 2 Moderate Q10:
// Create a simple offline queue that saves unsent form data locally using SharedPreferences whenever there is no internet.

void main() {
  runApp(const L2Q10OfflineQueueApp());
}

class L2Q10OfflineQueueApp extends StatelessWidget {
  const L2Q10OfflineQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q10 - Offline Queue',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const OfflineQueueScreen(),
    );
  }
}

class OfflineQueueScreen extends StatefulWidget {
  const OfflineQueueScreen({super.key});

  @override
  State<OfflineQueueScreen> createState() => _OfflineQueueScreenState();
}

class _OfflineQueueScreenState extends State<OfflineQueueScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isOnline = false;
  List<String> _queuedItems = [];

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _queuedItems = prefs.getStringList('offline_queue_key') ?? [];
    });
  }

  Future<void> _submitForm() async {
    final text = _feedbackController.text.trim();
    if (text.isEmpty) return;

    if (_isOnline) {
      // Direct send to server
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sent immediately to server: "$text"'), backgroundColor: Colors.green),
        );
      }
    } else {
      // Save locally to offline queue in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      _queuedItems.add(jsonEncode({'text': text, 'timestamp': DateTime.now().toIso8601String()}));
      await prefs.setStringList('offline_queue_key', _queuedItems);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline! Form saved to offline queue in Preferences.'), backgroundColor: Colors.orange),
        );
      }
    }

    _feedbackController.clear();
    _loadQueue();
  }

  Future<void> _syncQueue() async {
    if (!_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot sync: Still OFFLINE!')),
      );
      return;
    }

    if (_queuedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Queue is empty. Nothing to sync.')),
      );
      return;
    }

    // Sync all
    final prefs = await SharedPreferences.getInstance();
    final count = _queuedItems.length;
    await prefs.remove('offline_queue_key');
    setState(() {
      _queuedItems.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully synced $count offline forms to server!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q10: Offline Form Queue')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Network Mode: ${_isOnline ? "ONLINE" : "OFFLINE"}', style: TextStyle(fontWeight: FontWeight.bold, color: _isOnline ? Colors.green : Colors.red)),
                Switch(
                  value: _isOnline,
                  onChanged: (val) => setState(() => _isOnline = val),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Enter feedback/form data',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit Form'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Queue'),
                  onPressed: _syncQueue,
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text('Queued Offline Submissions: ${_queuedItems.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _queuedItems.length,
                itemBuilder: (context, index) {
                  final data = jsonDecode(_queuedItems[index]);
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.offline_pin, color: Colors.orange),
                      title: Text(data['text']),
                      subtitle: Text('Saved at: ${data['timestamp']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
