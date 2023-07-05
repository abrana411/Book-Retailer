import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    // print(userOrders!.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return userOrders == null
        ? const ScreenLoader()
        // : Column(
        //     children: [
        //       //Row with two texts as a container each
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Container(
        //             padding: const EdgeInsets.only(
        //               left: 15,
        //             ),
        //             child: const Text(
        //               'My Orders',
        //               style: TextStyle(
        //                 fontSize: 18,
        //                 fontWeight: FontWeight.w600,
        //               ),
        //             ),
        //           ),
        //           Container(
        //             padding: const EdgeInsets.only(
        //               right: 15,
        //             ),
        //             child: Text(
        //               'See all',
        //               style: TextStyle(
        //                 color: GlobalVariables.selectedNavBarColor,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       //container to display all the orders (as it has a list view.builder in horizontal direction)
        //       Container(
        //         padding: const EdgeInsets.only(
        //           left: 10,
        //           top: 20,
        //         ),
        //         height: 200,
        //         child: ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             itemCount: userOrders!.length,
        //             itemBuilder: (context, index) {
        //               return GestureDetector(
        //                 onTap: () {
        //                   //Navigate to the order details screen by passing the current order
        //                   Navigator.pushNamed(
        //                       context, OrderDetailsScreen.routeName,
        //                       arguments: userOrders![index]);
        //                 },
        //                 child: SingleProduct(
        //                     imageSrc: userOrders![index].products[0].images[0]),
        //               ); //showing the index one , it will be a map having products and quantity so , showinng the 0th ie 1st product and its 0th ie the 1st image only
        //             }),
        //       )
        //     ],
        //   );
        : Container(
            color: GlobalVariables.greyBackgroundColor,
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: userOrders!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                Order currOrder = userOrders![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailsScreen.routeName,
                        arguments: userOrders![index]);
                  },
                  child: Container(
                    // color: GlobalVariables.greyBackgroundColor,
                    padding: const EdgeInsets.all(2),
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 150,
                            child: SingleProduct(
                                imageSrc: currOrder.products[0].images[0]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children: [
                                    Text("Total Rs : ${currOrder.totalPrice}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                              // Container(
                              //   margin: const EdgeInsets.only(right: 15),
                              //   height: 35,
                              //   width: 35,
                              //   child: TextButton(
                              //     onPressed: () {

                              //     },
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: Colors.red,
                              //       shape: RoundedRectangleBorder(
                              //           //to set border radius to button
                              //           borderRadius: BorderRadius.circular(20),
                              //           side: const BorderSide(
                              //               color: GlobalVariables.secondaryColor,
                              //               width: 3)),
                              //     ),
                              //     child: isDelete
                              //         ? const Icon(
                              //             Icons.delete,
                              //             color: Colors.red,
                              //             size: 20,
                              //           )
                              //         : const Icon(
                              //             Icons.add,
                              //             color: Colors.white,
                              //             size: 20,
                              //           ),
                              //   ),
                              // ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
