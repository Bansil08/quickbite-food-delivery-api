const express = require('express');
const router = express.Router();

const {
  getAllRestaurants,
  getRestaurantById,
  createRestaurant,
  updateRestaurant,
  toggleRestaurantStatus,
} = require('../controllers/restaurantController');

const { verifyToken }  = require('../middleware/authMiddleware');
const { requireRole }  = require('../middleware/roleMiddleware');

router.get('/', getAllRestaurants);

router.get('/:id', getRestaurantById);

router.post(
  '/',
  verifyToken,
  requireRole('admin'),
  createRestaurant
);

router.patch(
  '/:id/status',
  verifyToken,
  requireRole('admin'),
  toggleRestaurantStatus
);

router.put(
  '/:id',
  verifyToken,
  requireRole('admin', 'restaurant_owner'),
  updateRestaurant
);

module.exports = router;
