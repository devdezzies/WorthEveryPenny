import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyBudgetCard extends StatelessWidget {
  final double budgetPercentage;
  final double spentAmount;
  final double totalBudget;

  const DailyBudgetCard({
    super.key,
    required this.budgetPercentage,
    required this.spentAmount,
    required this.totalBudget,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final remainingBudget = totalBudget - spentAmount;
    final isOverBudget = spentAmount > totalBudget;
    final progressPercentage = (spentAmount / totalBudget).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 180,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          "Today's Budget",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAAAAAA),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.more_horiz, color: Color(0xFFAAAAAA), size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${budgetPercentage.toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Spent: ${currencyFormatter.format(spentAmount)}k",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCCCCCC),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total: ${currencyFormatter.format(totalBudget)}k",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCCCCCC),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    isOverBudget ? "Over budget!" : "Remaining: ${currencyFormatter.format(remainingBudget)}k",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isOverBudget ? Colors.red : const Color(0xFF9FFF00),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: SizedBox(
              height: 20,
              child: LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: const Color(0xFF2A2A2A),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9FFF00)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

