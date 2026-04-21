import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('$title — 开发中', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
