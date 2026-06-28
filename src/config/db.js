const mysql = require('mysql2/promise');
require('dotenv').config();

const poolConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT, 10) || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'quick_bite_db',
  connectionLimit: 10,
  waitForConnections: true,
  queueLimit: 0,
  
  dateStrings: false,
};

const pool = mysql.createPool(poolConfig);

const testConnection = async () => {
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.ping();
    console.log(
      `✅  Database connected successfully → ${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`
    );
  } catch (err) {
    console.error('❌  Database connection failed:', err.message);
    
    process.exit(1);
  } finally {
    if (connection) connection.release();
  }
};

module.exports = { pool, testConnection };
