const userModel = require('../models/user_model');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

//Post request to create a new user:
const signUpUser = async (req,res) => {
    try {
       //getting the name,email and the password of the user which we are about to create from the req.body as the frontend will pass it from there end
       const {name,email,password,isGoogleSignIn} = req.body;
        //The errors can be handles using the logic of what i did using the error_handler middleware and the http_express_error package but here doing them manually
        //Though the duplicate email error can be handles by the mongoose itself but doing here to show the custom message as an error (though we can do that using the error_handler middleware as done in jobs api too)
        const existingUser = await userModel.findOne({ email });
      //   console.log(existingUser);
        
        if(!isGoogleSignIn && existingUser)
        {
            return res.status(400).send({errMsg:"A user with same email already exists!!"});
        }
        else if(isGoogleSignIn && existingUser)
        {
            const token = jwt.sign({ id: existingUser._id}, process.env.JWT_SECRET, { 
               expiresIn: process.env.JWT_EXPIRETIME,
            });
            return res.status(200).json({token,...existingUser._doc});
        }

        //Hasing the password using the bcrypt js:- (could do this in pre middleware when creation of user schema is about to be done) as done in jobs api projectr (can refer that for good code writing)
        const salt = await bcrypt.genSalt(10);//this method is used to generate salt which is random bytes and 10 means th length or the number of rounds so more means more secured sat but will take more processing power too so 10 is a good number
        const hashedPassword = await bcrypt.hash(password,salt);

        //Here we will not use the userModel.create({schema model key and values}) rather we will use save() here which is another way to create a document in the mongo db (both ways are good) but this save() method is applicable on the instance of the schema ie first we will create an instance and then do .save()
        let user = new userModel({
            name,
            email,
            password: hashedPassword,
        });

        user = await user.save();
        
        if(isGoogleSignIn) user.password = "";
        const token = jwt.sign({ id: user._id}, process.env.JWT_SECRET, { 
         expiresIn: process.env.JWT_EXPIRETIME,
        });
 
       res.status(200).json({token,...user._doc});
   } catch (error) {
        res.status(500).send({errMsg:`An error has occured with message : ${error.message}`});
   }
};


//Signin route:-
const signInUser = async (req, res) => {
   try {
      // console.log("Here it comes");
     const {email, password} = req.body;

     //First check if there is some user with this email or not
     const user = await userModel.findOne({email});
     if(!user)
     {
        return res.status(400).json({errMsg:"No user is registered with this email"});
     }

     //Now compare the password (and since the password was hashed so we will have to use the bcypt.js for that purpose too)
      const isMatching = await bcrypt.compare(password,user.password);
      if(!isMatching)
      {
        return res.status(400).json({errMsg:"Password is Incorrect!!"});
      }

      //Now creating the token (can do this in the instance method of the userModel(like did in the jobs.api porject too but doing it like this only here))
      const token = jwt.sign({ id: user._id}, process.env.JWT_SECRET, { //as the payload giving the user id only , and pssing the jwt secret key from the .env file
        expiresIn: process.env.JWT_EXPIRETIME, //exiring time from env too
      });

      res.status(200).json({token,...user._doc}); //here we are merging the token into the user._doc(this is the user model object) so that we get token as a field now in a single object returned from here

   } catch (error) {
      res.status(500).json({errMsg:`An error has occured with message : ${error}`})
   }
};


//To check if the token is valid or not:-
const validatetoken = async (req,res) => {
   try {
      // console.log("This comes here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
      //We will receive the token from the header here 
      const token = req.header("User_token"); //using this custom name to pass th token from the frontend (not the authorization convention one)

      //If token does not exist
      if(!token) res.json(false);//returning false directly no object nothing

      const isVerified = await jwt.verify(token,process.env.JWT_SECRET); //This method can be used to verify (it takes the same secret key we have used for the signin of the token ie generation of the token)
      //If the token exists but it is not valid
      if(!isVerified) return res.json(false);

      //IF the token is valid but there is no user associated with the id of the user whose token is this (may be because the user got deleted some how)
      //And to get the id we can use the isVerified field above , as it is nothing but the payload we have given at the time of generation of the token
      const user = await userModel.findById(isVerified.id);//in the jwt.sign({id:id of user}) this id is used here
      if(!user) return res.json(false);

      //else if everything is fine then we will simply return true ie the token is valid and there is a user corresponding to the token
      res.json(true);

   } catch (error) {
      res.status(500).json({errMsg:`An error has occured with message : ${error}`})
   }
}


//Get the users data
const getUsersData = async (req,res) => {
    try {
      //will get the below from the auth middleware
      const userId = req.user;
      const userToken = req.token;
      const user = await userModel.findById(userId);
      res.json({...user._doc,token:userToken});//making a single object by taking the user data and the token and then passing it to the client

    } catch (error) {
      res.status(500).json({errMsg:`An error has occured with message : ${error}`});
    }
}
module.exports = {signUpUser,signInUser,validatetoken,getUsersData};