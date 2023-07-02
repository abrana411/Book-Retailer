import 'package:a_to_z_shop/features/home/services/home_services.dart';
import 'package:a_to_z_shop/features/prodDetails/screens/product_detail_screen.dart';
import 'package:a_to_z_shop/helperConstants/screen_loader.dart';
import 'package:a_to_z_shop/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../helperConstants/global_variables.dart';

class SingleCategoryScreen extends StatefulWidget {
  static const String routeName = "/cat-screen";
  final String category;
  const SingleCategoryScreen({super.key, required this.category});

  @override
  State<SingleCategoryScreen> createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  //Doing preety similar thing as done in the product fetch for the admin screen , can see there for comments
  HomeServices homeServices = HomeServices();
  List<Product>? prodsOfThisCat;
  @override
  void initState() {
    super.initState();
    fetTheProdsOfThisCat();
  }

  fetTheProdsOfThisCat() async {
    prodsOfThisCat = await homeServices.getTheProdsOfTheCategory(
        context: context, category: widget.category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Using similar style appbar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          //Giving time name as rhe category the user wants to see the products from (getting from the constructor)
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      //In a silimar fashion as of the admin product screen showing the loader if the products are not fetched yet else will show the content
      body: prodsOfThisCat == null
          ? const ScreenLoader()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Currently available items in ${widget.category}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 170,
                  //A normal grid view builder to show the image and below it a text displaying the name of the product for each product of this category
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 15),
                    itemCount: prodsOfThisCat!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = prodsOfThisCat![index];
                      //On tapping the product the user will be redirected to the details of a single product page
                      return GestureDetector(
                        onTap: () {
                          //Navigate to the product details page:-
                          Navigator.pushNamed(
                              context, ProductDetailScreen.routeName,
                              arguments:
                                  product); //passing the current product too
                        },
                        child: Column(
                          //column having image and then text showing the title of the image:
                          children: [
                            SizedBox(
                              height: 130,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 0.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.network(
                                    product.images[0],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(
                                left: 0,
                                top: 5,
                                right: 15,
                              ),
                              child: Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
