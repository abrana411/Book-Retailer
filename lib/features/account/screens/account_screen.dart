import 'package:flutter/material.dart';

import '../widgets/content_below_app_bar.dart';
import '../widgets/button_column.dart';
import '../widgets/user_orders.dart';
import '../../../constants/global_variables.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Now we want to adjust the height of the appbar andd in order to do that we can use the preffered size widget and set the height as written below
      appBar: AppBar(
        // elevation: 0,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: GlobalVariables.appBarGradient,
        //   ),
        // ),
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //       alignment: Alignment.topLeft,
        //       child: Image.asset(
        //         'assets/images/amazon_in.png',
        //         width: 120,
        //         height: 45,
        //         color: Colors.black,
        //       ),
        //     ),
        //     Container(
        //       padding: const EdgeInsets.only(left: 15, right: 15),
        //       child: const Row(
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.only(right: 15),
        //             child: Icon(Icons.notifications_outlined),
        //           ),
        //           Icon(
        //             Icons.search,
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        title: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Text('Account'),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout_outlined),
            ),
            // Positioned(
            //   left: 5,
            //   top: 0,
            //   child: IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.logout_outlined),
            //   ),
            // ),
          ],
        ),
      ),
      body: const Column(
        children: [
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.sell),
        label: const Text('Sell Products'),
      ),
    );
  }
}
