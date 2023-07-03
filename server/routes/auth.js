const express = require('express');
const authMiddleware = require('../middlewares/auth_middleware');
const {
    signUpUser,
    signInUser,
    validatetoken,
    getUsersData
} = require('../controllers/auth');

const router = express.Router();

router.route('/signup').post(signUpUser);
router.route('/signin').post(signInUser);
router.route('/verifytoken').post(validatetoken);
router.get('/',authMiddleware,getUsersData);   //using the middleware in this route to get the data 

module.exports = router;