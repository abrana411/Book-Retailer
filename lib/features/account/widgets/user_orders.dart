import 'package:flutter/material.dart';

import '../../../models/order_model.dart';
import '../widgets/single_product.dart';
import '../services/account_services.dart';
import '../../../constants/screen_loader.dart';
import '../../../constants/global_variables.dart';
import '../../order_details/screens/order_details_screen.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  List<Order>? userOrders = [];
  AccountServices accountServices = AccountServices();
  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  //Fethcing the user orders and also storing them into list (till then we will show a loader)
  void fetchUserOrders() async {
    userOrders = await accountServices.fetchMyOrders(context: context);
    print(userOrders!.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return userOrders == null
        ? const ScreenLoader()
        : Column(
            children: [
              //Row with two texts as a container each
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: const Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                    ),
                  ),
                ],
              ),
              //container to display all the orders (as it has a list view.builder in horizontal direction)
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 20,
                ),
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: userOrders!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          //Navigate to the order details screen by passing the current order
                          Navigator.pushNamed(
                              context, OrderDetailsScreen.routeName,
                              arguments: userOrders![index]);
                        },
                        child: SingleProduct(
                            imageSrc: userOrders![index].products[0].images[0]),
                      ); //showing the index one , it will be a map having products and quantity so , showinng the 0th ie 1st product and its 0th ie the 1st image only
                    }),
              )
            ],
          );
  }
}
