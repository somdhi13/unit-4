import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Level 2 Moderate Q3:
// Save a list of Strings to SharedPreferences and display them in a ListView when the app restarts.

void main() {
  runApp(const L2Q3PrefListApp());
}

class L2Q3PrefListApp extends StatelessWidget {
  const L2Q3PrefListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q3 - String List in Preferences',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const PrefListScreen(),
    );
  }
}

class PrefListScreen extends StatefulWidget {
  const PrefListScreen({super.key});

  @override
  State<PrefListScreen> createState() => _PrefListScreenState();
}

class _PrefListScreenState extends State<PrefListScreen> {
  final TextEditingController _itemController = TextEditingController();
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = prefs.getStringList('saved_items_list') ?? ['Item 1', 'Item 2'];
    });
  }

  Future<void> _addItem() async {
    final text = _itemController.text.trim();
    if (text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _items.add(text);
      await prefs.setStringList('saved_items_list', _items);
      _itemController.clear();
      setState(() {});
    }
  }

  Future<void> _clearList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_items_list');
    setState(() {
      _items = [];
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L2Q3: Save List<String> to Preferences'),
        actions: [
          IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _clearList),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Add Item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('List is empty'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(_items[index]),
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
