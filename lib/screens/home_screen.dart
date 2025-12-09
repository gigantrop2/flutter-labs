import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import '../data/local_storage.dart';
import '../data/time_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _sharedHistory = [];
  late List<Widget> _screens;
  final TimeService _timeService = TimeService();
  String? _selectedExpression;  // ← ХРАНИМ ВЫБРАННОЕ ВЫРАЖЕНИЕ

  @override
  void initState() {
    super.initState();
    _loadHistoryAndInitializeScreens();
  }

  Future<void> _loadHistoryAndInitializeScreens() async {
    await _loadHistory();
    
    _screens = [
      CalculatorScreen(
        onAddToHistory: (expression, result) async {
          final timeResult = await _timeService.getCurrentTime();
          final DateTime timestamp;
          
          if (timeResult['success'] == true) {
            timestamp = DateTime.parse(timeResult['datetime']);
          } else {
            timestamp = _timeService.getLocalTime();
          }
          
          final newItem = {
            'expression': expression,
            'result': result,
            'timestamp': timestamp.toIso8601String(),
            'fromApi': timeResult['success'] == true,
          };
          
          setState(() {
            _sharedHistory.insert(0, newItem);
            _selectedExpression = null;  // ← СБРАСЫВАЕМ ПОСЛЕ ДОБАВЛЕНИЯ
          });
          
          await _saveHistory();
        },
        history: _sharedHistory,
        initialExpression: _selectedExpression,  // ← ПЕРЕДАЕМ ВЫРАЖЕНИЕ
      ),
      HistoryScreen(
        history: _sharedHistory,
        onSelectExpression: (expression) {
          setState(() {
            _selectedExpression = expression;  // ← СОХРАНЯЕМ ВЫБРАННОЕ
            _selectedIndex = 0;  // ПЕРЕКЛЮЧАЕМСЯ НА КАЛЬКУЛЯТОР
            _loadHistoryAndInitializeScreens();  // ← ОБНОВЛЯЕМ ЭКРАН
          });
        },
        onClearHistory: () async {
          await _clearHistory();
        },
      ),
    ];
    
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadHistory() async {
    _sharedHistory = await LocalStorage.loadHistory();
  }

  Future<void> _saveHistory() async {
    await LocalStorage.saveHistory(_sharedHistory);
  }

  Future<void> _clearHistory() async {
    setState(() {
      _sharedHistory.clear();
      _selectedExpression = null;
    });
    await LocalStorage.clearHistory();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Калькулятор' : 'История'),
      ),
      body: _screens.isNotEmpty 
          ? _screens[_selectedIndex]
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Калькулятор',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}