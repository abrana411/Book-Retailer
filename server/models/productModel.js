const mongoose = require('mongoose');
const ratingSchema = require('./ratingModel');

const productSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
      },
      description: {
        type: String,
        required: true,
        trim: true,
      },
      //to create an array either we can do images:{type:Array} but if we want to specify the type of the elements that will be in the array then we will do like beloe [] for specifying that this is an array and {} for specifying an element of an array and inside {} write the cvalidations and type of the element
      images: [
        {
          type: String,
          required: true,
        },
      ],
      quantity: {
        type: Number,
        required: true,
      },
      price: {
        type: Number,
        required: true,
      },
      category: {
        type: String,
        required: true,
      },
      //Rating array consisting of the rating schema as an element
      ratings:[ratingSchema],
    

});

const prodModel = mongoose.model('Product', productSchema); //creading a collection Product (in the mongodb it will be products) and assigning the schema of each document it will have in the product schema
module.exports = {prodModel,productSchema};//schema will be used in the cart field in the user model