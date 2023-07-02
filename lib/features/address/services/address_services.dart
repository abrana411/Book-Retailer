import 'dart:convert';

import 'package:a_to_z_shop/helperConstants/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../helperConstants/global_variables.dart';
import '../../../helperConstants/show_snack_bar.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';

class AddressServices {
  //1)Function to amke API call to add/update the address of the user:
  void addUserAddress(
      {required BuildContext context, required String addressToAdd}) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    try {
      var response = await http.post(
          Uri.parse("${GlobalVariables.initialUrl}/api/add-address"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': currUser.user.token,
          },
          body: jsonEncode({"address": addressToAdd}));

      if (context.mounted) {
        httphandleError(
            response: response,
            context: context,
            onSuccess: () {
              //Get updated use model instance , by changing the address in the providers current modeel and then setting that model as the current model
              User newUserWithUpdatedAddress = currUser.user
                  .copyWith(address: jsonDecode(response.body)['address']);
              currUser.setUserUsingModel(newUserWithUpdatedAddress);
            });
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }

  //2)Function to place an order:-
  void PlaceanOrder(
      {required BuildContext context,
      required String addressToAdd,
      required double totalPrice}) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    try {
      var response = await http.post(
          Uri.parse("${GlobalVariables.initialUrl}/api/placedOrder"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': currUser.user.token,
          },
          body: jsonEncode({
            "address": addressToAdd,
            "totalPrice": totalPrice,
            "cart": currUser.user.cart
          }));

      if (context.mounted) {
        httphandleError(
            response: response,
            context: context,
            onSuccess: () {
              //make cart empty and update the user provoder model
              User newUserWithUpdatedAddress = currUser.user.copyWith(cart: []);
              currUser.setUserUsingModel(newUserWithUpdatedAddress);

              //show snackbar (for the order has been placed successfully)
              ShowSnackBar(
                  context: context,
                  text: "The order has been placed successfully!!",
                  color: Colors.green);
            });
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }
}
