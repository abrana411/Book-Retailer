import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../constants/global_variables.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      //The items in this widget (package) takes a list of widgets , so mapping through each image of the carousel , we will be returning a image.network() inside a builder as shown (because this is how it works as written in the documenttation of the package)
      items: GlobalVariables.carouselImages.map((item) {
        return Builder(builder: (BuildContext context) {
          return Image.network(
            item,
            fit: BoxFit.cover,
            height: 180,
          );
        });
      }).toList(),
      options: CarouselOptions(
        viewportFraction:
            1, //this means whole width of the screen for single item in the items list of widgets given above , ie each image will take wntire width and the height here below is same as what i gave in the Image.network()
        height: 180,
      ),
    );
  }
}
