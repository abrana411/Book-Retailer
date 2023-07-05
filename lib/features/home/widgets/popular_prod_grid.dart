import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../../models/product_model.dart';
import '../../account/widgets/single_product.dart';
import '../../product_details/screens/product_detail_screen.dart';
// import '../../product_details/services/product_detail_service.dart';

class PopularProducts extends StatelessWidget {
  final List<Product>? products;
  final bool isDelete;
  final Function(Product, int index) func;
  final bool isApproved;
  const PopularProducts(
      {super.key,
      required this.products,
      required this.isDelete,
      required this.func,
      this.isApproved = false});

  Widget getText(String text) {
    if (text.length <= 9) {
      // Return the full text if it's shorter or equal to the maxLength
      return Text(text);
    } else {
      // Apply truncation and show limited text
      final limitedText = text.substring(0, 9);
      return Text.rich(
        TextSpan(
          text: limitedText,
          children: const [
            TextSpan(
              text: '...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: min(products!.length, 10),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                  SizedBox(
                    height: 150,
                    child: SingleProduct(imageSrc: currProduct.images[0]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            getText(currProduct.name),
                            Text("Rs : ${currProduct.price.toString()}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        margin: (!isApproved && isDelete)
                            ? const EdgeInsets.only(right: 5)
                            : const EdgeInsets.only(right: 15),
                        height: 35,
                        width: 35,
                        child: TextButton(
                          onPressed: () {
                            if (isDelete) {
                              func(currProduct, index);
                            } else {
                              func(currProduct, index);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDelete ? Colors.white : Colors.red,
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                    color: GlobalVariables.secondaryColor,
                                    width: 3)),
                          ),
                          child: isDelete
                              ? isApproved
                                  ? const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    )
                              : const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                      if (isDelete && !isApproved)
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 35,
                          width: 35,
                          child: TextButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isDelete ? Colors.white : Colors.red,
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: GlobalVariables.secondaryColor,
                                        width: 3)),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.blue,
                                size: 20,
                              )),
                        ),
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
    );
  }
}
