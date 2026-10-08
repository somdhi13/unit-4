import 'package:flutter/material.dart';

// Level 2 Moderate Q5:
// Implement a "Clear Cache" button that empties a cache Map and forces the next request to fetch fresh data.

void main() {
  runApp(const L2Q5ClearCacheApp());
}

class L2Q5ClearCacheApp extends StatelessWidget {
  const L2Q5ClearCacheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q5 - Clear Cache Button',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const ClearCacheScreen(),
    );
  }
}

class ClearCacheScreen extends StatefulWidget {
  const ClearCacheScreen({super.key});

  @override
  State<ClearCacheScreen> createState() => _ClearCacheScreenState();
}

class _ClearCacheScreenState extends State<ClearCacheScreen> {
  final Map<String, String> _cacheMap = {};
  String _currentContent = 'No data fetched yet.';
  String _sourceStatus = '';

  Future<void> _fetchData() async {
    const key = 'user_data';
    if (_cacheMap.containsKey(key)) {
      setState(() {
        _currentContent = _cacheMap[key]!;
        _sourceStatus = 'Loaded from CACHE';
      });
    } else {
      setState(() {
        _sourceStatus = 'Fetching fresh data...';
      });
      await Future.delayed(const Duration(seconds: 1));
      final freshData = 'Fresh Data fetched at ${DateTime.now().second}s';
      _cacheMap[key] = freshData;
      setState(() {
        _currentContent = freshData;
        _sourceStatus = 'Fetched FRESH DATA from Server';
      });
    }
  }

  void _clearCache() {
    setState(() {
      _cacheMap.clear();
      _sourceStatus = 'Cache map cleared! Next fetch will hit server.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache Cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q5: Clear Cache Map')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _clearCache,
              child: const Text('Clear Cache'),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(_currentContent, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_sourceStatus, style: const TextStyle(color: Colors.deepOrange)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Cache Map Count: ${_cacheMap.length}'),
          ],
        ),
      ),
    );
  }
}
