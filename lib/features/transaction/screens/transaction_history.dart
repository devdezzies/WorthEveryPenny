import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/home/widgets/transaction_bar.dart';
import 'package:swappp/providers/transaction_provider.dart';

class TransactionHistory extends StatefulWidget {
  static const String routeName = '/transaction-history';
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _tabKeys = [];
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToActiveTab() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentPage < _tabKeys.length && _tabKeys[_currentPage].currentContext != null) {
        Scrollable.ensureVisible(
          _tabKeys[_currentPage].currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5, // Center the active tab
        );
      }
    });
  }

  Widget _buildPageView(List<dynamic> monthlyTransaction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: monthlyTransaction.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getFullDate(monthlyTransaction[index]["day"]), style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                Expanded(
                    child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                      return Row(
                        children: List.generate(
                        (constraints.constrainWidth() / 10).floor(),
                        (index) => Expanded(
                          child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 1,
                          color: Colors.grey,
                          ),
                        ),
                        ),
                      );
                      },
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent.withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_down_rounded, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 5,),
                          Text(
                            rupiahFormatCurrency(monthlyTransaction[index]["transactions"]
                              .where((transaction) => transaction["type"] == "expense")
                              .fold(0, (sum, item) => sum + item["amount"])),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            subtitle:
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: monthlyTransaction[index]["transactions"].length,
              itemBuilder: (context, i) {
                return TransactionBar(
                    transactionId: monthlyTransaction[index]["transactions"][i]["_id"],
                    transactionName: monthlyTransaction[index]["transactions"][i]["name"],
                    transactionAmount: monthlyTransaction[index]["transactions"][i]["amount"],
                    recurring: monthlyTransaction[index]["transactions"][i]["recurrenceInterval"] ?? 'never',
                    transactionDate: convertUtcToDateTime( DateTime.parse(monthlyTransaction[index]["transactions"][i]["date"])),
                    transactionCategory: monthlyTransaction[index]["transactions"][i]["category"],
                    transactionType: monthlyTransaction[index]["transactions"][i]["type"],
                  );
              },
            )
                //Text(monthlyTransaction[index]["transactions"][0]["name"]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);
    
    while (_tabKeys.length < transactionProvider.fetchedCategorizedTransactions.length) {
      _tabKeys.add(GlobalKey());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        iconTheme: IconThemeData(color: Colors.grey[500]),
        leading: Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Transactions',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: GlobalVariables.backgroundColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  ...List.generate(
                    transactionProvider.fetchedCategorizedTransactions.length,
                    (index) {
                      bool isActive = _currentPage == index;
                      return GestureDetector(
                        key: _tabKeys[index],
                        onTap: () => _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: isActive
                                ? GlobalVariables.secondaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              getMonthYear(transactionProvider
                                      .fetchedCategorizedTransactions[index]
                                  ["_id"]),
                              style: TextStyle(
                                  color: isActive
                                      ? Colors.black
                                      : GlobalVariables.secondaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                _scrollToActiveTab();
              },
              children: List.generate(
                transactionProvider.fetchedCategorizedTransactions.length,
                (index) => _buildPageView(
                  transactionProvider.fetchedCategorizedTransactions[index]["days"],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}