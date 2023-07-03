const mongoose = require('mongoose');
const { productSchema } = require('./product_model');

const orderSchema = new mongoose.Schema({
    //This will have follwoing things:-
    //1)The products which have been ordered(in a single time as cart could contains many orders so all will be transfered to this products list) -> this is similar to cart , as it contains a list or product and with their quantity
    products: [
        {
          product: productSchema,
          quantity: {
            type: Number,
            required: true,
          },
        },
      ],
    //Total price of all the things of an order
    totalPrice: {
      type: Number,
      required: true,
    },
    //Adress of the user , ie where we are shipping those
    address: {
      type: String,
      required: true,
    },
    //The user who has ordered (to show the myOrders screen by fetching the orders with the help of users id)
    userId: {
      required: true,
      type: String,
    },
    //Time of ordering
    orderedAt: {
      type: Number,
      required: true,
    },
    //status -> 0(pending) ,1(shipped) , 2(delivered) , 3(done)  ,something like this (and the status will be changed by the admin only)
    status: {
      type: Number,
      default: 0,
    },
});

module.exports = mongoose.model('Order',orderSchema);//creating and exporting a collection/model into the db