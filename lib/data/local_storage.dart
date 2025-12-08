import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _historyKey = 'calculator_history';

  static Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = history.map((item) {
      return '${item['expression']}|${item['result']}|${item['timestamp']}|${item['fromApi'] ?? false}';
    }).toList();
    await prefs.setStringList(_historyKey, historyStrings);
  }

  static Future<List<Map<String, dynamic>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = prefs.getStringList(_historyKey);
    
    if (historyStrings == null) return [];
    
    return historyStrings.map((item) {
      final parts = item.split('|');
      return {
        'expression': parts[0],
        'result': parts[1],
        'timestamp': parts[2],
        'fromApi': parts[3] == 'true',
      };
    }).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}