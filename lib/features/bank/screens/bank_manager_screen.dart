import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/widgets/custom_button.dart';
import 'package:swappp/common/widgets/custom_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/bank/service/bank_service.dart';
import 'package:swappp/providers/bank_provider.dart';
import 'package:swappp/providers/user_provider.dart';

class BankManagerScreen extends StatefulWidget {
  static const String routeName = '/bank-manager';
  const BankManagerScreen({super.key});

  @override
  State<BankManagerScreen> createState() => _BankManagerScreenState();
}

class _BankManagerScreenState extends State<BankManagerScreen> {
  final PageController _pageControllerBottom = PageController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final BankService _bankService = BankService();
  int _currentPage = 0;

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _pageControllerBottom.animateToPage(_pageControllerBottom.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void _previousPage() {
    setState(() {
      _currentPage--;
    });
    _pageControllerBottom.animateToPage(_pageControllerBottom.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Widget _accountNumberDisplay(
      String bankName, String accountNumber, double balance, String accountType) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.credit_card_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bankName.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Text(
                        "${rupiahFormatCurrency(balance.toInt())}.00",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        accountNumber,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: GlobalVariables.secondaryColor.withAlpha(51), 
                          borderRadius: BorderRadius.circular(5)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: const Text(
                          // TODO: SHOULE BE ACCOUNT TYPE
                          "Basic",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14, color: GlobalVariables.secondaryColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _previewCardsView() {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeArea(
                child: Column(
              children: [
                const SizedBox(height: 15),
                ...List.generate(userProvider.user.bankAccount.length, (index) {
                  return _accountNumberDisplay(
                      userProvider.user.bankAccount[index].bankName,
                      userProvider.user.bankAccount[index].accountNumber,
                      userProvider.user.bankAccount[index].balance, 
                      userProvider.user.bankAccount[index].accountType);
                }),
                const SizedBox(height: 15),
                CustomButton(
                    textTitle: "Add New Account",
                    onTap: () {
                      _nextPage();
                    }),
                const SizedBox(height: 15),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _addNewCardView() {
    final BankProvider bankProvider =
        Provider.of<BankProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
              CustomTextField(
                  controller: _cardNumberController,
                  hint: "Account Number", 
                  label: "Account", 
                  type: TextFieldType.number, 
                  maxLength: 16,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                  controller: _bankNameController,
                  hint: "Account Name (e.g. Bank, e-Wallet, etc.)", 
                  label: "Account Name", 
                  type: TextFieldType.text,
                  maxLength: 20,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                  controller: _balanceController,
                  hint: "Balance", 
                  label: "Balance", 
                  type: TextFieldType.currency
              ),
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.center,
                children: [
                  Divider(
                    color: Colors.grey[700],
                    thickness: 1,
                    height: 1,
                  ),
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Text(
                      "Connect via Open Finance",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[900]),
                child: Center(
                  child: Text(
                    "Brankas (coming soon)",
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
          SafeArea(
              child: Column(
            children: [
              CustomButton(
                  textTitle: "Finish",
                  onTap: () async {
                    if (_cardNumberController.text.isEmpty ||
                        _bankNameController.text.isEmpty || _balanceController.text.isEmpty) {
                      return;
                    }
                    bankProvider.setBankAccountDetails(
                        accountNumber: _cardNumberController.text,
                        bankName: _bankNameController.text,
                        balance: _balanceController.text.isNotEmpty
                            ? double.parse(_balanceController.text.replaceAll(RegExp(r'[^0-9]'), ''))
                            : 0.0);
                    _bankService.addNewBankAccount(context);
                    Navigator.of(context).pop();
                  }),
              const SizedBox(height: 15),
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Text(_currentPage == 0 ? "Your Accounts" : "Add New Account",
            style: const TextStyle(fontWeight: FontWeight.w700)),
        iconTheme: IconThemeData(color: Colors.grey[500]),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_pageControllerBottom.page!.toInt() > 0) {
              _previousPage();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageControllerBottom,
        children: [
          _previewCardsView(),
          _addNewCardView(),
        ],
      ),
    );
  }
}
