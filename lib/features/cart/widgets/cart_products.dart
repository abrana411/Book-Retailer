import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cart_services.dart';
import '../../product_details/services/product_detail_service.dart';
import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';

class EachCartProd extends StatefulWidget {
  final int prodIndex;
  const EachCartProd({super.key, required this.prodIndex});

  @override
  State<EachCartProd> createState() => _EachCartProdState();
}

class _EachCartProdState extends State<EachCartProd> {
  ProductDetailsService productDetailsService = ProductDetailsService();
  CartServices cartServices = CartServices();
  @override
  Widget build(BuildContext context) {
    //Getting the current user:
    final currUser = Provider.of<UserProvider>(context).user;
    Product currProd = Product.fromMap(currUser.cart[widget.prodIndex][
        'product']); //we could have kept the product as currUser.cart[widget.prodIndex]['product'] but then to access the product things have to use the map notation which would be like prod['price], but if we convert this into a model then we can use the class notation of the porduct model like prod.price
    final currProdQuantityInCart = currUser.cart[widget.prodIndex]['quantity'];
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Image.network(
                currProd.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                //Belos is using the similar containers as used in the search screen result
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      currProd.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'Rs: ${currProd.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text('Eligible for FREE Shipping'),
                  ),
                  Container(
                    width: 235,
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
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12,
                ),
                child: Row(
                  //Three row like ->  minus button , current quantity , plus button
                  children: [
                    InkWell(
                      //Decrease the quantity button
                      onTap: () {
                        cartServices.deleteFromCart(
                            context: context, product: currProd);
                      },
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      //Decorated box is used to get the box decoration without container
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.5),
                        color: const Color.fromARGB(255, 167, 219, 230),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        color: const Color.fromARGB(255, 149, 222, 212),
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          currProdQuantityInCart.toString(),
                        ),
                      ),
                    ),
                    //Adding the quantity button:-
                    InkWell(
                      onTap: () {
                        //This add to cart has logic to increse the qualtity too
                        productDetailsService.addToCartOfUser(
                            context: context, product: currProd);
                      },
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
