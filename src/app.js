const express = require('express');
const cors = require('cors');
require('dotenv').config();

const userRoutes = require('./routes/userRoutes');
const restaurantRoutes = require('./routes/restaurantRoutes');
const menuRoutes = require('./routes/menuRoutes');
const orderRoutes = require('./routes/orderRoutes');
const cartRoutes = require('./routes/cartRoutes');

const app = express();

app.use(
  cors({
    origin: process.env.FRONTEND_URL || '*',
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);

app.use(express.json());

app.use(express.urlencoded({ extended: true }));

app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: '✅ Quick-Bite API is running.',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
  });
});

app.use('/api/users',       userRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/menu',        menuRoutes);
app.use('/api/cart',        cartRoutes);   
app.use('/api/orders',      orderRoutes);  

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route not found: ${req.method} ${req.originalUrl}`,
  });
});

app.use((err, req, res, next) => {
  console.error('[GlobalErrorHandler]', err.stack || err.message);

  const statusCode = err.status || err.statusCode || 500;

  res.status(statusCode).json({
    success: false,
    message: err.message || 'An unexpected internal server error occurred.',
    
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

module.exports = app;
