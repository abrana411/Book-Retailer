import 'package:flutter/material.dart';

import '../widgets/show_rating_stars.dart';
import '../../../models/product_model.dart';

class ShowSearchProduct extends StatelessWidget {
  final Product product;
  const ShowSearchProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    //Getting the average rating of the product to show
    double averageRatingOfProduct = 0;
    double sumOfRatingOfThisPrduct = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      //add to total
      sumOfRatingOfThisPrduct += product.rating![i].rating;
    }

    if (sumOfRatingOfThisPrduct != 0) {
      averageRatingOfProduct = //sunm/length = average
          sumOfRatingOfThisPrduct / product.rating!.length;
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: [
              Image.network(
                product.images[
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
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  //For showing the rating of the product (using a seperate package for this)
                  Container(
                    width: 225,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: ShowStars(
                      prodRating:
                          averageRatingOfProduct, //Showing the rating of this product
                    ),
                  ),
                  //Showing the price of the product
                  Container(
                    width: 225,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'Rs :${product.price}',
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
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
