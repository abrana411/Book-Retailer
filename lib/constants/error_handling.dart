import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './show_snack_bar.dart';

void httphandleError({
  required http.Response
      response, //(the response which we are getting from the call , will be needed to check the status code which will determine wherther it was a successful request or not)
  required BuildContext
      context, //(this is needed to show come snackbar displaying there was some error)
  required VoidCallback
      onSuccess, //If the request(http one) was successfull then what do to (this will differ for each request so have to have this function here)
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      ShowSnackBar(
          context: context,
          text: jsonDecode(response.body)['errMsg'],
          color: Colors
              .red); //this errMsg is the name of the key that we are sending in the response from the backend when there is an error
      break;
    case 500:
      ShowSnackBar(
          context: context,
          text: jsonDecode(response.body)['errMsg'],
          color: Colors.red);
      break;
    default: //if none of the above code mathes (idk when this will run but if it does we are returning the json body itself)
      ShowSnackBar(context: context, text: response.body, color: Colors.red);
  }
}
