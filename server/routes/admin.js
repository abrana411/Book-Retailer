const express =require('express');
const {
    addProductForSale,
    fetchAllProducts,
    deleteProduct,
    getAllOrders,
    changeStatusOfOrder,
    getTotalEarnings
} = require('../controllers/admin');

const router = express.Router();

router.route('/add-product-to-sell').post(addProductForSale);
router.route('/').get(fetchAllProducts).delete(deleteProduct);
router.route('/getAllOrders').get(getAllOrders);
router.route('/change-order-status').post(changeStatusOfOrder);
router.route('/analytics').get(getTotalEarnings);

module.exports = router;