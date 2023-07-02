import 'package:a_to_z_shop/features/account/services/account_services.dart';
import 'package:a_to_z_shop/features/account/widgets/acc_btns.dart';
import 'package:flutter/material.dart';

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
                textToShow: "Sell Products", whatWillHappenOnClicking: () {}),
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
