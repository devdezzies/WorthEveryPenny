import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_snackbar.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';

class MonthInReview extends StatelessWidget {
  final int totalIncome, totalExpense, net;
  const MonthInReview({super.key, required this.totalIncome, required this.totalExpense, required this.net});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
            Text(
            "${monthName(DateTime.now().month)} in Review",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
            ),
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text("Income", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),),
                  const SizedBox(height: 5),
                  Text(rupiahFormatCurrency(totalIncome), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: GlobalVariables.secondaryColor), overflow: TextOverflow.ellipsis,),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const Text("Net", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),),
                  const SizedBox(height: 5),
                  Text(rupiahFormatCurrency(net), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white), overflow: TextOverflow.ellipsis,),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const Text("Expense", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),),
                  const SizedBox(height: 5),
                  Text(rupiahFormatCurrency(totalExpense), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.redAccent), overflow: TextOverflow.ellipsis,),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Divider(color: Colors.grey[900], thickness: 1,),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: (){
              CustomSnackBar.show(context, message: "Feature not available yet", type: SnackBarType.warning);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: GlobalVariables.secondaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              width: double.infinity,
              child: const Text(
                "See Monthly Report",
                style: TextStyle(color: GlobalVariables.backgroundColor, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}