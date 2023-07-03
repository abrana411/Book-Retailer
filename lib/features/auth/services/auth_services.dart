import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../models/user_model.dart';
import '../../home/screens/home_screen.dart';
import '../../../providers/user_provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/show_snack_bar.dart';
import '../../../common/widgets/bottom_nav_bar.dart';

class AuthService {
  //signup api calling to the backend:-
  void signUpUser(
      {required BuildContext context,
      required String name,
      required String email,
      required String password}) async {
    try {
      User newUser = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      //will use the http package now to make the post request
      http.Response response = await http.post(
        Uri.parse("${GlobalVariables.initialUrl}/api/signup"),
        body: newUser.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      //Error handling
      if (context.mounted) {
        httphandleError(
            response: response,
            context: context,
            onSuccess: () {
              ShowSnackBar(
                  context: context,
                  text:
                      "Registered successfully!! Please login with same credentials.",
                  color: Colors.green);
            });
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }

  //Singin method:-
  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response response = await http.post(
        Uri.parse("${GlobalVariables.initialUrl}/api/signin"),
        body: json.encode({
          "email": email,
          "password": password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      //Error handling
      if (context.mounted) {
        httphandleError(
            response: response,
            context: context,
            onSuccess: () async {
              Provider.of<UserProvider>(context, listen: false).setUser(response
                  .body); //reponse.body is the json string which we are setting as the current user using the provider

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                  "User_token", json.decode(response.body)['token']);
              if (context.mounted) //for the warning have to do this
              {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    BottomNavBar.routeName, (route) => false);
              }
            });
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }

  //Getting the user data (if token exists)
  void getUserData(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString(
          "User_token"); //getting the user token , but it can be null too , lets say the user has run the app for the very first time , that is the user do not have any tokent then as not logged in before , so wethis will simply give null then
      if (userToken == null) {
        prefs.setString("User_token",
            ""); //setting the value of token to empty string then (instead of null)
      }

      var res = await http.post(
        Uri.parse("${GlobalVariables.initialUrl}/api/verifytoken"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'User_token':
              userToken!, //here the convention is to pass the header authorization and in it the token as "Bearer token" , but here creating a header with the same name as the key in the shared prefs and then using it to pass the token normally
        },
      );

      // print(res.body);
      var response = json.decode(res
          .body); //this res.body will have trur or false based on if the token is valid/verified or not

      if (response == true) {
        //Get the user data if the token is verified and then set the user (in the userprovider class _user data member)
        http.Response userData = await http.get(
          Uri.parse("${GlobalVariables.initialUrl}/api/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'User_token':
                userToken, //have to pass the token in header here too as the middleaware will first again verify that in the backend
          },
        );

        //set the user
        if (context.mounted) {
          // print(userData.body);
          Provider.of<UserProvider>(context, listen: false)
              .setUser(userData.body); //this userData.body is a json string
        }
      }
    } catch (error) {
      ShowSnackBar(context: context, text: error.toString(), color: Colors.red);
    }
  }
}
