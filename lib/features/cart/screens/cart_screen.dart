import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../search/screens/search_screen.dart';
// import '../../../constants/global_variables.dart';
import '../../../common/widgets/custom_button.dart';
import '../../address/screens/address_screen.dart';
import '../widgets/cart_products.dart';
// import '../../home/widgets/show_user_address.dart';
import '../../../providers/user_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    //Calculating the sum of the amount of product in the cart (to show as the total price)
    final currUser = Provider.of<UserProvider>(context).user;
    int totalSum = 0;
    for (int i = 0; i < currUser.cart.length; i++) {
      totalSum += (currUser.cart[i]['product']['price'] *
              currUser.cart[i]['quantity']
          as int); //each product with its price * quantity and add it into the sum
    }
    return Scaffold(
      //The appbar is same (of the search bar type , used in he home and other screens too)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
            // flexibleSpace: Container(
            //   decoration: const BoxDecoration(
            //     gradient: GlobalVariables.appBarGradient,
            //   ),
            // ),
            title: const Text("My Cart")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
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
                  child: const Icon(Icons.mic, color: Colors.black, size: 25),
                ),
              ],
            ),
            //Showing the user address using the same widget we have created
            // const ShowUserAddress(),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text.rich(
                TextSpan(
                  text: "Total Amount ",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  children: [
                    TextSpan(
                        text: "Rs: $totalSum",
                        style: const TextStyle(color: Colors.red))
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                toShow: 'Proceed to Buy (${currUser.cart.length} items)',
                onTap: () {
                  //Navigating to the address screen:
                  Navigator.pushNamed(context, AddressScreen.routeName,
                      arguments: totalSum.toString());
                },
                btnColor: const Color.fromARGB(255, 253, 110, 53),
              ),
            ),
            const SizedBox(height: 15),
            // Container(
            //   color: Colors.black12.withOpacity(0.08),
            //   height: 1,
            // ),
            const SizedBox(height: 5),
            ListView.builder(
              itemCount: currUser.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return EachCartProd(
                  prodIndex: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
