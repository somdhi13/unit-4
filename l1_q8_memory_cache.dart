import 'package:flutter/material.dart';

// Level 1 Easy Q8:
// Create a simple in-memory cache using a Map to store and reuse API response data.

void main() {
  runApp(const L1Q8MemoryCacheApp());
}

class L1Q8MemoryCacheApp extends StatelessWidget {
  const L1Q8MemoryCacheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q8 - In-Memory Cache Map',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MemoryCacheScreen(),
    );
  }
}

class MemoryCacheScreen extends StatefulWidget {
  const MemoryCacheScreen({super.key});

  @override
  State<MemoryCacheScreen> createState() => _MemoryCacheScreenState();
}

class _MemoryCacheScreenState extends State<MemoryCacheScreen> {
  // In-memory cache Map
  final Map<String, String> _apiCache = {};
  String _displayData = 'No data loaded';
  String _sourceInfo = '';

  Future<void> _fetchData(String key) async {
    // Check if key exists in cache
    if (_apiCache.containsKey(key)) {
      setState(() {
        _displayData = _apiCache[key]!;
        _sourceInfo = 'Loaded from IN-MEMORY CACHE MAP (Instant)';
      });
    } else {
      // Simulate API fetch delay
      setState(() {
        _displayData = 'Fetching from Network API...';
        _sourceInfo = 'Network call in progress...';
      });

      await Future.delayed(const Duration(seconds: 2));

      final simulatedResponse = 'Data for $key [Fetched at ${DateTime.now().toIso8601String().substring(11, 19)}]';
      
      // Store in memory cache
      _apiCache[key] = simulatedResponse;

      setState(() {
        _displayData = simulatedResponse;
        _sourceInfo = 'Fetched from NETWORK API & stored in Map Cache';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q8: In-Memory Cache Map')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _fetchData('user_profile'),
                  child: const Text('Fetch User Profile'),
                ),
                ElevatedButton(
                  onPressed: () => _fetchData('products_list'),
                  child: const Text('Fetch Products'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(_displayData, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(_sourceInfo, style: const TextStyle(color: Colors.indigo, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Current Cache Keys: ${_apiCache.keys.join(", ")}'),
          ],
        ),
      ),
    );
  }
}
