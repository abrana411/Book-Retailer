const {prodModel} = require('../models/product_model');

// Api for fetching the products of a certain category:
const FilterProductByCategory = async (req,res)=>{
    try {
        const {category} = req.query; //will pass the query parameter like /api/product?category="Mobile" say and getting the category here , doing this because this is a get route
        const prods = await prodModel.find({category:category}); //searching by the category (category is also a key in each product document so doing like this)
        res.json(prods);
      } catch (error) {
        res.status(500).json({errMsg:`An error has occured with message : ${error}`});
      }
};

//Api for getting the matched product named from the search paramtere passed in the url itself, so we will be using :/searched here
const getSerachItems = async(req,res)=>{
  try {
    const {searched} = req.params;
    const prods = await prodModel.find({name:{$regex:searched,$options:'i'}});//Using query operator here , ie if the searched thing matched with any name(even if searched is a substring of any name , whole thing is not necessary to match here with this approach) , (also the searched if in uppercase will get converted to lower case for searching because of the oprions='i' , can read more about these in the store api project) 
    res.json(prods);
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
}

//API for rating a product:-
const rateAProduct = async(req,res)=>{
 try {
   //Get the users id:-
   const curruserId = req.user;

   //Get the product id and the rating the user has given to this product:-
   const {id,rating} = req.body;

   //get the product:-
   let product = await prodModel.findById(id);

   //Now loop through all the user ratings to this product and check if any rating is corresponding to this current user ie if this user has rated this before then we will just delete it (as we will be adding new rating for this user below anyways so it will work as uodating the rating) else dont do anything if this user has not voted yet
   for(let i=0;i<product.ratings.length;i++)
   {
    //produt.rating is array of ratingSchema having userId and rating fields:-
    if(product.ratings[i].userId == curruserId)
    {
      product.ratings.splice(i,1);//removing the ith rating , splice (i,1) means from ith index and count '1' ie ith only
      break;
    }
   }

   //Add new rating:-
   product.ratings.push({userId:curruserId,rating}); //addint the rating which is a rating schema ie userId and the rating

   product = await product.save();//updating the product in the database
   res.json(product);
 } catch (error) {
  console.log(error);
   res.status(500).json({errMsg:`An error has occured with message : ${error})`});
 }
};

//API to get the deal of the day or the best deal for a day:-
//The product with most ratings (ie sum of rating of each product will be more will be taken as deal of the day) (other thing which could have done is the product with the best average rating , but not doing that because say if a product is purchased only ons and gven 5 star then that will have best average rating that other one whichc is bought 10000 times and have 4.5 star)
const getBestDeal = async(req,res)=>{
  try {
    //We will iterate over all the products and then get sum of each and return the product with the best sum
    let products = await prodModel.find({});
    
    let maxRatingProdIndex = 0;
    let maxsumRatingsoFar = 0;
    for(let i=0;i<products.length;i++)
    {
        let product = products[i];
        let SumOfRating = 0;
        for(let j=0;j<product.ratings.length;j++)
        {
          SumOfRating += product.ratings[j].rating;
        }
        if(SumOfRating > maxsumRatingsoFar)
        {
          maxsumRatingsoFar = SumOfRating;
          maxRatingProdIndex = i;
        }
    }

    //Return the product with the max rating now:-
    res.json(products[maxRatingProdIndex]);
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error})`});
  }
};

const listProduct = async (req,res) => {
  const sellerId = req.user;
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let newProduct = new prodModel({
        name,
        description,
        images,
        quantity,
        price,
        category,
        sellerId,
    });
    newProduct = await newProduct.save();
    res.json(newProduct);
} catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
}
}

module.exports = {
  FilterProductByCategory,
  getSerachItems,
  rateAProduct,
  getBestDeal,
  listProduct,
};