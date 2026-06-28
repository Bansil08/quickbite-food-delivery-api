const express = require('express');
const router = express.Router();

const {
  registerUser,
  loginUser,
  getUserProfile,
  updateProfile,
  changePassword,
} = require('../controllers/userController');

const { verifyToken } = require('../middleware/authMiddleware');

router.post('/register', registerUser);

router.post('/login', loginUser);

router.get('/profile',          verifyToken, getUserProfile);

router.put('/profile',          verifyToken, updateProfile);

router.put('/profile/password', verifyToken, changePassword);

module.exports = router;
