import 'package:flutter/material.dart';

import 'account_buttons.dart';
import '../screens/sell_products_screen.dart';
import '../screens/add_products_screen.dart';
import '../services/account_services.dart';

class ButtonColumn extends StatelessWidget {
  const ButtonColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Two rows with each having 2 buttons:-
        Row(
          children: [
            AccountButton(
                textToShow: "Your Orders", whatWillHappenOnClicking: () {}),
            AccountButton(
              textToShow: "Sell Products",
              whatWillHappenOnClicking: () {
                Navigator.pushNamed(context, SellProductsScreen.routeName);
              },
            ),
          ],
        ),
        Row(
          children: [
            AccountButton(
                textToShow: "Sign out",
                whatWillHappenOnClicking: () {
                  //Logging out user
                  AccountServices().logOutUser(context);
                }),
            AccountButton(
                textToShow: "My WishList", whatWillHappenOnClicking: () {}),
          ],
        )
      ],
    );
  }
}
