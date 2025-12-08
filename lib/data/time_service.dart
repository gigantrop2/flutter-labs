import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeService {
  static const String _apiUrl = 'http://worldtimeapi.org/api/timezone/Europe/Moscow';

  Future<Map<String, dynamic>> getCurrentTime() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'datetime': data['datetime'],
          'timezone': data['timezone'],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to load time',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  DateTime getLocalTime() {
    return DateTime.now();
  }
}