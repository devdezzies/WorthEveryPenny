import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/transaction/screens/sub/amount_input_screen.dart';
import 'package:swappp/features/transaction/screens/sub/initiate_transaction_screen.dart';
import 'package:swappp/providers/transaction_provider.dart';

class TransactionScreen extends StatefulWidget {
  static const String routeName = '/transaction';
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  int _amount = 0;

  @override 
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          child: _currentPage > 0 
              ? IconButton(
                  onPressed: () {
                    _previousPage();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey[500],
                  ),
                )
              : null,
        ),
        title: _currentPage > 0 ? Text('${transactionProvider.transaction.type == 'income' ? '+' : '-'} ${rupiahFormatCurrency(_amount)}', style: TextStyle(fontWeight: FontWeight.w700, color: transactionProvider.transaction.type == 'income' ? GlobalVariables.secondaryColor : Colors.redAccent),) : const Text("New Transaction"),
        centerTitle: true,
        backgroundColor: GlobalVariables.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[500],),
            onPressed: () {
              Navigator.pop(context);
              transactionProvider.setCurrentNumber('');
            }, // Set the button color to transparent
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: PageView(
        // disable swipe
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          AmountInputScreen(onInput: (amount) {
            _amount = int.parse(amount);
            _nextPage();
          }),
          const InitiateTransactionScreen()
        ],
      ),
    );
  }
}
