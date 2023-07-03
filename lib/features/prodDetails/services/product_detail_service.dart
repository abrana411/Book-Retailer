import 'dart:convert';

import 'package:a_to_z_shop/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constant/error_handling.dart';
import '../../../constant/global_variables.dart';
import '../../../constant/show_snack_bar.dart';
import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';

class ProductDetailsService {
  //1)Function to rate a product:-
  void rateThisProduct(
      {required BuildContext context,
      required Product product,
      required double rating}) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    try {
      var response = await http.post(
          Uri.parse("${GlobalVariables.initialUrl}/api/rateProd"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': currUser.user.token,
          },
          //we will pass the current product id and the rating to the API at the server side
          body: jsonEncode({"id": product.id!, "rating": rating}));

      if (context.mounted) {
        httphandleError(response: response, context: context, onSuccess: () {});
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }

  //2)Function to add a product to cart of current user:-
  void addToCartOfUser({
    required BuildContext context,
    required Product product,
  }) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    try {
      var response = await http.post(
          Uri.parse("${GlobalVariables.initialUrl}/api/add-to-cart"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': currUser.user.token,
          },
          body: jsonEncode({"id": product.id!})); //only id is needed here

      if (context.mounted) {
        httphandleError(
            response: response,
            context: context,
            onSuccess: () {
              //Here we will update the user model first , ie using a user model which is in the provider and using all its value and just updating the cart to the cart we have now, using the copyWith method we created for a userModel which simply keeps the fields as it is that are not passed as parameter and for the rest of the field (which are passed in the parameter) it will rewrite those, so we will do that only by passing cart only
              User updatedUser = currUser.user.copyWith(
                  cart: jsonDecode(response.body)[
                      'cart']); // decoding the json string to a amp and then apssing the cart from it
              //Updating the _user (current user) in the provider:
              currUser.setUserUsingModel(updatedUser);
            });
      }
    } catch (error) {
      // print(error);
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }
}
