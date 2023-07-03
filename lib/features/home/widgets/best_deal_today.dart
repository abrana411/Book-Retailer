import 'package:flutter/material.dart';

import '../services/home_services.dart';
import '../../../models/product_model.dart';
import '../../../constants/screen_loader.dart';
import '../../product_details/screens/product_detail_screen.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  HomeServices homeServices = HomeServices();
  Product?
      dealProd; //This ca be null until the function is not called in the init , as soon as it returns we will show empty box (if no deal is found) and if there is product then we will show it
  @override
  void initState() {
    super.initState();
    fetchTheDealOfTheDay();
  }

  void fetchTheDealOfTheDay() async {
    dealProd = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (dealProd == null)
        ? const ScreenLoader() //till the detchdealOfDay is not completed (awaiting)
        : (dealProd!.name
                .isEmpty) //(if resolved and got empty prod) then empty container
            ? Container()
            : GestureDetector(
                onTap: () {
                  //Navigate to the produ details screen:-
                  Navigator.pushNamed(context, ProductDetailScreen.routeName,
                      arguments: dealProd);
                },
                child: Column(
                  //else show the deal(product)
                  children: [
                    //Show a text saying deal of the day
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "Deal of the day",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    //Show the main image of the deal
                    Image.network(
                      dealProd!.images[
                          0], //passing the images (0th one for the main display)
                      fit: BoxFit.fitHeight,
                      height: 200,
                    ),
                    //Text to show the price and the below another text to show details about the product in a line (like description of the product)
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 10,
                        bottom: 5,
                      ),
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Rs ${dealProd!.price}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        dealProd!.name,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    //A Row to show the rest images:-
                    SingleChildScrollView(
                      scrollDirection: Axis
                          .horizontal, //using the single child scroll view we can giev the scroll direction to a row too
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: dealProd!.images
                              .map(
                                //Mapping through each of the image and showing them by converting them to a list of widget where widget is the image
                                (image) => Image.network(
                                  image,
                                  fit: BoxFit.fitWidth,
                                  width: 120,
                                  height: 120,
                                ),
                              )
                              .toList()),
                    ),
                    //Text to show , see all deals:-
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "See all deals",
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              );
  }
}
