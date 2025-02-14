import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/providers/transaction_provider.dart';

class NumberKeyboard extends StatefulWidget {
  final void Function(String) onInput;
  const NumberKeyboard({super.key, required this.onInput});

  @override
  // ignore: library_private_types_in_public_api
  _NumberKeyboardState createState() => _NumberKeyboardState();
}

class _NumberKeyboardState extends State<NumberKeyboard> {
  String _input = '';
  int _tappedIndex = -1;
  final int _maxLength = 10; // Set the maximum length for the input

  @override  
  void didChangeDependencies() {
    _input = Provider.of<TransactionProvider>(context).currentNumber;
    super.didChangeDependencies();
  }

  void _onKeyTap(String value, int index) {
    setState(() {
      if (_input.length < _maxLength) {
        if (_input == '0') {
          _input = value;
        } else {
          _input += value;
        }
        _tappedIndex = index;
      }
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _tappedIndex = -1;
      });
    });
  }

  void _onBackspace() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  String _formatRupiah(String input) {
    if (input.isEmpty) return 'Rp 0';
    final buffer = StringBuffer('Rp ');
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && (input.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _formatRupiah(_input),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: GlobalVariables.secondaryColor),
            ),
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            if (index == 9) {
              return IconButton(
                icon: const Icon(Icons.backspace),
                onPressed: _onBackspace,
                iconSize: 30,
              );
            } else if (index == 10) {
              return _buildKey('0', index);
            } else if (index == 11) {
              return const SizedBox.shrink();
            } else {
              return _buildKey('${index + 1}', index);
            }
          },
        ),
        // button to continue to the next page
        SafeArea(
          child: GestureDetector(
            onTap: () {
              if (_input.isEmpty) {
                _input = "0";
              }
              Provider.of<TransactionProvider>(context, listen: false).setCurrentNumber(_input);
              widget.onInput(_input);
            },
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: GlobalVariables.secondaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  'Continue ',
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKey(String value, int index) {
    return GestureDetector(
      onTap: () => _onKeyTap(value, index),
      child: AnimatedScale(
        scale: _tappedIndex == index ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: GlobalVariables.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class AmountInputScreen extends StatelessWidget {
  final void Function(String) onInput;
  const AmountInputScreen({super.key, required this.onInput});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NumberKeyboard(
        onInput: onInput,
      )
    );
  }
}
