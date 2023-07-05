import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/sale_model.dart';
import '../../../models/order_model.dart';
import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/show_snack_bar.dart';
import '../../../constants/global_variables.dart';

class AdminServices {
  //1)Function to sell the product (ie we admin wants to sell some new products , ie when add them from the add product to sell screen)
  void sellNewProduct({
    required String prodName,
    required String description,
    required double price,
    required double quantity,
    required List<File> prodImages,
    required String category,
    required String sellerId,
    required BuildContext context,
  }) async {
    try {
      final userModel = Provider.of<UserProvider>(context, listen: false);
      final cloudinaryIns = CloudinaryPublic("duwvms9cy", "qyipmg35");
      List<String> ImageUrls = [];
      for (int i = 0; i < prodImages.length; i++) {
        CloudinaryResponse responseAfterUpload = await cloudinaryIns.uploadFile(
            CloudinaryFile.fromFile(prodImages[i].path, folder: prodName));
        ImageUrls.add(responseAfterUpload.secureUrl);
      }

      //Now creating the model we will be posting to the mongodb:-
      Product newProd = Product(
        name: prodName,
        description: description,
        quantity: quantity,
        images: ImageUrls,
        category: category,
        price: price,
        sellerId: sellerId,
      );

      //http post req:-
      var res = await http.post(
        Uri.parse("${GlobalVariables.initialUrl}/admin/add-product-to-sell"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': userModel.user.token,
        },
        body: newProd.toJson(),
      );

      if (context.mounted) {
        httphandleError(
            response: res,
            context: context,
            onSuccess: () {
              ShowSnackBar(
                  context: context,
                  text: "Product added successfully!!",
                  color: Colors.green);
              Navigator.pop(context);
            });
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }

  //2)Get all the poducts from the db:
  Future<List<Product>> getAllProds(BuildContext context) async {
    final currUser = Provider.of<UserProvider>(context, listen: false);
    List<Product> prods = [];
    try {
      var response = await http.get(
        Uri.parse("${GlobalVariables.initialUrl}/api/getAll"),
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
              //above json.decode or jsonDecode(both are same) will convert the json string which we are getting from the api to a iterable and from ith index we can get the product, but to convert the product into a Product instance we have to use fromjson() which takes a json string so , we again have to use the json.encode() at the outer side
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

  //3)Function to delete a product:-
  void deleteAProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback
        ondeletion, //Getting this callback so that when the product is deleted successfully then we could run this callback in the product screen and call set state after deleting it from the list in fronend too to upadte the list, so that in the client side too the deletion will be updated in real tijme without refreshin page
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        //this is a delete request
        Uri.parse('${GlobalVariables.initialUrl}/admin/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': userProvider.user.token,
        },
        body: jsonEncode({
          //passing the id of the product
          'id': product.id,
        }),
      );

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess: () {
            ondeletion(); //If no error is there then simply call this callback function
          },
        );
      }
    } catch (e) {
      ShowSnackBar(context: context, text: e.toString(), color: Colors.red);
    }
  }

  //4)Fetch all orders:
  Future<List<Order>> fetchAllOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
          Uri.parse('${GlobalVariables.initialUrl}/admin/getAllOrders'),
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

  //5)Function to change the current status of an order:-
  void changeOrderStatus({
    required BuildContext context,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${GlobalVariables.initialUrl}/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': userProvider.user.token,
        },
        //using the order id we will set the status to the status+1
        body: jsonEncode({
          'id': order.id,
        }),
      );

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess:
              onSuccess, //this method will ru when api is called so that we can change the current status in the UI too in real time
        );
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }

  //6)Function to get the data used for analytics:-
  Future<Map<String, dynamic>> getAnalyticsData({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sale> sales = [];
    int totalEarning = 0;
    try {
      http.Response res = await http.get(
          Uri.parse('${GlobalVariables.initialUrl}/admin/analytics'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token': userProvider.user.token,
          });

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess: () {
            //Here we will create a list of the Sale for each category we are getting as the response from the API:-
            final response = jsonDecode(res.body);
            //The name in the square bracket should match with the name in the response sent from the server side
            totalEarning = response['totalEarnings'];
            sales = [
              Sale('Mobiles', response['mobileEarnings']),
              Sale('Essentials', response['essentialEarnings']),
              Sale('Books', response['booksEarnings']),
              Sale('Appliances', response['applianceEarnings']),
              Sale('Fashion', response['fashionEarnings']),
            ];
          },
        );
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
    //Returning the map
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  Future<Map<dynamic, dynamic>> getAnalyticsOfListedProducts({
    required BuildContext context,
  }) async {
    var obj = {};
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('${GlobalVariables.initialUrl}/admin/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': userProvider.user.token,
        },
      );

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess: () => obj = jsonDecode(res.body),
          //Here we will create a list of the Sale for each category we are getting as the response from the API:-
        );
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
    return obj;
  }
}
