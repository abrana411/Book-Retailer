const express = require('express');
const router = express.Router();
const {addProductToUserCart,removeFromCart,addUserAddress,CreateAnOrder,getOrders} = require('../controllers/user');
router.route('/add-to-cart').post(addProductToUserCart);
router.route('/delete-from-cart/:id').delete(removeFromCart);
router.route('/add-address').post(addUserAddress)
router.route('/placedOrder').post(CreateAnOrder);
router.route('/getUserOrder').get(getOrders);

module.exports = router;