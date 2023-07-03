import 'package:a_to_z_shop/features/account/screens/add_products_screen.dart';
import 'package:a_to_z_shop/features/account/services/account_services.dart';
import 'package:a_to_z_shop/features/account/widgets/single_product.dart';
import 'package:a_to_z_shop/features/product_details/screens/product_detail_screen.dart';
import 'package:a_to_z_shop/constants/global_variables.dart';
import 'package:a_to_z_shop/constants/screen_loader.dart';
import 'package:a_to_z_shop/models/product_model.dart';
import 'package:flutter/material.dart';

class SellProductsScreen extends StatefulWidget {
  static const String routeName = "/sell-products";
  const SellProductsScreen({super.key});

  @override
  State<SellProductsScreen> createState() => _SellProductsScreenState();
}

class _SellProductsScreenState extends State<SellProductsScreen> {
  List<Product>? userListedProducts = [];
  AccountServices accountServices = AccountServices();

  @override
  void initState() {
    listedProducts();
    super.initState();
  }

  //Fethcing the user orders and also storing them into list (till then we will show a loader)
  void listedProducts() async {
    userListedProducts =
        await accountServices.fetchListedProducts(context: context);
    // print(userListedProducts!.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: userListedProducts == null
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 20,
                      ),
                      alignment: Alignment.center,
                      child: ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        itemCount: userListedProducts!.length,
                        // itemBuilder: (context, index) {
                        //   return GestureDetector(
                        //     onTap: () {
                        //       //Navigate to the order details screen by passing the current order
                        //       Navigator.pushNamed(
                        //           context, OrderDetailsScreen.routeName,
                        //           arguments: userListedProducts![index]);
                        //     },
                        //     child: SingleProduct(
                        //       // imageSrc: userListedProducts![index]
                        //       //     .products[0]
                        //       //     .images[0],
                        //       imageSrc: userListedProducts![index].images[0],
                        //     ),
                        //   ); //showing the index one , it will be a map having products and quantity so , showinng the 0th ie 1st product and its 0th ie the 1st image only
                        // },
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              ProductDetailScreen.routeName,
                            ),
                            // leading: CircleAvatar(
                            //   foregroundImage: Image.network(
                            //     userListedProducts![index].images[0],
                            //   ),
                            // ),
                            title: Text(userListedProducts![index].name),
                            subtitle:
                                Text(userListedProducts![index].description),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          AddProductScreen.routeName,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
