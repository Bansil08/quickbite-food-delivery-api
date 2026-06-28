const express = require('express');
const router = express.Router();

const {
  getCart,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart,
} = require('../controllers/cartController');

const { verifyToken } = require('../middleware/authMiddleware');

router.use(verifyToken);

router.get('/', getCart);

router.post('/items', addToCart);

router.patch('/items/:cartItemId', updateCartItem);

router.delete('/items/:cartItemId', removeFromCart);

router.delete('/', clearCart);

module.exports = router;
