const express = require('express');
const {
    addProductToUserCart,
    removeFromCart,
    addUserAddress,
    createOrder,
    getOrders,
    getListedProducts,
    deleteProduct,
} = require('../controllers/user');

const router = express.Router();

router.route('/add-to-cart').post(addProductToUserCart);
router.route('/delete-from-cart/:id').delete(removeFromCart);
router.route('/add-address').post(addUserAddress)
router.route('/placedOrder').post(createOrder);
router.route('/getUserOrder').get(getOrders);
router.route('/getListedProducts').get(getListedProducts);
router.route('/:id').delete(deleteProduct);

module.exports = router;