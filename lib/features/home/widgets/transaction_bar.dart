import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/transaction/services/transaction_service.dart';
import 'package:swappp/providers/user_provider.dart';

class TransactionBar extends StatefulWidget {
  final String transactionName,
      transactionType,
      transactionCategory,
      accountNumber,
      transactionId;
  final DateTime transactionDate;
  final String recurring;
  final int transactionAmount;
  
  const TransactionBar({
    super.key,
    required this.transactionName,
    required this.transactionType,
    required this.transactionDate,
    required this.transactionCategory,
    required this.transactionAmount,
    required this.recurring,
    required this.transactionId, 
    required this.accountNumber
  });

  @override
  State<TransactionBar> createState() => _TransactionBarState();
}

class _TransactionBarState extends State<TransactionBar> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showTransactionDetails(BuildContext context) {
    void _showDeleteConfirmation(String transactionId) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: GlobalVariables.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              'Delete Transaction',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete this transaction? This action cannot be undone.',
              style: TextStyle(color: Colors.grey[400]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              TextButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child:
                            Lottie.asset('assets/lottie/dollar_refresh.json'),
                      );
                    },
                  );
                  await TransactionService()
                      .deleteTransaction(context, transactionId);
                  await TransactionService().getCategorizedTransactions(context);
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (context.mounted) {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close bottom sheet
                    Navigator.pop(context); // Close transaction details
                  }
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: GlobalVariables.backgroundColor,
      context: context,
      builder: (context) {
        final userProvider = Provider.of<UserProvider>(context);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction type and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: GlobalVariables.secondaryColor.withAlpha(50),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "${getCategoryEmoji(widget.transactionCategory)} ${widget.transactionCategory}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: GlobalVariables.secondaryColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formatDateTime(widget.transactionDate),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        _showDeleteConfirmation(
                          widget.transactionId,
                        );
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.redAccent,
                      ))
                ],
              ),
              const SizedBox(height: 20),

              // Transaction name and amount
              Text(
                widget.transactionName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${widget.transactionType == 'income' ? "+" : "-"} ${rupiahFormatCurrency(widget.transactionAmount)}",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.transactionType == 'income'
                      ? GlobalVariables.secondaryColor
                      : Colors.redAccent,
                ),
              ),

              // Add note button
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                child: const Text(
                  'Add a note',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Programmatic Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A2A6C),
                      Color(0xFFB21F1F),
                      Color(0xFFFDBB2D)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            // find bankName by accountNumber in userProvider
                            userProvider.getBankNamebyAccountNumber(widget.accountNumber),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.credit_card,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Card Number
                    Text(
                      widget.transactionType == 'cash' ? 'Cash' : widget.accountNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 5,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Card Holder
                    Text(
                      'Basic',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isIncome = widget.transactionType == 'income';
    
    return Stack(
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
            _animationController.forward();
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
            _animationController.reverse();
            _showTransactionDetails(context);
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
            _animationController.reverse();
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: _isPressed 
                      ? [] 
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                  ),
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GlobalVariables.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isIncome ? "💸" : getCategoryEmoji(widget.transactionCategory),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.transactionName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Text(
                              formatDateTime(widget.transactionDate),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${isIncome ? "+" : "-"} ${rupiahFormatCurrency(widget.transactionAmount)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isIncome
                              ? GlobalVariables.secondaryColor
                              : Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.recurring != 'never')
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: GlobalVariables.secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.recurring[0].toUpperCase() + widget.recurring.substring(1),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

