import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';
import '../../../constants/show_snack_bar.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';

class SearchService {
  //1)Function to fetch the products having name related to the searched query:-
  Future<List<Product>> getSearchedProduct(
      {required BuildContext context, required String searched}) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    List<Product> prods = [];
    try {
      //Using the get route with query parameter as the category:
      var response = await http.get(
        Uri.parse("${GlobalVariables.initialUrl}/api/product/search/$searched"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': currUser.user.token,
        },
      );

      if (context.mounted) {
        httphandleError(
          response: response,
          context: context,
          onSuccess: () {
            //if no error is there
            for (int i = 0; i < json.decode(response.body).length; i++) {
              prods.add(
                Product.fromJson(
                  jsonEncode(
                    jsonDecode(response.body)[i],
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
    return prods;
  }
}
