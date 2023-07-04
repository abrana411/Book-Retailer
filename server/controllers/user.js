const {productModel} = require('../models/product_model');
const userModel = require('../models/user_model');
const orderModel = require('../models/order_model');

//API to add a product(quantity wise) to cart of current user
const addProductToUserCart = async (req,res)=>{
  try {
    const {id} = req.body;//getting the product id from the body
    const userId = req.user;//getting user id from the .user (which we set in the auth middleware)

    //get the porduct:-
    const product = await productModel.findById(id);
    let currUser = await userModel.findById(userId);

    //check if the currUser has any item in cart or not:-
    if(currUser.cart.length == 0)
    {
        //Then add new to cart:-
        currUser.cart.push({product,quantity:1});
    }
    else
    {
        //We will check if the cart of this user has this product before , if yes then we will have to increment the quantity of it else we just have to add a single quantity of it
        let isProductInCart = false;
        for(let i=0;i<currUser.cart.length;i++)
        {
            //Now we have to compare the _id of the current product in the cart and the product we get from the string id
            if(currUser.cart[i].product._id.equals(product._id)) //have to use equals() to compare the id object of mongoose
            {
                isProductInCart = true;
            }
        }

        if(isProductInCart)
        {
            //Update the quantity of the product now:-
            let prod = currUser.cart.find((item)=> item.product._id.equals(product._id));
            prod.quantity++; //incresing the quantity (this will be linked with the db product and incresing quantity here like this will increase for that , and below we will save it, to update the changes in the database too)
        }
        else
        {
            //single quantity add
            currUser.cart.push({product,quantity:1});
        }
    }

    currUser = await currUser.save();
    res.json(currUser);
  } catch (error) {
    // console.log(error);
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};


//Function to remove a product from cart of current user:-
const removeFromCart = async (req,res)=>{
  try {
    const {id} = req.params;//getting the product id from the params
    const userId = req.user;
    //get the porduct:-
    const product = await productModel.findById(id);
    let currUser = await userModel.findById(userId);
 
    //No need to chjeck if this product is in cart or not , because the user can go to this API only if its showing in the cart screen
    for(let i=0;i<currUser.cart.length;i++)
    {
        if(currUser.cart[i].product._id.equals(product._id)) //have to use equals() to compare the id object of mongoose
        {
            if(currUser.cart[i].quantity==1) //then have to remove this prduct fro cart
            {
                currUser.cart.splice(i,1);//remove ith(current)
            }
            else
            {
              //have to decrease the quantity of this product
              currUser.cart[i].quantity--;
            }
        }
    }

    //update the user:-
    currUser = await currUser.save();
    res.json(currUser);
  } catch (error) {
    console.log(error);
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};


//Add user address:-
const addUserAddress = async(req,res)=>{
  try {
    const {address} = req.body;
    //get user:
    let currUser = await userModel.findById(req.user);
    currUser.address = address;//changing the address
    currUser = await currUser.save();//updating the user on db
    res.json(currUser);
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};

//Route to post a order document , ie creating a new order
const createOrder = async(req,res)=>{
  try {
    const {cart,totalPrice,address} = req.body;
    let products = [];
    for(let i=0;i<cart.length;i++)
    {
      //Check if each product in the cart is in stock or not (by comparing the quantity the user is purchansing and the amount we have)
      let product = await productModel.findById(cart[i].product._id);
      if(product.quantity >= cart[i].quantity) //then its fine
      {
        //so decrease the quantity of the product and save it int the db
        product.quantity -= cart[i].quantity;
        product = await product.save();

        //also add this product to the products now (which will go in the order) along with the quantity use is purchasing
        products.push({product,quantity:cart[i].quantity});
      }
      else
      {
        //out of stock error:-
        res.status(500).json({errMsg:`${product.name} is out of stock`});
      }
    }

    //Uodate the user in the data base by making the cart empty:-
    let currUser = await userModel.findById(req.user);
    currUser.cart = [];
    currUser = await currUser.save();

    //create an Order now:-
    let newOrder = new orderModel({products,totalPrice,address,userId:req.user,orderedAt:new Date().getTime()});
    newOrder = await newOrder.save();
    res.json(newOrder);//passing the new order to the client then
    
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};

//Get orders of a user:-
const getOrders = async (req,res)=>{
  try {
    const orders = await orderModel.find({userId:req.user});
    res.json(orders);//list of orders with the user id of the current user
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};

const getListedProducts = async (req,res) => {
  try {
    const id = req.user;
    const products = await productModel.find({sellerId: id});
    // console.log("The products are :" + products);
    res.json(products);
  } catch (error) {
    res.status(500).json({error: `An error has occured with message: ${error}`});
  }
}


module.exports = {
  addProductToUserCart,
  removeFromCart,
  addUserAddress,
  createOrder,
  getOrders,
  getListedProducts,
};