const mongoose = require("mongoose");

//This will be a rating schema which we will pass to the rating:[] array in the procut schema , that is this will not be a model just a structure of each rating which will an element in the array rating in the product schema (so can do like this too when we have t0o define a complex strcture in a model,then can create othyer scnemas too and refer it there)
const ratingSchema =  new mongoose.Schema({
    //This will have the user id who gave rating to this product and the rating
    userId: {
        type: String,
        required: true,
      },
      rating: {
        type: Number,
        required: true,
      },
});

module.exports = ratingSchema;//not creating a model here as explained above