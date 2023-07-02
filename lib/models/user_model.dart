import 'dart:convert';

class User {
  final String id;
  final String name;
  final String password;
  final String address;
  final String type;
  final String email;
  final String
      token; //will get from the backend (when user logs in using the jwt)
  final List<dynamic> cart;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.email,
    required this.cart,
  });

  //Method to convert the user model to a map (json object)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'email': email,
      'cart': cart,
    };
  }

  //Method to convert a json object to the instance of this modle class:-
  //factory keyword is used when returning a new instance from a method
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ??
          '', //here using "_id" because we will be creating this istance from the data that we will be receiving from the post request we will be making to the backend server , so that has _id field which it returns
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      email: map['email'] ?? '',
      //Below doing similar stuff , converting what we get from the backend to List<Map<String,dynamic>> because the cart is a list of object with two things product and quantity
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          //inside the cart we will do map too , to get the internal data and get it converted to Map<String,dynamic> and each will be collected to make a list (this is the format whichw e can use to achieve this type of conversion)
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }
  //To convert the {} object to a json response and the object will be created using the incatnce of this class in which we will apply this like user.tojson()
  String toJson() => json.encode(toMap());

  //If we get the json then that will be first converted to map using json.decode and then passed to above function to create an instance
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  //Copy with method to change/update certain feild of a user model onlt:-
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
