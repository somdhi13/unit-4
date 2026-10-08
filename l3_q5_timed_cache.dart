import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Level 3 Hard Q5:
// Create a caching system with expiry: store data together with a timestamp, and automatically re-fetch from the network if more than 5 minutes have passed.

void main() {
  runApp(const L3Q5TimedCacheApp());
}

class L3Q5TimedCacheApp extends StatelessWidget {
  const L3Q5TimedCacheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q5 - Timed Cache Expiry',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TimedCacheScreen(),
    );
  }
}

class TimedCacheScreen extends StatefulWidget {
  const TimedCacheScreen({super.key});

  @override
  State<TimedCacheScreen> createState() => _TimedCacheScreenState();
}

class _TimedCacheScreenState extends State<TimedCacheScreen> {
  static const String _dataKey = 'timed_cache_data';
  static const String _timeKey = 'timed_cache_timestamp';
  static const int _expirySeconds = 300; // 5 minutes (300 seconds)

  String _content = 'No data loaded';
  String _cacheStatus = '';

  Future<void> _fetchDataWithExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_dataKey);
    final lastTimeMs = prefs.getInt(_timeKey);

    final nowMs = DateTime.now().millisecondsSinceEpoch;

    // Check if cache is still valid (less than 5 minutes / 300 seconds old)
    if (cachedData != null && lastTimeMs != null) {
      final differenceSeconds = (nowMs - lastTimeMs) ~/ 1000;
      if (differenceSeconds < _expirySeconds) {
        setState(() {
          _content = cachedData;
          _cacheStatus = 'VALID CACHE: Saved $differenceSeconds seconds ago (< 5 mins). Serving from local cache.';
        });
        return;
      }
    }

    // Cache expired or missing -> fetch fresh
    setState(() {
      _cacheStatus = 'CACHE EXPIRED/MISSING: Fetching fresh data from network...';
    });

    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if (response.statusCode == 200) {
        final title = jsonDecode(response.body)['title'] as String;

        await prefs.setString(_dataKey, title);
        await prefs.setInt(_timeKey, nowMs);

        setState(() {
          _content = title;
          _cacheStatus = 'FRESH NETWORK FETCH: Updated cache and timestamp!';
        });
      }
    } catch (e) {
      setState(() {
        _cacheStatus = 'Network Error: $e';
      });
    }
  }

  Future<void> _forceExpireCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_timeKey);
    setState(() {
      _cacheStatus = 'Cache timestamp removed! Next fetch will be expired.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3Q5: Timed Expiry Cache (5 Mins)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _fetchDataWithExpiry, child: const Text('Fetch Data (Check 5-Min Expiry)')),
            const SizedBox(height: 10),
            OutlinedButton(onPressed: _forceExpireCache, child: const Text('Force Expire Cache')),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(_content, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(_cacheStatus, style: const TextStyle(color: Colors.indigo)),
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
