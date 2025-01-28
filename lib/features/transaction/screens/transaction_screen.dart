import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/transaction/screens/amount_input_screen.dart';
import 'package:swappp/features/transaction/screens/category_selection.dart';

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
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 30,
                  ),
                  color: GlobalVariables.secondaryColor,
                )
              : null,
        ),
        title: _currentPage > 0 ? Text(rupiahFormatCurrency(_amount), style: const TextStyle(fontWeight: FontWeight.w700),) : const Text("New Transaction"),
        centerTitle: true,
        backgroundColor: GlobalVariables.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 40),
            onPressed: () => Navigator.pop(context),
            color: GlobalVariables
                .secondaryColor, // Set the button color to transparent
            iconSize: 40,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: PageView(
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
          const CategorySelection()
        ],
      ),
    );
  }
}

Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const TransactionScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

// Usage example:
// Navigator.of(context).push(createRoute());
