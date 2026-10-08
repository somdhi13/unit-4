import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Level 3 Hard Q9:
// Create an app that downloads a JSON file from a public API, saves a local cached copy, and automatically falls back to that cached copy if the network request fails.

void main() {
  runApp(const L3Q9FallbackCacheApp());
}

class L3Q9FallbackCacheApp extends StatelessWidget {
  const L3Q9FallbackCacheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q9 - API Fallback Cache',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const FallbackCacheScreen(),
    );
  }
}

class FallbackCacheScreen extends StatefulWidget {
  const FallbackCacheScreen({super.key});

  @override
  State<FallbackCacheScreen> createState() => _FallbackCacheScreenState();
}

class _FallbackCacheScreenState extends State<FallbackCacheScreen> {
  String _titleData = 'No data loaded';
  String _statusMessage = '';

  Future<File> _getCacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/api_post_cache.json');
  }

  Future<void> _fetchWithFallback({bool simulateError = false}) async {
    final cacheFile = await _getCacheFile();

    setState(() {
      _statusMessage = 'Attempting Network API fetch...';
    });

    try {
      if (simulateError) {
        throw Exception('Simulated Network Connection Failure!');
      }

      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

      if (response.statusCode == 200) {
        // Save fresh JSON copy to local file cache
        await cacheFile.writeAsString(response.body);

        final decoded = jsonDecode(response.body);
        setState(() {
          _titleData = decoded['title'];
          _statusMessage = 'SUCCESS: Fetched fresh JSON from API & saved local cached copy!';
        });
        return;
      }
    } catch (e) {
      debugPrint('Network failed: $e. Checking local file fallback cache...');
    }

    // Fallback to local cached copy
    if (await cacheFile.exists()) {
      final cachedJsonStr = await cacheFile.readAsString();
      final decoded = jsonDecode(cachedJsonStr);
      setState(() {
        _titleData = decoded['title'];
        _statusMessage = 'FALLBACK SUCCESS: Network failed, but loaded cached copy from local file system!';
      });
    } else {
      setState(() {
        _statusMessage = 'ERROR: Network request failed and no local cache file exists!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3Q9: API Fallback Cache')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _fetchWithFallback(simulateError: false),
              child: const Text('Fetch from API (Normal Network)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              icon: const Icon(Icons.wifi_off),
              label: const Text('Simulate Network Failure (Trigger Fallback Cache)'),
              onPressed: () => _fetchWithFallback(simulateError: true),
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(_titleData, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(_statusMessage, style: const TextStyle(color: Colors.indigo, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
