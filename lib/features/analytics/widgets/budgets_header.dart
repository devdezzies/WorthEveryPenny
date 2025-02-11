import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_snackbar.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/analytics/widgets/budget_card.dart';

class BudgetHeader extends StatelessWidget {
  const BudgetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              const Text(
                "My Budgets",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFFAAAAAA),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  CustomSnackBar.show(context,
                      type: SnackBarType.warning,
                      message: "Feature not available yet");
                  // Handle menu tap
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Create Budget",
                    style: TextStyle(
                      color: GlobalVariables.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
            Stack(
            children: [
              const SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                SizedBox(width: 16),
                BudgetCard(
                  category: 'Food & Drink',
                  emoji: '🍔',
                  spent: 165,
                  total: 900,
                  gradientColors: const [
                  GlobalVariables.darkerGreyBackgroundColor,
                  GlobalVariables.darkerGreyBackgroundColor,
                  ],
                ),
                BudgetCard(
                  category: 'Transport',
                  emoji: '🚗',
                  spent: 50,
                  total: 200,
                  gradientColors: const [
                  GlobalVariables.darkerGreyBackgroundColor,
                  GlobalVariables.darkerGreyBackgroundColor,
                  ],
                ),
                BudgetCard(
                  category: 'Entertainment',
                  emoji: '🎮',
                  spent: 100,
                  total: 300,
                  gradientColors: const [
                  GlobalVariables.darkerGreyBackgroundColor,
                  GlobalVariables.darkerGreyBackgroundColor,
                  ],
                ),
                BudgetCard(
                  category: 'Shopping',
                  emoji: '🛍️',
                  spent: 200,
                  total: 500,
                  gradientColors: const [
                  GlobalVariables.darkerGreyBackgroundColor,
                  GlobalVariables.darkerGreyBackgroundColor,
                  ],
                ),
                BudgetCard(
                  category: 'Health',
                  emoji: '💊',
                  spent: 50,
                  total: 100,
                  gradientColors: const [
                  GlobalVariables.darkerGreyBackgroundColor,
                  GlobalVariables.darkerGreyBackgroundColor,
                  ],
                ),
                ],
              ),
              ),
              Positioned.fill(
              child: Container(
                color: GlobalVariables.backgroundColor.withOpacity(0.5),
                child: const Center(
                child: Text(
                  '🗝️ Coming Soon',
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                ),
              ),
              ),
            ],
            )
        ],
      ),
    );
  }
}
