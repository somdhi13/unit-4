import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Level 1 Easy Q6:
// Store a String value using SharedPreferences and retrieve it correctly after restarting the app.

void main() {
  runApp(const L1Q6PrefStringApp());
}

class L1Q6PrefStringApp extends StatelessWidget {
  const L1Q6PrefStringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q6 - SharedPreferences String',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PrefStringScreen(),
    );
  }
}

class PrefStringScreen extends StatefulWidget {
  const PrefStringScreen({super.key});

  @override
  State<PrefStringScreen> createState() => _PrefStringScreenState();
}

class _PrefStringScreenState extends State<PrefStringScreen> {
  final TextEditingController _controller = TextEditingController();
  String _savedName = 'No name saved yet';

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

  Future<void> _loadSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('user_name') ?? 'No name saved yet';
    });
  }

  Future<void> _saveName() async {
    if (_controller.text.trim().isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _controller.text.trim());
      _loadSavedName();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name saved to SharedPreferences!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q6: SharedPreferences String')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Saved Name: $_savedName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Name to Save',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveName,
              child: const Text('Save String'),
            ),
          ],
        ),
      ),
    );
  }
}
