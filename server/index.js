require('dotenv').config(); //configuring the dotenv file to access the content inside it
const express = require('express');
const cors = require("cors");
const app = express();

//Importing other files:-
const DbConnect = require('./db/connect');

//importing the routers:-
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');

//importing the middlewares:-
const adminMiddleware = require('./middlewares/admin_middleware');
const authMiddleware = require('./middlewares/authMiddleware');

//using the middleWares:-
app.use(cors());
app.use(express.json());//for req.body (getting json body)
app.use('/api',authRouter);
app.use('/admin',adminMiddleware,adminRouter); //as i need to use the admin middleware in all routes of this so passing the middleware here directly
app.use('/api',authMiddleware,productRouter); //Auth middleware for all product routes
app.use('/api',authMiddleware,userRouter);

//Getting port:-
const PORT = process.env.PORT || 3001;


//Start method:-
const start = async function(){
   try {
     //Try connecting to the data base:-
     await DbConnect(process.env.MONGO_URL);
     console.log("Database is connected!!");
     app.listen(PORT,()=>{ //have to give the some ip address here since the android emulator has problem when using the local host sometimes
        console.log(`Listening on ${PORT}`);
    })
   } catch (error) {
     console.log(error);
     //to kill the process now:-
     process.exit(1);
   }
};

//invoking the start method:-
start();