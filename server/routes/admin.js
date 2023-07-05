const express =require('express');
const {
    addProductForSale,
    fetchAllProducts,
    deleteProduct,
    getAllOrders,
    changeStatusOfOrder,
    getTotalEarnings,
    getApprovedProducts,
    getUnapprovedProducts,
    getCategoryWiseListOfListedProducts,
} = require('../controllers/admin');

const router = express.Router();

router.route('/add-product-to-sell').post(addProductForSale);
router.route('/').get(fetchAllProducts).delete(deleteProduct);
router.route('/approvedProducts').get(getApprovedProducts);
router.route('/unApprovedProducts').get(getUnapprovedProducts);
router.route('/getAllOrders').get(getAllOrders);
router.route('/change-order-status').post(changeStatusOfOrder);
router.route('/analytics').get(getCategoryWiseListOfListedProducts);

module.exports = router;