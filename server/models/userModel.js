const mongoose = require('mongoose');
const {productSchema} = require('./productModel');

const UserSchema = new mongoose.Schema({
    name:{
        type:String,
        required:true,
        trim:true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
          validator: (value) => {
            const re = 
              /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
            return value.match(re);
          },
          message: "Please enter a valid email address",
        },
      },
      password: {
        required: true,
        type: String,
      },
      //Below fields will not be needed at the time of the user creation (signup) so setting default value and also the required field is not there ie by default false
      address: {
        type: String,
        default: "",
      },
      type: { //The other type can be the admin (the seller type will make in an update for this app)
        type: String,
        default: "user",
      },

      //Each user has its own cart property too:- (It is not a required field rather this will be created on the go when a user adds some item into a cart)
      //And in the cart property we will have an array of product Schema(just like we did for rating schema to be in the rating property of product schema) and apart from that aother field which will be the quantity ie in how much quantity we have this product
      cart: [
        {//Each element of this cart array is having two things , product schema and quantity 
          product: productSchema,
          quantity: {
            type: Number,
            required: true,
          },
        },
      ],
});

module.exports = mongoose.model("User",UserSchema);//creating a collection in the data base with name users (small case with 's extra) and exporting it