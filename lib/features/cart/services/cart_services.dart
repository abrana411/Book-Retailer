import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../models/user_model.dart';
import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';
import '../../../constants/show_snack_bar.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';

class CartServices {
  //1)Function to delete a product (quantity wise) from a cart of current user:-
  void deleteFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    try {
      var response = await http.delete(
          Uri.parse(
              "${GlobalVariables.initialUrl}/api/delete-from-cart/${product.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': currUser.user.token,
          });

      if (context.mounted) {
        httphandleError(
          response: response,
          context: context,
          onSuccess: () {
            //Here we will update the user model first , ie using a user model which is in the provider and using all its value and just updating the cart to the cart we have now, using the copyWith method we created for a userModel which simply keeps the fields as it is that are not passed as parameter and for the rest of the field (which are passed in the parameter) it will rewrite those, so we will do that only by passing cart only
            User updatedUser = currUser.user.copyWith(
              cart: jsonDecode(response.body)['cart'],
            );
            currUser.setUserUsingModel(updatedUser);
          },
        );
      }
    } catch (error) {
      // print(error);
      ShowSnackBar(
        context: context,
        text: error.toString(),
        color: Colors.red,
      );
    }
  }
}
