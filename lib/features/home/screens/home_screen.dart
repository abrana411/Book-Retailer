import 'package:a_to_z_shop/constants/screen_loader.dart';

import '../../admin/services/admin_services.dart';
import '../../product_details/services/product_detail_service.dart';
import '../widgets/popular_prod_grid.dart';
import 'package:a_to_z_shop/models/product_model.dart';
import 'package:flutter/material.dart';

// import '../widgets/show_image_slider.dart';
// import '../widgets/show_user_address.dart';
import '../widgets/famous_categories.dart';
import '../../search/screens/search_screen.dart';
// import '../../../constants/global_variables.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchcontroller = TextEditingController();
  List<Product>? allProducts;
  AdminServices _adminServices = AdminServices();
  ProductDetailsService productDetailsServices = ProductDetailsService();

  @override
  void initState() {
    super.initState();
    getTheProds();
  }

  void getTheProds() async {
    allProducts = await _adminServices.getAllProds(context);
    // print(allProducts![0]);
    setState(() {});
  }

  void getProdAddedToCart(Product currProduct, int index) {
    productDetailsServices.addToCartOfUser(
        context: context, product: currProduct);
  }

  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //In the appbar we will be showing a text form field and then a mic icon in a row
        appBar: PreferredSize(
          //using thr preffered size again to give the height to the appb ar
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            //flexible space for giving the gradient
            // flexibleSpace: Container(
            //   decoration: const BoxDecoration(
            //     gradient: GlobalVariables.appBarGradient,
            //   ),
            // ),

            title: const Text("Home"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(left: 15),
                      child: Material(
                        //A material widget is used for simply providing us with border radius ,(which we could have gotten by wrapping in a container too) and the elevation as we want this container to stand out (which is having thr text field) , and this elevation was not in the container so thats why used this
                        borderRadius: BorderRadius.circular(20),
                        elevation: 1,
                        child: TextFormField(
                          controller: _searchcontroller,
                          //field for searching some items , and onfieldSubmitted method will call whatever function is given with the serached text into it as an parameter automatically when the user presses enter(or tap done), so we will redirect the user to the search screen in this case
                          onFieldSubmitted: (String searched) {
                            if (searched.isNotEmpty) {
                              Navigator.pushNamed(
                                  context, SearchScreen.routeName,
                                  arguments: searched);
                            }
                          },
                          decoration: InputDecoration(
                            //inkwell for showing the ripple effect on tapping on the search icon(else there was no use of this, could add the navigaton to search screen on this icon too , but for now it is only happening when the user press enter(or done))
                            prefixIcon: InkWell(
                              onTap: () {
                                if (_searchcontroller.text.isNotEmpty) {
                                  Navigator.pushNamed(
                                      context, SearchScreen.routeName,
                                      arguments: _searchcontroller.text);
                                }
                              },
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
                            //some other decoratons
                            filled:
                                true, //if true then the decoration container will have fill color
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
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
                  //for showing the mic button
                  Container(
                    color: Colors.transparent,
                    height: 42,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Icon(Icons.mic, color: Colors.black, size: 25),
                  ),
                ],
              ),
              // ShowUserAddress(),
              const SizedBox(
                height: 10,
              ),
              const FamCategories(),
              const SizedBox(
                height: 10,
              ),
              // const ImageSlider(),
              const SizedBox(
                height: 10,
              ),
              // DealOfTheDay(),
              Container(
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.only(left: 20, bottom: 5),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Popular",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              (allProducts == null)
                  ? const ScreenLoader()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: PopularProducts(
                        products: allProducts,
                        isDelete: false,
                        func: (Product prod, int index) =>
                            getProdAddedToCart(prod, index),
                      )),
            ],
          ),
        ));
  }
}
