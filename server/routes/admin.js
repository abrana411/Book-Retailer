const express =require('express');
const router = express.Router();
const {addProductForSale,fetchallProducts,deleteProduct,getAllOrders,changeStatusOfOrder,getTotalEarnings} = require('../controllers/admin');

router.route('/add-product-to-sell').post(addProductForSale);
router.route('/').get(fetchallProducts).delete(deleteProduct);
router.route('/getAllOrders').get(getAllOrders);
router.route('/change-order-status').post(changeStatusOfOrder);
router.route('/analytics').get(getTotalEarnings);

module.exports = router;