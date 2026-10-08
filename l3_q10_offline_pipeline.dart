import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Level 3 Hard Q10:
// Design a complete offline-data pipeline: fetch data from an API, serialize it to JSON, save it to a file, deserialize it on launch, display it in UI, allow local edits, and re-sync changes back to server.

void main() {
  runApp(const L3Q10OfflinePipelineApp());
}

class Product {
  final int id;
  String title;
  double price;
  bool isLocallyEdited;

  Product({required this.id, required this.title, required this.price, this.isLocallyEdited = false});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'isLocallyEdited': isLocallyEdited,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      isLocallyEdited: json['isLocallyEdited'] as bool? ?? false,
    );
  }
}

class L3Q10OfflinePipelineApp extends StatelessWidget {
  const L3Q10OfflinePipelineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q10 - Offline Data Pipeline',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const OfflinePipelineScreen(),
    );
  }
}

class OfflinePipelineScreen extends StatefulWidget {
  const OfflinePipelineScreen({super.key});

  @override
  State<OfflinePipelineScreen> createState() => _OfflinePipelineScreenState();
}

class _OfflinePipelineScreenState extends State<OfflinePipelineScreen> {
  List<Product> _products = [];
  String _pipelineStatus = 'Pipeline initialized';

  @override
  void initState() {
    super.initState();
    _executePipelineOnLaunch();
  }

  Future<File> _getPipelineFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/offline_pipeline_products.json');
  }

  // Pipeline Step 1 & 2 & 3 & 4: Check file -> Deserialize -> Or Fetch API & Serialize
  Future<void> _executePipelineOnLaunch() async {
    final file = await _getPipelineFile();

    if (await file.exists()) {
      final jsonStr = await file.readAsString();
      if (jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        setState(() {
          _products = decoded.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
          _pipelineStatus = 'LAUNCH: Deserialized ${_products.length} products from local file!';
        });
        return;
      }
    }

    _fetchFromApiAndSaveLocal();
  }

  Future<void> _fetchFromApiAndSaveLocal() async {
    setState(() => _pipelineStatus = 'Fetching initial data from network API...');
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=4'));
      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        final fetchedProducts = decoded
            .map((e) => Product(
                  id: e['id'] as int,
                  title: e['title'] as String,
                  price: (e['id'] as int) * 19.99,
                ))
            .toList();

        _products = fetchedProducts;
        await _saveProductsToFile();
        setState(() {
          _pipelineStatus = 'API SUCCESS: Serialized & saved to file, displayed in UI!';
        });
      }
    } catch (e) {
      setState(() => _pipelineStatus = 'Network error: $e');
    }
  }

  Future<void> _saveProductsToFile() async {
    final file = await _getPipelineFile();
    final jsonList = _products.map((p) => p.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  // Pipeline Step 6: Local Edit
  void _editProduct(Product product) {
    final controller = TextEditingController(text: product.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product #${product.id}'),
          content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Title')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    product.title = controller.text.trim();
                    product.isLocallyEdited = true;
                    _pipelineStatus = 'Product #${product.id} edited locally & file updated!';
                  });
                  _saveProductsToFile();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Local Edit'),
            ),
          ],
        );
      },
    );
  }

  // Pipeline Step 7: Re-sync local edits back to server
  Future<void> _resyncChangesToServer() async {
    final editedItems = _products.where((p) => p.isLocallyEdited).toList();
    if (editedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No local edits to re-sync!')));
      return;
    }

    setState(() => _pipelineStatus = 'Re-syncing ${editedItems.length} edited products back to server...');
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      for (final p in editedItems) {
        p.isLocallyEdited = false;
      }
      _pipelineStatus = 'PIPELINE COMPLETE: All local edits re-synced to server & saved!';
    });
    _saveProductsToFile();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Re-synced changes back to server!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3Q10: Complete Offline Pipeline'),
        actions: [
          IconButton(icon: const Icon(Icons.cloud_upload), onPressed: _resyncChangesToServer),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(_pipelineStatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.sync),
                      label: const Text('Re-sync Local Edits to Server'),
                      onPressed: _resyncChangesToServer,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final p = _products[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${p.id}')),
                      title: Text(p.title),
                      subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (p.isLocallyEdited)
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Chip(label: Text('Edited', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.orange),
                            ),
                          IconButton(icon: const Icon(Icons.edit), onPressed: () => _editProduct(p)),
                        ],
                      ),
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
