import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _sharedHistory = [];
  String? _expressionFromHistory;
  
  // Список экранов
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    
    _screens = [
      CalculatorScreen(
        onAddToHistory: (expression, result) {
          _sharedHistory.add({
            'expression': expression,
            'result': result,
          });
        },
        history: _sharedHistory,
        initialExpression: _expressionFromHistory,
      ),
      HistoryScreen(
        history: _sharedHistory,
        onSelectExpression: (expression) {
          // Сохраняем выражение и переключаемся на калькулятор
          setState(() {
            _expressionFromHistory = expression;
            _selectedIndex = 0;
          });
        },
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Обновляем экран калькулятора с новым выражением
    _screens[0] = CalculatorScreen(
      onAddToHistory: (expression, result) {
        _sharedHistory.add({
          'expression': expression,
          'result': result,
        });
      },
      history: _sharedHistory,
      initialExpression: _expressionFromHistory,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Калькулятор' : 'История'),
      ),
      body: _screens[_selectedIndex],
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