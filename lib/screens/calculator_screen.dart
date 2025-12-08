import 'package:flutter/material.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Убрали const перед HistoryScreen()
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(), // Без const!
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Дисплей
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            height: 120,
            child: const Text(
              '0',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          // Клавиатура калькулятора
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(16),
              children: [
                _buildButton('C', Colors.redAccent),
                _buildButton('⌫'),
                _buildButton('%'),
                _buildButton('÷', Colors.orange),
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('×', Colors.orange),
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('-', Colors.orange),
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('+', Colors.orange),
                _buildButton('0'),
                _buildButton('.'),
                _buildButton('=', Colors.orange), // Убрали colspan
                SizedBox(), // Пустая ячейка для выравнивания
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, [Color? color]) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: null, // Пока без логики
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[200],
          foregroundColor: color != null ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(60, 60),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}