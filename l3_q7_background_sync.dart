import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Level 3 Hard Q7:
// Implement a background sync mechanism that automatically pushes all offline-saved records to a server once connectivity_plus reports the device is back online.

void main() {
  runApp(const L3Q7BackgroundSyncApp());
}

class L3Q7BackgroundSyncApp extends StatelessWidget {
  const L3Q7BackgroundSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q7 - Background Auto Sync',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const BackgroundSyncScreen(),
    );
  }
}

class BackgroundSyncScreen extends StatefulWidget {
  const BackgroundSyncScreen({super.key});

  @override
  State<BackgroundSyncScreen> createState() => _BackgroundSyncScreenState();
}

class _BackgroundSyncScreenState extends State<BackgroundSyncScreen> {
  static const String _syncKey = 'pending_sync_records';
  bool _isOnline = true;
  List<String> _pendingRecords = [];
  String _logStatus = '';

  @override
  void initState() {
    super.initState();
    _loadPendingRecords();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
      final bool online = !results.contains(ConnectivityResult.none);
      setState(() {
        _isOnline = online;
      });

      if (online) {
        _performAutoSync();
      }
    });
  }

  Future<void> _loadPendingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pendingRecords = prefs.getStringList(_syncKey) ?? [];
    });
  }

  Future<void> _saveRecordOffline() async {
    final prefs = await SharedPreferences.getInstance();
    final newRecord = jsonEncode({
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': 'Offline Record #${_pendingRecords.length + 1}',
    });

    _pendingRecords.add(newRecord);
    await prefs.setStringList(_syncKey, _pendingRecords);
    setState(() {
      _logStatus = 'Record saved locally. Will auto-sync when online.';
    });

    if (_isOnline) {
      _performAutoSync();
    }
  }

  Future<void> _performAutoSync() async {
    if (_pendingRecords.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final count = _pendingRecords.length;

    // Simulate pushing to server
    await Future.delayed(const Duration(seconds: 1));
    await prefs.remove(_syncKey);

    setState(() {
      _pendingRecords.clear();
      _logStatus = 'AUTO-SYNC COMPLETE: $count records automatically pushed to server!';
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auto-synced $count records to server!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3Q7: Auto Sync on Connectivity'),
        actions: [
          Icon(_isOnline ? Icons.wifi : Icons.wifi_off, color: _isOnline ? Colors.greenAccent : Colors.redAccent),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Connectivity: ${_isOnline ? "ONLINE" : "OFFLINE"}', style: TextStyle(fontWeight: FontWeight.bold, color: _isOnline ? Colors.green : Colors.red)),
                Switch(value: _isOnline, onChanged: (v) => setState(() => _isOnline = v)),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Record (Auto-Syncs when Online)'),
              onPressed: _saveRecordOffline,
            ),
            const SizedBox(height: 20),
            Text(_logStatus, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 20),
            Text('Pending Offline Records in Preferences: ${_pendingRecords.length}'),
            Expanded(
              child: ListView.builder(
                itemCount: _pendingRecords.length,
                itemBuilder: (context, index) {
                  final rec = jsonDecode(_pendingRecords[index]);
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.sync_problem, color: Colors.orange),
                      title: Text(rec['title']),
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
