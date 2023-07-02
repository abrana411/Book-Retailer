import 'package:a_to_z_shop/features/account/widgets/button_column.dart';
import 'package:a_to_z_shop/features/account/widgets/user_orders.dart';
import 'package:a_to_z_shop/helperConstants/global_variables.dart';
import 'package:flutter/material.dart';

import '../widgets/content_below_app_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Now we want to adjust the height of the appbar andd in order to do that we can use the preffered size widget and set the height as written below
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), //giving the height as 50
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient:
                  GlobalVariables.appBarGradient, //passing the gredient color
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.notifications_outlined),
                    ),
                    Icon(
                      Icons.search,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: const [
          BelowAppBarInAccount(),
          SizedBox(
            height: 10,
          ),
          //have to show 4 buttons now:- (which i have written in the ButtonColumn.dart file)
          ButtonColumn(),
          SizedBox(
            height: 20,
          ),
          UserOrders(),
        ],
      ),
    );
  }
}
