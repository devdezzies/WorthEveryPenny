import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/home/widgets/balance_card.dart';
import 'package:swappp/features/home/widgets/empty_transaction_list.dart';
import 'package:swappp/features/home/widgets/filled_transaction_list.dart';
import 'package:swappp/features/home/widgets/goal_wallet_empty.dart';
import 'package:swappp/features/home/widgets/personalized_insight_empty.dart';
import 'package:swappp/features/home/widgets/spending_pulse.dart';
import 'package:swappp/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          leadingWidth: MediaQuery.of(context).size.width * 0.7,
          leading: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    imageUrl: user.profilePicture,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 35,
                    height: 35,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey[500]),
                      ),
                      Text(
                        "${user.displayName} 👋",
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: [
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: GlobalVariables.secondaryColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            const SizedBox(height: 5),
            SpendingPulse(value: calculateFinancialHealth(user)),
            const SizedBox(height: 16),
            // TODO: resolve the issue with last updated
            BalanceCard(
              expense: user.monthlyReport[0].totalExpense.toInt(),
              totalBalance: user.cash + (user.bankAccount.isEmpty ? 0 :  user.bankAccount.map((e) => e.balance.toInt()).reduce((a, b) => a + b)),
              income: user.monthlyReport[0].totalIncome.toInt(),
              expensePercentage: calculateFinancialHealth(user),
              lastUpdated: user.transactions.isNotEmpty
                  ? user.transactions[0].createdAt
                  : user.updatedAt,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              child: const SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PersonalizedInsightEmpty(),
                    GoalWalletEmpty(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            user.transactions.isEmpty
                ? const EmptyTransactionList()
                : const FilledTransactionList()
          ],
        ));
  }
}
