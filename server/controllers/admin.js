const orderModel = require("../models/order_model");
const {productModel} = require("../models/product_model");

//API to add a new product to db:
const addProductForSale = async (req,res)=>{
    try {
        //these names should be matching with the ones in the model of the product in the client side because we are directly adding these same name to the mongo
        const { name, description, images, quantity, price, category } = req.body;
        //just like we created a user simply create an instance of the product model and save it using the .save() to the mongo db and then return it to the client side
        let newProd = new productModel({
            name,
            description,
            images,
            quantity,
            price,
            category,
        });
        newProd = await newProd.save();
        res.json(newProd);
    } catch (error) {
        res.status(500).json({errMsg:`An error has occured with message : ${error}`});
    }
};

//API to fetch all the products:-
const fetchAllProducts = async(req,res)=>{
  try {
    const prods = await productModel.find({});//nothing is given so find all
    res.json(prods);
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};

//API route to delete a product:-
const deleteProduct = async(req,res)=>{
    try{
      const {id} = req.body;
      const productAfterDelete = await productModel.findByIdAndDelete(id);
      res.json(productAfterDelete);
    }catch(error)
    {
        res.status(500).json({errMsg:`An error has occured with message : ${error}`});
    }
};

//API route to get all the orders:-
const getAllOrders = async(req,res)=>{
  try {
      const orders = await orderModel.find({});
      res.json(orders);
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};

//API route to change the status of the order:-
const changeStatusOfOrder = async(req,res)=>{
   try {
    const {id} = req.body;
    let order = await orderModel.findById(id);
    order.status+=1;
    order = await order.save();
    res.json(order);
   } catch (error) {
      res.status(500).json({errMsg:`An error has occured with message : ${error}`});
   }
};


//API to get total earnings:- (From all the orders that have been placed so far)
const getTotalEarnings = async (req,res)=>{
  try {
    let orders = await orderModel.find({});
    let totalEarnings = 0;
    for(let i=0;i<orders.length;i++)
    {
       let currOrderPrice = orders[i].totalPrice;
       totalEarnings += currOrderPrice;
    }
    // Getting the earning for each category now:-
    let mobileEarnings = await getCategoryWiseEarningsFromOrders("Mobiles");
    let essentialEarnings = await getCategoryWiseEarningsFromOrders("Essentials");
    let applianceEarnings = await getCategoryWiseEarningsFromOrders("Appliances");
    let booksEarnings = await getCategoryWiseEarningsFromOrders("Books");
    let fashionEarnings = await getCategoryWiseEarningsFromOrders("Fashion");
   
    //creating a object and sending it to the clients side now
    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings);
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`});
  }
};

async function getCategoryWiseEarningsFromOrders(category){
    //Get the orders belonging to the passed category , and how to do it?
    //we know that in the orders we have products fields and in products we have product (fild of the object at each index) and in the product we have category so have to match it like this (and then make it a string (as that is the convention while matching the chaining products))
    
      let categoryOrders = await orderModel.find({
        "products.product.category": category, //match with passed category
      });
      // console.log("yo");
      let catEarnings = 0;
      for(let i=0;i<categoryOrders.length;i++)
      {
        for(let j=0;j<categoryOrders[i].products.length;j++)
        {
          //quantity of this jth product in ith order * the price of this product
          catEarnings += categoryOrders[i].products[j].product.price * categoryOrders[i].products[j].quantity;
        }
      }
      return catEarnings;
}
module.exports = {
  addProductForSale,
  fetchAllProducts,
  deleteProduct,
  getAllOrders,
  changeStatusOfOrder,
  getTotalEarnings
};