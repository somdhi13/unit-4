import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Level 3 Hard Q2:
// Implement an image caching layer (using manual disk cache or memory/file cache) for images downloaded from the network.

void main() {
  runApp(const L3Q2ImageCacheApp());
}

class L3Q2ImageCacheApp extends StatelessWidget {
  const L3Q2ImageCacheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'L3Q2 - Disk Image Cache',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DiskImageCacheScreen(),
    );
  }
}

class DiskImageCacheScreen extends StatefulWidget {
  const DiskImageCacheScreen({super.key});

  @override
  State<DiskImageCacheScreen> createState() => _DiskImageCacheScreenState();
}

class _DiskImageCacheScreenState extends State<DiskImageCacheScreen> {
  final String _imageUrl = 'https://picsum.photos/300/200';
  File? _cachedImageFile;
  String _status = 'Not loaded';

  Future<void> _loadAndCacheImage() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final localFile = File('${docDir.path}/cached_network_img.jpg');

      // Check Disk Cache
      if (await localFile.exists()) {
        setState(() {
          _cachedImageFile = localFile;
          _status = 'DISK CACHE HIT: Displaying image from local file system!';
        });
        return;
      }

      // Download from Network
      setState(() {
        _status = 'DISK CACHE MISS: Downloading image from network...';
      });

      final response = await http.get(Uri.parse(_imageUrl));
      if (response.statusCode == 200) {
        await localFile.writeAsBytes(response.bodyBytes);
        setState(() {
          _cachedImageFile = localFile;
          _status = 'DOWNLOAD SUCCESS: Saved image to Disk Cache!';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error downloading image: $e';
      });
    }
  }

  Future<void> _clearDiskCache() async {
    final docDir = await getApplicationDocumentsDirectory();
    final localFile = File('${docDir.path}/cached_network_img.jpg');
    if (await localFile.exists()) {
      await localFile.delete();
    }
    setState(() {
      _cachedImageFile = null;
      _status = 'Disk cache cleared!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3Q2: Disk Image Cache Layer')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _loadAndCacheImage, child: const Text('Load Image')),
                OutlinedButton(onPressed: _clearDiskCache, child: const Text('Clear Image Cache')),
              ],
            ),
            const SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _cachedImageFile == null
                  ? const Center(child: Text('No Image in Cache'))
                  : Image.file(_cachedImageFile!, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
