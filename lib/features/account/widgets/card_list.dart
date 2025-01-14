import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Set a fixed height for the Swiper
      child: Swiper(
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: const CreditCardUi(
              cardHolderFullName: "Abdullah",
              cardNumber: "2462623683746235",
              validThru: "10/24",
              topLeftColor: GlobalVariables.darkerGreyBackgroundColor,
              cardType: CardType.debit,
              currencySymbol: r'Rp',
              bottomRightColor: GlobalVariables.darkerGreyBackgroundColor,
              enableFlipping: true,
              cvvNumber: "251",
            ),
          );
        },
        loop: true,
        itemHeight: 200,
        itemWidth: MediaQuery.of(context).size.width,
        itemCount: 3,
        control: const SwiperControl(
          color: Colors.transparent
        ),
        layout: SwiperLayout.STACK,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
