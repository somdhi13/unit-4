import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Level 2 Moderate Q4:
// Build a cache-first data loader that checks a memory cache before calling a network API using the http package.

void main() {
  runApp(const L2Q4CacheFirstApp());
}

class L2Q4CacheFirstApp extends StatelessWidget {
  const L2Q4CacheFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q4 - Cache First Loader',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const CacheFirstScreen(),
    );
  }
}

class CacheFirstScreen extends StatefulWidget {
  const CacheFirstScreen({super.key});

  @override
  State<CacheFirstScreen> createState() => _CacheFirstScreenState();
}

class _CacheFirstScreenState extends State<CacheFirstScreen> {
  // In-memory cache
  final Map<String, String> _memoryCache = {};
  String _titleData = 'No post loaded';
  String _status = '';

  Future<void> _getPostData(int id) async {
    final cacheKey = 'post_$id';

    // 1. Check memory cache first
    if (_memoryCache.containsKey(cacheKey)) {
      setState(() {
        _titleData = _memoryCache[cacheKey]!;
        _status = 'CACHE HIT: Served instantly from memory cache!';
      });
      return;
    }

    // 2. Fallback to Network API
    setState(() {
      _status = 'CACHE MISS: Fetching post from JSONPlaceholder API...';
    });

    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final title = data['title'] as String;

        // Save to cache
        _memoryCache[cacheKey] = title;

        setState(() {
          _titleData = title;
          _status = 'NETWORK SUCCESS: Fetched from API and saved to Cache';
        });
      } else {
        setState(() {
          _status = 'API Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Network Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q4: Cache-First Data Loader')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _getPostData(1),
                  child: const Text('Load Post #1'),
                ),
                ElevatedButton(
                  onPressed: () => _getPostData(2),
                  child: const Text('Load Post #2'),
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
                    Text(_titleData, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(_status, style: const TextStyle(color: Colors.indigo, fontStyle: FontStyle.italic)),
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
