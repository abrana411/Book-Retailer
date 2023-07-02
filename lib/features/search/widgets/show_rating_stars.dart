import 'package:a_to_z_shop/helperConstants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShowStars extends StatelessWidget {
  final double prodRating;
  const ShowStars({super.key, required this.prodRating});

  @override
  Widget build(BuildContext context) {
    //using the stars rating package for showing the stars based on the product rating
    return RatingBarIndicator(
      direction: Axis.horizontal, //horizontal stars
      itemSize: 18,
      itemCount: 5, //out of 5 stars
      rating: prodRating, //pass in the product rating
      itemBuilder: (context, _) => const Icon(
        Icons.stars,
        color: GlobalVariables.secondaryColor,
      ), //In the item builder we will describe what to show (so we want to show a star so icon of star)
    );
  }
}
