const express = require('express');
const router = express.Router();

const { getMenuByRestaurant } = require('../controllers/menuController');

router.get('/:restaurantId', getMenuByRestaurant);

module.exports = router;
