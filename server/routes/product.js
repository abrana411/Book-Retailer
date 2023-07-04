const express =require('express');
const router = express.Router();
const {
    FilterProductByCategory,
    getSerachItems,
    rateAProduct,
    getBestDeal,
    listProduct,
} = require('../controllers/product');

router.route('/product').get(FilterProductByCategory);
router.route('/product/search/:searched').get(getSerachItems);
router.route('/rateProd').post(rateAProduct);
router.route('/best-deal').get(getBestDeal);
router.route('/listProduct').post(listProduct);

module.exports = router;