import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  final Function(String, String)? onAddToHistory;
  final List<Map<String, dynamic>> history;  // ← ИЗМЕНИТЬ ТУТ
  
  const CalculatorScreen({
    super.key,
    this.onAddToHistory,
    required this.history,  // ← И ТУТ ТИП
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  List<String> _expression = [];

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
        _expression.clear();
      } else if (buttonText == '⌫') {
        if (_expression.isNotEmpty) {
          final last = _expression.last;
          if (last.length > 1) {
            _expression[_expression.length - 1] = last.substring(0, last.length - 1);
          } else {
            _expression.removeLast();
          }
        }
        _updateDisplay();
      } else if (buttonText == '=') {
        if (_expression.isNotEmpty) {
          try {
            final result = _evaluateExpression();
            final expressionStr = _expression.join(' ');
            
            if (widget.onAddToHistory != null) {
              widget.onAddToHistory!(expressionStr, result.toString());
            }
            
            _display = result.toString();
            _expression = [result.toString()];
          } catch (e) {
            _display = 'Error';
            _expression.clear();
          }
        }
      } else if (['+', '-', '×', '÷', '%'].contains(buttonText)) {
        if (_expression.isEmpty) {
          _expression.add('0');
        }
        
        if (_expression.isNotEmpty && 
            ['+', '-', '×', '÷', '%'].contains(_expression.last)) {
          _expression[_expression.length - 1] = buttonText;
        } else {
          _expression.add(buttonText);
        }
        _updateDisplay();
      } else {
        if (_expression.isEmpty) {
          _expression.add(buttonText);
        } else {
          final last = _expression.last;
          
          if (['+', '-', '×', '÷', '%'].contains(last)) {
            _expression.add(buttonText);
          } else {
            if (buttonText == '.') {
              if (!last.contains('.')) {
                _expression[_expression.length - 1] = last + buttonText;
              }
            } else {
              _expression[_expression.length - 1] = last + buttonText;
            }
          }
        }
        _updateDisplay();
      }
    });
  }

  void _updateDisplay() {
    if (_expression.isEmpty) {
      _display = '0';
    } else {
      _display = _expression.join(' ');
    }
  }

  double _evaluateExpression() {
    if (_expression.isEmpty) return 0;
    
    List<String> tokens = List.from(_expression);
    
    for (int i = 1; i < tokens.length; i += 2) {
      if (tokens[i] == '×' || tokens[i] == '÷') {
        final left = double.parse(tokens[i - 1]);
        final right = double.parse(tokens[i + 1]);
        double result;
        
        if (tokens[i] == '×') {
          result = left * right;
        } else {
          if (right == 0) throw Exception('Деление на ноль');
          result = left / right;
        }
        
        tokens[i - 1] = result.toString();
        tokens.removeRange(i, i + 2);
        i -= 2;
      }
    }
    
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      final right = double.parse(tokens[i + 1]);
      if (tokens[i] == '+') {
        result += right;
      } else if (tokens[i] == '-') {
        result -= right;
      } else if (tokens[i] == '%') {
        result = result % right;
      }
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          height: 120,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              _display,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1),
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
              _buildButton('=', Colors.orange),
              const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, [Color? color]) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
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