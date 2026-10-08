import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Level 3 Hard Q4:
// Design and implement a generic Repository class that abstracts a local data source (SharedPreferences) and a remote data source (API) for a list of items.

void main() {
  runApp(const L3Q4RepoPatternApp());
}

// Data Model
class Item {
  final int id;
  final String title;

  Item({required this.id, required this.title});

  Map<String, dynamic> toJson() => {'id': id, 'title': title};

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(id: json['id'] as int, title: json['title'] as String);
  }
}

// Generic ItemRepository
class ItemRepository {
  static const String _cacheKey = 'cached_items_repo';

  // Fetch items: try remote, fallback to local storage
  Future<List<Item>> getItems() async {
    try {
      // Remote API call
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=5'));
      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        final List<Item> items = decoded.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
        
        // Save to local source
        await _saveLocal(items);
        return items;
      }
    } catch (e) {
      debugPrint('Remote API failed: $e. Falling back to local data source...');
    }

    // Local fallback
    return await _getLocal();
  }

  Future<void> _saveLocal(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_cacheKey, jsonStr);
  }

  Future<List<Item>> _getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_cacheKey);
    if (jsonStr != null) {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [Item(id: 0, title: 'Fallback Default Item (No local data)')];
  }
}

class L3Q4RepoPatternApp extends StatelessWidget {
  const L3Q4RepoPatternApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q4 - Repository Pattern',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const RepoPatternScreen(),
    );
  }
}

class RepoPatternScreen extends StatefulWidget {
  const RepoPatternScreen({super.key});

  @override
  State<RepoPatternScreen> createState() => _RepoPatternScreenState();
}

class _RepoPatternScreenState extends State<RepoPatternScreen> {
  final ItemRepository _repository = ItemRepository();
  List<Item> _items = [];
  bool _isLoading = false;

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _repository.getItems();
    setState(() {
      _items = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3Q4: Abstract Repository Pattern')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${item.id}')),
                  title: Text(item.title),
                );
              },
            ),
    );
  }
}
