const jwt = require('jsonwebtoken');
require('dotenv').config();

const verifyToken = (req, res, next) => {
  
  const authHeader = req.headers['authorization'];

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Access denied. No token provided. Use: Authorization: Bearer <token>',
    });
  }

  const token = authHeader.split(' ')[1]; 

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    req.user = decoded;
    next();
  } catch (err) {
    
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'Token has expired. Please log in again.',
      });
    }

    if (err.name === 'JsonWebTokenError') {
      return res.status(403).json({
        success: false,
        message: 'Invalid token. Authentication failed.',
      });
    }

    return res.status(403).json({
      success: false,
      message: 'Token verification failed.',
    });
  }
};

module.exports = { verifyToken };
