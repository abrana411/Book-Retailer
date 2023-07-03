import 'package:a_to_z_shop/common/widgets/custom_button.dart';
import 'package:a_to_z_shop/features/prodDetails/services/product_detail_service.dart';
import 'package:a_to_z_shop/features/search/screens/search_screen.dart';
import 'package:a_to_z_shop/features/search/widgets/show_rating_stars.dart';
import 'package:a_to_z_shop/models/product_model.dart';
import 'package:a_to_z_shop/models/user_model.dart';
import 'package:a_to_z_shop/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../constant/global_variables.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = "/Prod_details_screen";
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailsService productDetailsServices = ProductDetailsService();
  double currUserRating =
      0; //this will be set to the current users rating to this product (in case the user has given a rating to this product in past)
  double averageRatingOfProduct = 0; //will calculate it in the intiState
  @override
  void initState() {
    super.initState();
    //Get the sum of rating this product has received
    double SumOfRatingOfThisPrduct = 0;
    User currUser = Provider.of<UserProvider>(context, listen: false).user;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      //add to total
      SumOfRatingOfThisPrduct += widget.product.rating![i].rating;

      //check if the current rating is of the current user , because if it is then we will assign it to the currUserRating
      if (currUser.id == widget.product.rating![i].userId) {
        currUserRating = widget.product.rating![i].rating;
      }
    }

    if (SumOfRatingOfThisPrduct != 0) {
      averageRatingOfProduct = //sunm/length = average
          SumOfRatingOfThisPrduct / widget.product.rating!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Exactly same app bar as the home page and the search screen/page
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: (String searched) {
                        if (searched.isNotEmpty) {
                          Navigator.pushNamed(context, SearchScreen.routeName,
                              arguments: searched);
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search for any product..',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              //Row to show id on one end and the rating on other
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.id!,
                  ),
                  ShowStars(
                    prodRating:
                        averageRatingOfProduct, //showing the average rating of the product
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            CarouselSlider(
              //Using the carousle slider to show all the images of this current product, and this slider we have discussed how and what parameter to pass in the home screen ui
              //and also here the map will be on the produst.images
              items: widget.product.images.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 250,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              thickness: 2.5,
              color: Color.fromARGB(255, 236, 225, 225),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' Rs : ${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 54, 127, 244),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ), //showing the description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              thickness: 2.5,
              color: Color.fromARGB(255, 236, 225, 225),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                toShow: 'Buy Now',
                onTap: () {},
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                toShow: 'Add to Cart',
                onTap: () {
                  //Adding the product to the cart of the user:
                  productDetailsServices.addToCartOfUser(
                      context: context, product: widget.product);
                },
                btnColor: const Color.fromRGBO(254, 216, 19,
                    1), //This color is optional , if not given then primary (which we set to golden type will be shown)
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              thickness: 2.5,
              color: Color.fromARGB(255, 236, 225, 225),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Rate The Product : ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //The ratingBarIndicator was for view only , below is to give rating ie we can tap on the start and it will change (it is not view only it is editable by tapping)
                RatingBar.builder(
                  itemSize: 25,
                  //As the initial rating we will show the average rating this product has received
                  initialRating:
                      currUserRating, //passing the rating of current user (if rated sometime in past)
                  minRating: 1, //min 1 can be given (cant give 0)
                  direction: Axis.horizontal, //horizontal rating bar
                  allowHalfRating:
                      true, //double ratings are given so half should be applied too
                  itemCount: 5, //out of 5 stars

                  itemBuilder: (context, _) => const Icon(
                    //Star icon to show
                    Icons.star,
                    color: GlobalVariables.secondaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    //whenever the user taps on the rating (start icons in this case) then it will update and then the updated value will come here in this method and here we will call the update rating API call in the service
                    productDetailsServices.rateThisProduct(
                        context: context,
                        product: widget.product,
                        rating: rating);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
