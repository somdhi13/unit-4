import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Level 3 Hard Q3:
// Build an offline-first To-Do app where tasks are saved locally with Hive and synced to a mock REST API once connectivity_plus reports online.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('todos_box');
  runApp(const L3Q3HiveTodoApp());
}

class L3Q3HiveTodoApp extends StatelessWidget {
  const L3Q3HiveTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q3 - Hive Offline Todo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HiveTodoScreen(),
    );
  }
}

class HiveTodoScreen extends StatefulWidget {
  const HiveTodoScreen({super.key});

  @override
  State<HiveTodoScreen> createState() => _HiveTodoScreenState();
}

class _HiveTodoScreenState extends State<HiveTodoScreen> {
  late Box _todoBox;
  final TextEditingController _taskController = TextEditingController();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _todoBox = Hive.box('todos_box');
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
      final bool online = !results.contains(ConnectivityResult.none);
      setState(() {
        _isOnline = online;
      });
      if (online) {
        _syncHiveWithMockServer();
      }
    });
  }

  void _addTodo() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      _todoBox.add({'title': text, 'isSynced': _isOnline});
      _taskController.clear();
      setState(() {});
      if (_isOnline) {
        _syncHiveWithMockServer();
      }
    }
  }

  Future<void> _syncHiveWithMockServer() async {
    int syncCount = 0;
    for (int i = 0; i < _todoBox.length; i++) {
      final item = Map<String, dynamic>.from(_todoBox.getAt(i));
      if (item['isSynced'] == false) {
        // Mock REST API POST sync
        item['isSynced'] = true;
        await _todoBox.putAt(i, item);
        syncCount++;
      }
    }
    if (syncCount > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synced $syncCount unsynced Hive todos to mock REST API!')),
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3Q3: Hive Offline-First Todo'),
        actions: [
          IconButton(
            icon: Icon(_isOnline ? Icons.wifi : Icons.wifi_off, color: _isOnline ? Colors.white : Colors.redAccent),
            onPressed: () {},
          ),
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
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _addTodo, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _todoBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('No Tasks in Hive Box'));
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final item = Map<String, dynamic>.from(box.getAt(index));
                      final bool isSynced = item['isSynced'] ?? false;
                      return Card(
                        child: ListTile(
                          title: Text(item['title']),
                          trailing: Icon(
                            isSynced ? Icons.cloud_done : Icons.cloud_upload,
                            color: isSynced ? Colors.green : Colors.orange,
                          ),
                          onLongPress: () {
                            box.deleteAt(index);
                          },
                        ),
                      );
                    },
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
