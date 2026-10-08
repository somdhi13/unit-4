import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Level 1 Easy Q7:
// Store an integer counter using SharedPreferences and increment it every time a button is pressed.

void main() {
  runApp(const L1Q7PrefCounterApp());
}

class L1Q7PrefCounterApp extends StatelessWidget {
  const L1Q7PrefCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L1Q7 - SharedPreferences Counter',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const PrefCounterScreen(),
    );
  }
}

class PrefCounterScreen extends StatefulWidget {
  const PrefCounterScreen({super.key});

  @override
  State<PrefCounterScreen> createState() => _PrefCounterScreenState();
}

class _PrefCounterScreenState extends State<PrefCounterScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter_key') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = _counter + 1;
    await prefs.setInt('counter_key', newCount);
    setState(() {
      _counter = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1Q7: SharedPreferences Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Persisted Counter Value:'),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Increment & Save'),
              onPressed: _incrementCounter,
            ),
          ],
        ),
      ),
    );
  }
}
