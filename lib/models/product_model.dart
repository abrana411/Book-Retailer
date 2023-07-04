import 'dart:convert';

import './rating_model.dart';

//this will be the product (ie the structure of the product we will be using)
class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String>
      images; //Here the images are not in the File format because we will be storing the downlodable url here so which we get after uploading the images at the cloudinary
  final String category;
  final double price;
  final String? id; //The product id which we will get from the mongo db
  final String? sellerId;
  final List<Rating>?
      rating; //list of {userId,rating} ie of the Rating model , as from the backend we will be having list of object like shown so have to convert that into the Rating model instance which we are doing below in the
  Product(
      {required this.name,
      required this.description,
      required this.quantity,
      required this.images,
      required this.category,
      required this.price,
      this.sellerId,
      this.id,
      this.rating});

  //Convert to map :-
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'sellerId': sellerId,
      'rating': rating,
    };
  }

  //Convert to an instance so factory and from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      sellerId: map['sellerId'] ?? '',
      id: map[
          '_id'], //_id because in the map which we will be getting (after json.decode(api vala json string)) it will have the product id as _id just like we did in user's model
      //so what is happening below is , from the server side we will get a json string which we will convert to a map using jsonDecode and then pass that to this function, now the ratings field will be having json object of the rating schema which is having {userId and Rating fields} so we have to convert that into a Rating Model instance of this one which we created here in the dart (front end) so have to map that rating to a list of rating
      rating: map['ratings'] != null
          ? List<Rating>.from(
              //getting a List<Rating> from ....
              map['ratings']?.map(
                (x) => Rating.fromMap(
                    x), //Each 'x' is a json string like {userId,Rating} so using this to get a Rating model instance using the fromMap function of Rating Model class , (the json string will be converted to the map using the .map in the ratings array/list)
              ),
            )
          : null,
    );
  }

  //to json (if we want to use a product insatnce and then pass to the API)
  String toJson() => json.encode(toMap());

  //From API's string json to the insatnce of this class we will use this for that
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
