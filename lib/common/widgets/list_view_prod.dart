// import 'dart:math';

import 'package:a_to_z_shop/common/widgets/custom_button.dart';
import 'package:a_to_z_shop/constants/global_variables.dart';
import 'package:a_to_z_shop/models/product_model.dart';
import 'package:flutter/material.dart';

// import '../../features/account/widgets/single_product.dart';
import '../../features/product_details/screens/product_detail_screen.dart';
import '../../features/product_details/services/product_detail_service.dart';

class ListProd extends StatelessWidget {
  final List<Product>? products;
  const ListProd({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    ProductDetailsService productDetailsServices = ProductDetailsService();
    return ListView.builder(
      itemCount: products!.length,
      itemBuilder: (context, index) {
        Product currProduct = products![index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments: products![index]);
          },
          child: Container(
            color: GlobalVariables.greyBackgroundColor,
            padding: const EdgeInsets.all(2),
            child: Card(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 13, bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Image.network(
                        currProduct.images[
                            0], //only first photo (rest will show only when the details of the products are shown)
                        fit: BoxFit.contain,
                        height: 140,
                        width: 140,
                      ),
                      Column(
                        //This column is containing 5 ciolumns:-
                        //Below is for showing the product name
                        children: [
                          Container(
                            width: 225,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              currProduct.name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 2,
                            ),
                          ),

                          //Showing the price of the product
                          Container(
                            width: 225,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Text(
                              'Rs :${currProduct.price}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                            ),
                          ),

                          //Whether in stock or not
                          Container(
                            width: 225,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: const Text(
                              'In Stock',
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            // margin: const EdgeInsets.only(left: 40),
                            width: 150,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: CustomButton(
                                toShow: "Add to cart",
                                onTap: () {
                                  productDetailsServices.addToCartOfUser(
                                      context: context, product: currProduct);
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
        );
      },
    );
  }
}
