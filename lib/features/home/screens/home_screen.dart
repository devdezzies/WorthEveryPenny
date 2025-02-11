import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/auth/services/auth_service.dart';
import 'package:swappp/features/home/widgets/balance_card.dart';
import 'package:swappp/features/home/widgets/empty_transaction_list.dart';
import 'package:swappp/features/home/widgets/filled_transaction_list.dart';
import 'package:swappp/features/home/widgets/goal_wallet.dart';
import 'package:swappp/features/home/widgets/personalized_insight_filled.dart';
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
    final AuthService authService = AuthService();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          leadingWidth: MediaQuery.of(context).size.width * 0.7,
          leading: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                ClipOval(
                  child: user.profilePicture.isNotEmpty
                      ? CachedNetworkImage(
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          imageUrl: user.profilePicture,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 35,
                          height: 35,
                        )
                      : Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: GlobalVariables.darkerGreyBackgroundColor,
                          ),
                          child: const Center(
                            child: Text(
                              '😎',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
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
        body: CustomRefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              // Refresh the user data
              authService.getUserData(context);
            });
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            // padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SpendingPulse(value: calculateFinancialHealth(user)),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BalanceCard(
                  expense: user.monthlyReport[0].totalExpense.toInt(),
                  totalBalance: user.cash +
                      (user.bankAccount.isEmpty
                          ? 0
                          : user.bankAccount
                              .map((e) => e.balance.toInt())
                              .reduce((a, b) => a + b)),
                  income: user.monthlyReport[0].totalIncome.toInt(),
                  expensePercentage: calculateFinancialHealth(user),
                  lastUpdated: user.transactions.isNotEmpty
                      ? user.transactions[0].createdAt
                      : user.updatedAt,
                ),
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
                      SizedBox(width: 16,),
                      PersonalizedInsightFilled(),
                      GoalWallet(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: user.transactions.isEmpty
                  ? const EmptyTransactionList()
                  : const FilledTransactionList()
              ), 
              const SizedBox(
                height: 50,
              ),
            ],
          ),
          builder: (context, child, controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                        height: controller.value *
                            60), // Adjust the height as needed
                    Expanded(child: child),
                  ],
                ),
                if (controller.isLoading)
                  Container(
                    width: double.infinity,
                    height: 60,
                    color: GlobalVariables.backgroundColor,
                    child: Lottie.asset('assets/lottie/dollar_refresh.json'),
                  ),
              ],
            );
          },
        ));
  }
}
