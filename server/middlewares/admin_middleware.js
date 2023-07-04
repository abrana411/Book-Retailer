const jwt = require('jsonwebtoken');
const UserModel = require('../models/user_model');

const adminMid = async (req,res,next)=>{
   //Everything will be same as the auth middleware just one more condition will be there , ki we will check if the user is of type admin or not , if not then we will return an error
   //and if yes then we will simply pass the token and the users id as we had done in the auth middleware
   try {
    //get the token from the header
    const token = req.header("User_token");
    if(!token)
    {
        return res.status(401).json({errMsg:"No token is provided, Access denied"});
    }
    
    const isVerified = await jwt.verify(token,process.env.JWT_SECRET);
    if(!isVerified)
    {
        return res.status(401).json({errMsg:"Verification of token failed, Access denied"});
    }
    
    const currUser = await UserModel.findById(isVerified.id);
    if(currUser.type === 'user' || currUser.type === 'seller')
    {
        //Then this route is not for this user as the user is not an admin
        return res.status(500).json({errMsg:`Not authorized to visit , as you are not an Admin`})
    }
    req.user = isVerified.id;
    req.token = token;//also storing the token in the req.token keyword so that could access this in the next() routes
    next();
  } catch (error) {
    res.status(500).json({errMsg:`An error has occured with message : ${error}`})
  }
};

module.exports = adminMid;