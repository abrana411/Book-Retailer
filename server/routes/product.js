const express =require('express');
const router = express.Router();
const {
    FilterProductByCategory,
    getSearchItems,
    rateAProduct,
    getBestDeal,
    listProduct,
    fetchAllProducts
} = require('../controllers/product');

router.route('/product').get(FilterProductByCategory);
router.route('/product/search/:searched').get(getSearchItems);
router.route('/rateProd').post(rateAProduct);
router.route('/best-deal').get(getBestDeal);
router.route('/getAll').get(fetchAllProducts);
router.route('/listProduct').post(listProduct)

module.exports = router;