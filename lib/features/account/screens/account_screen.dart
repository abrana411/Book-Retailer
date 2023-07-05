import 'package:a_to_z_shop/features/account/widgets/user_orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../services/account_services.dart';
import '../widgets/content_below_app_bar.dart';
import '../../../features/account/screens/sell_products_screen.dart';
// import '../widgets/button_column.dart';
// import '../widgets/user_orders.dart';
// import '../../../constants/global_variables.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pass =
        Provider.of<UserProvider>(context, listen: false).user.password;
    final isGoogleSignout = pass.isEmpty;
    return Scaffold(
      //Now we want to adjust the height of the appbar andd in order to do that we can use the preffered size widget and set the height as written below
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), //giving the height as 50
        child: AppBar(
          elevation: 0,
          // flexibleSpace: Container(
          //   decoration: const BoxDecoration(
          //     gradient:
          //         GlobalVariables.appBarGradient, //passing the gredient color
          //   ),
          // ),
          //     title: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           alignment: Alignment.topLeft,
          //           child: Image.asset(
          //             'assets/images/amazon_in.png',
          //             width: 120,
          //             height: 45,
          //             color: Colors.black,
          //           ),
          //         ),
          //         Container(
          //           padding: const EdgeInsets.only(left: 15, right: 15),
          //           child: const Row(
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.only(right: 15),
          //                 child: Icon(Icons.notifications_outlined),
          //               ),
          //               Icon(
          //                 Icons.search,
          //               ),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          title: const BelowAppBarInAccount(),
          actions: [
            ElevatedButton.icon(
                style:
                    const ButtonStyle(elevation: MaterialStatePropertyAll(0)),
                onPressed: () {
                  AccountServices().logOutUser(context, isGoogleSignout);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Sign out"))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, SellProductsScreen.routeName);
      //   },
      //   child: const Text(
      //     "Sell",
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, SellProductsScreen.routeName);
        },
        icon: const Icon(Icons.sell),
        label: const Text('Sell Products'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // BelowAppBarInAccount(),
            const SizedBox(
              height: 10,
            ),
            //have to show 4 buttons now:- (which i have written in the ButtonColumn.dart file)
            // ButtonColumn(),
            // SizedBox(
            //   height: 20,
            // ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "My orders",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const UserOrders(),
          ],
        ),
      ),
    );
  }
}
