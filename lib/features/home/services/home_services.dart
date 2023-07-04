import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/show_snack_bar.dart';
import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';

class HomeServices {
  //1)Function to fetch the products belonging to this category:-
  Future<List<Product>> getTheProdsOfTheCategory(
      {required BuildContext context, required String category}) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    List<Product> prods = [];
    try {
      //Using the get route with query parameter as the category:
      var response = await http.get(
        Uri.parse(
            "${GlobalVariables.initialUrl}/api/product?category=$category"),
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

  //2)Function to get the best deal of the day:-
  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    //Creating a product instance , so that the product should not be null in case if no product in the data base then the API might return an array , so we will return this empty product only then , so that in the deals of the day section we could show an empty box , rather than showing loader all the time, else if products are there then we will update this product to the one which we will get from the API
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      sellerId: '',
      price: 0,
    );

    try {
      http.Response res = await http.get(
          Uri.parse('${GlobalVariables.initialUrl}/api/best-deal'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': userProvider.user.token,
          });

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess: () {
            // print("This is body: " + res.body);

            // print(res.body);
            if (res.body.isNotEmpty) {
              product = Product.fromJson(
                  res.body); //Updating the product in case we get from API
            }
          },
        );
      }
    } catch (e) {
      // print(e);
      ShowSnackBar(context: context, text: e.toString(), color: Colors.red);
    }
    return product; //returning the product (This will never be null , can have all fields empty thiugh as we declared a initial one)
  }
}
