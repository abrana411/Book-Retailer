const express =require('express');
const {
    deleteProduct,
    getAllOrders,
    changeStatusOfOrder,
    // getTotalEarnings,
    fetchAllProducts,
    getApprovedProducts,
    getUnapprovedProducts,
    getCategoryWiseListOfListedProducts,
} = require('../controllers/admin');

const router = express.Router();

router.route('/').get(fetchAllProducts).delete(deleteProduct);
router.route('/approvedProducts').get(getApprovedProducts);
router.route('/unApprovedProducts').get(getUnapprovedProducts);
router.route('/getAllOrders').get(getAllOrders);
router.route('/change-order-status').post(changeStatusOfOrder);
router.route('/analytics').get(getCategoryWiseListOfListedProducts);

module.exports = router;