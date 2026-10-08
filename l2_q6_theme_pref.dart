import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Level 2 Moderate Q6:
// Create a settings screen that saves a theme preference (dark/light) using SharedPreferences and applies it on launch.

void main() {
  runApp(const L2Q6ThemePrefApp());
}

class L2Q6ThemePrefApp extends StatefulWidget {
  const L2Q6ThemePrefApp({super.key});

  @override
  State<L2Q6ThemePrefApp> createState() => _L2Q6ThemePrefAppState();
}

class _L2Q6ThemePrefAppState extends State<L2Q6ThemePrefApp> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadThemePref();
  }

  Future<void> _loadThemePref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('is_dark_mode') ?? false;
    });
  }

  Future<void> _toggleTheme(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', val);
    setState(() {
      _isDark = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L2Q6 - Theme Preference',
      theme: _isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      home: ThemeSettingsScreen(
        isDark: _isDark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class ThemeSettingsScreen extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const ThemeSettingsScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2Q6: Theme Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              title: const Text('Dark Mode'),
              subtitle: const Text('Preference is saved in SharedPreferences'),
              trailing: Switch(
                value: isDark,
                onChanged: onThemeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
