import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/show_snack_bar.dart';
import '../../../models/order_model.dart';
import '../../../providers/user_provider.dart';
// import '../../auth/screens/auth_screen.dart';
import '../../auth/screens/login_screen.dart';
import '../../../constants/error_handling.dart';
import '../../../models/product_model.dart';
import '../../../constants/global_variables.dart';

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

  Future<List<Product>> fetchListedProducts({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> listedProducts = [];
    try {
      http.Response res = await http.get(
        Uri.parse('${GlobalVariables.initialUrl}/api/getListedProducts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': userProvider.user.token,
        },
      );

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              listedProducts.add(
                Product.fromJson(
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
    // print(listedProducts[listedProducts.length - 1].toJson());
    return listedProducts;
  }

  void listProduct({
    required String prodName,
    required String description,
    required double price,
    required double quantity,
    required List<File> prodImages,
    required String category,
    required BuildContext context,
  }) async {
    try {
      final userModel = Provider.of<UserProvider>(context, listen: false);
      final cloudinaryIns = CloudinaryPublic("duwvms9cy", "qyipmg35");
      List<String> imageUrls = [];
      for (int i = 0; i < prodImages.length; i++) {
        CloudinaryResponse responseAfterUpload = await cloudinaryIns.uploadFile(
          CloudinaryFile.fromFile(
            prodImages[i].path,
            folder: prodName,
          ),
        );
        imageUrls.add(responseAfterUpload.secureUrl);
      }

      //Now creating the model we will be posting to the mongodb:-
      Product newProduct = Product(
        name: prodName,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      //http post req:-
      var res = await http.post(
        Uri.parse("${GlobalVariables.initialUrl}/api/listProduct"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': userModel.user.token,
        },
        body: newProduct.toJson(),
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

  Future<bool> deleteProduct({
    required BuildContext context,
    required String productId,
    VoidCallback? func,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      var res = await http.delete(
        Uri.parse('${GlobalVariables.initialUrl}/api/$productId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token': userProvider.user.token,
        },
      );

      if (context.mounted) {
        httphandleError(
          response: res,
          context: context,
          onSuccess: () {
            func!();
            ShowSnackBar(
                context: context,
                text: "Product deleted successfully!!",
                color: Colors.green);
          },
        );
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
      return false;
    }
    return true;
  }

  //Function to log out the user:
  void logOutUser(BuildContext context, bool isGoogleSignOut) async {
    try {
      if (isGoogleSignOut) {
        // print("arre bhai sab");
        await GoogleSignIn().signOut();
      }

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("User_token", "");
      if (context.mounted) {
        //Push to the authscreen after removing the token
        Navigator.pushNamedAndRemoveUntil(
          context,
          // AuthScreen.routeName,
          LogInScreen.routeName,
          (route) => false,
        );
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }
}
