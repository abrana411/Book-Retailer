const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');

const {signUpUser,signInUser,validatetoken,getUsersData} = require('../controllers/auth');

router.route('/signup').post(signUpUser);
router.route('/signin').post(signInUser);
router.route('/verifytoken').post(validatetoken);
router.get('/',authMiddleware,getUsersData);//using the middleware in this route to get the data 

module.exports = router;