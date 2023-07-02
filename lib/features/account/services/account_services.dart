import 'dart:convert';

import 'package:a_to_z_shop/features/auth/screens/authscreen.dart';
import 'package:a_to_z_shop/helperConstants/error_handling.dart';
import 'package:a_to_z_shop/helperConstants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helperConstants/show_snack_bar.dart';
import '../../../models/order_model.dart';
import '../../../providers/user_provider.dart';

class AccountServices {
  //1)Function to fetch the user orders (exactly similat to how we fethhed the category items and the searched items)
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      //a get request(no need to send anything as the user id will be there in the user.res (because of tokens payload))
      http.Response res = await http.get(
          Uri.parse('${GlobalVariables.initialUrl}/api/getUserOrder'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': userProvider.user.token,
          });

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess: () {
            //Eaxctly same when we fethced the products bs yaha pe instead of product model we have used the orders model for converting the data we are getting to the order model
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList.add(
                Order.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
    return orderList;
  }

  //Function to log out the user:
  void logOutUser(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("User_token", "");
      if (context.mounted) {
        //Push to the authscreen after removing the token
        Navigator.pushNamedAndRemoveUntil(
            context, AuthScreen.routeName, (route) => false);
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }
}
