import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../constants/global_variables.dart';

class BelowAppBarInAccount extends StatelessWidget {
  const BelowAppBarInAccount({super.key});

  //getting the current user:-
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 5),
      decoration: const BoxDecoration(color: GlobalVariables.secondaryColor),
      child: RichText(
        text: TextSpan(
            text: "Welcome ,   ",
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white, fontSize: 12),
            children: [
              TextSpan(
                text: currentUser.name, //name of the current user
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 20),
              )
            ]),
      ),
    );
  }
}
