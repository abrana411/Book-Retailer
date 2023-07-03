import 'package:a_to_z_shop/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    //Current user all things will be stored in this instance of User model
    id: '',
    name: '',
    password: '',
    address: '',
    type: '',
    token: '',
    email: '',
    cart: [],
  );

  User get user => _user; //Getter to get the user

  //setter to set the user from the json string:-
  void setUser(String user) {
    _user = User.fromJson(
        user); //here taking the string as input(json string) and will return the user instance
    notifyListeners(); //notifying the listeners
  }

  //Setting a user with a userModel instance
  void setUserUsingModel(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
