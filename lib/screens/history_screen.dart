import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История вычислений'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: const [
          ListTile(title: Text('15 + 27 = 42')),
          ListTile(title: Text('100 ÷ 4 = 25')),
          ListTile(title: Text('7 × 8 = 56')),
          ListTile(title: Text('50 - 23 = 27')),
          ListTile(title: Text('√144 = 12')),
        ],
      ),
    );
  }
}