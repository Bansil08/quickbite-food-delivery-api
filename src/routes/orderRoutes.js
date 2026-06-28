const express = require('express');
const router = express.Router();

const { createOrder, getUserOrders } = require('../controllers/orderController');
const { verifyToken } = require('../middleware/authMiddleware');

router.use(verifyToken);

router.post('/', createOrder);

router.get('/', getUserOrders);

module.exports = router;
