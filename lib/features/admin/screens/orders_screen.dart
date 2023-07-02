import 'package:a_to_z_shop/features/account/widgets/single_product.dart';
import 'package:a_to_z_shop/features/admin/services/admin_services.dart';
import 'package:a_to_z_shop/features/orderDetails/screens/order_detail_screen.dart';
import 'package:a_to_z_shop/helperConstants/screen_loader.dart';
import 'package:a_to_z_shop/models/order_model.dart';
import 'package:flutter/material.dart';

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
        : GridView.builder(
            //Showing a grid view builder in which i am getting SingleProduct widget and on clicking we will be redrected to order details screen
            itemCount: allOrders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              final orderData = allOrders![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailsScreen.routeName,
                    arguments: orderData,
                  );
                },
                child: SizedBox(
                  height: 140,
                  child: (SingleProduct(
                      imageSrc: orderData.products[0].images[0])),
                ),
              );
            },
          );
  }
}
