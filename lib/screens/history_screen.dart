import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> history;
  final Function(String)? onSelectExpression;

  const HistoryScreen({
    super.key,
    required this.history,
    this.onSelectExpression,
  });

  @override
  Widget build(BuildContext context) {
    return history.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'История вычислений пуста',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[50],
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  title: Text(
                    item['expression']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    '= ${item['result']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  trailing: onSelectExpression != null
                      ? IconButton(
                          icon: const Icon(Icons.replay, color: Colors.blue),
                          onPressed: () {
                            onSelectExpression!(item['expression']!);
                          },
                        )
                      : null,
                ),
              );
            },
          );
  }
}