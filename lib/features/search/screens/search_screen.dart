import 'package:a_to_z_shop/common/widgets/list_view_prod.dart';
import 'package:flutter/material.dart';

// import '../widgets/show_search_product.dart';
import '../services/search_services.dart';
import '../../../models/product_model.dart';
// import '../../home/widgets/show_user_address.dart';
import '../../../constants/screen_loader.dart';
// import '../../../constants/global_variables.dart';
// import '../../product_details/screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "search_screen-route";
  final String whatIsSearched;
  const SearchScreen({super.key, required this.whatIsSearched});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchService searchService = SearchService();
  List<Product>? searchMatchedProducts;
  @override
  void initState() {
    super.initState();
    getTheSerachedProducts();
  }

  getTheSerachedProducts() async {
    searchMatchedProducts = await searchService.getSearchedProduct(
        context: context, searched: widget.whatIsSearched);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The appbar is of the home screen, because we want the search screen to be on the top always so that could search for other items too
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          // flexibleSpace: Container(
          //   decoration: const BoxDecoration(
          //     gradient: GlobalVariables.appBarGradient,
          //   ),
          // ),
          title: const Text("Find Books"),
          // centerTitle: true,
        ),
      ),
      //In the body we will have a loader if the products are not fetched yet else we will have a listview having all the products shown as we want using a widget which i have created ie the show search product
      body: searchMatchedProducts == null
          ? const ScreenLoader()
          : Column(
              children: [
                // const ShowUserAddress(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        margin: const EdgeInsets.only(left: 15),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 1,
                          child: TextFormField(
                            onFieldSubmitted: (String searched) {
                              if (searched.isNotEmpty) {
                                Navigator.pushNamed(
                                    context, SearchScreen.routeName,
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
                    Container(
                      color: Colors.transparent,
                      height: 42,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                          const Icon(Icons.mic, color: Colors.black, size: 25),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  // child: ListView.builder(
                  //   itemCount: searchMatchedProducts!.length,
                  //   itemBuilder: (context, index) {
                  //     return GestureDetector(
                  //       onTap: () {
                  //         //Navigate to the product details screen from here too:- by passing the current product instance of the product model
                  //         Navigator.pushNamed(
                  //             context, ProductDetailScreen.routeName,
                  //             arguments: searchMatchedProducts![index]);
                  //       },
                  //       child: Container(
                  //         margin: const EdgeInsets.all(8),
                  //         child: ShowSearchProduct(
                  //           product: searchMatchedProducts![index],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  child: ListProd(products: searchMatchedProducts),
                ),
              ],
            ),
    );
  }
}
