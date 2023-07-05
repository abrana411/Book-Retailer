import 'package:a_to_z_shop/features/account/widgets/single_product.dart';
import 'package:a_to_z_shop/features/admin/services/admin_services.dart';
import 'package:a_to_z_shop/features/order_details/screens/order_details_screen.dart';
import 'package:a_to_z_shop/constants/screen_loader.dart';
import 'package:a_to_z_shop/models/order_model.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //Similar setup as we didi to fetch list of items
  AdminServices adminServices = AdminServices();
  List<Order>? allOrders;
  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  void fetchAllOrders() async {
    allOrders = await adminServices.fetchAllOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return allOrders == null
        ? const ScreenLoader()
        : Container(
            color: GlobalVariables.greyBackgroundColor,
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: allOrders!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  Order currOrder = allOrders![index];
                  String currstatus = "";
                  if (currOrder.status == 0) {
                    currstatus = "Pending";
                  } else if (currOrder.status == 1) {
                    currstatus = "Shipped";
                  } else if (currOrder.status == 2) {
                    currstatus = "Received";
                  } else {
                    currstatus = "Done";
                  }

                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, OrderDetailsScreen.routeName,
                            arguments: allOrders![index]);
                      },
                      child: Container(
                          // color: GlobalVariables.greyBackgroundColor,
                          padding: const EdgeInsets.all(2),
                          child: Card(
                              child: Column(children: [
                            SizedBox(
                              height: 150,
                              child: SingleProduct(
                                  imageSrc: currOrder.products[0].images[0]),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: [
                                        // Text(
                                        //     "Total Rs : ${currOrder.totalPrice}",
                                        //     style: const TextStyle(
                                        //         fontWeight: FontWeight.w600,
                                        //         fontSize: 13)),
                                        RichText(
                                            text: TextSpan(
                                                text: "Status : ",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                                children: [
                                              TextSpan(
                                                text: currstatus,
                                                style: TextStyle(
                                                    color:
                                                        (currOrder.status >= 3)
                                                            ? Colors.green
                                                            : Colors.orange,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            ]))
                                      ],
                                    ),
                                  ),
                                ])
                          ]))));
                }));
  }
}
