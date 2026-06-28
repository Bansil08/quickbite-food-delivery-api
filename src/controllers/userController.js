const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { pool } = require('../config/db');
require('dotenv').config();

const generateToken = (user) => {
  const payload = {
    id: user.User_ID,
    email: user.Email,
    role: user.Role, 
  };
  return jwt.sign(payload, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  });
};

const registerUser = async (req, res) => {
  const { name, email, password, phone, address, role = 'customer' } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Name, email, and password are required.',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [existing] = await connection.execute(
      'SELECT User_ID FROM Users WHERE Email = ?',
      [email]
    );

    if (existing.length > 0) {
      return res.status(409).json({
        success: false,
        message: 'An account with this email already exists.',
      });
    }

    const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS, 10) || 12;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const [result] = await connection.execute(
      `INSERT INTO Users (Name, Email, Password_Hash, Phone, Address, Role)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [name, email, hashedPassword, phone || null, address || null, role]
    );

    const newUserId = result.insertId;

    const [newUser] = await connection.execute(
      'SELECT User_ID, Name, Email, Phone, Address, Role, Created_At FROM Users WHERE User_ID = ?',
      [newUserId]
    );

    const user = newUser[0];

    const token = generateToken(user);

    return res.status(201).json({
      success: true,
      message: 'User registered successfully.',
      data: { user, token },
    });
  } catch (err) {
    console.error('[registerUser] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error during registration.',
    });
  } finally {
    if (connection) connection.release();
  }
};

const loginUser = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Email and password are required.',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [rows] = await connection.execute(
      'SELECT User_ID, Name, Email, Password_Hash, Phone, Address, Role FROM Users WHERE Email = ?',
      [email]
    );

    if (rows.length === 0) {
      
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const user = rows[0];

    const isMatch = await bcrypt.compare(password, user.Password_Hash);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    const { Password_Hash, ...safeUser } = user;

    const token = generateToken(user);

    return res.status(200).json({
      success: true,
      message: 'Login successful.',
      data: { user: safeUser, token },
    });
  } catch (err) {
    console.error('[loginUser] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error during login.',
    });
  } finally {
    if (connection) connection.release();
  }
};

const getUserProfile = async (req, res) => {
  const userId = req.user.id;

  let connection;
  try {
    connection = await pool.getConnection();

    const [rows] = await connection.execute(
      'SELECT User_ID, Name, Email, Phone, Address, Role, Created_At FROM Users WHERE User_ID = ?',
      [userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    return res.status(200).json({
      success: true,
      data: { user: rows[0] },
    });
  } catch (err) {
    console.error('[getUserProfile] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error fetching profile.',
    });
  } finally {
    if (connection) connection.release();
  }
};

const updateProfile = async (req, res) => {
  const userId = req.user.id;
  const { name, phone, address } = req.body;

  if (!name && !phone && !address) {
    return res.status(400).json({
      success: false,
      message: 'Provide at least one field to update: name, phone, or address.',
    });
  }

  const fields = [];
  const params = [];

  if (name)    { fields.push('Name = ?');    params.push(name);    }
  if (phone)   { fields.push('Phone = ?');   params.push(phone);   }
  if (address) { fields.push('Address = ?'); params.push(address); }

  params.push(userId); 

  let connection;
  try {
    connection = await pool.getConnection();

    await connection.execute(
      `UPDATE Users SET ${fields.join(', ')} WHERE User_ID = ?`,
      params
    );

    const [rows] = await connection.execute(
      'SELECT User_ID, Name, Email, Phone, Address, Role, Created_At FROM Users WHERE User_ID = ?',
      [userId]
    );

    return res.status(200).json({
      success: true,
      message: 'Profile updated successfully.',
      data: { user: rows[0] },
    });
  } catch (err) {
    console.error('[updateProfile] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error updating profile.',
    });
  } finally {
    if (connection) connection.release();
  }
};

const changePassword = async (req, res) => {
  const userId = req.user.id;
  const { current_password, new_password } = req.body;

  if (!current_password || !new_password) {
    return res.status(400).json({
      success: false,
      message: 'current_password and new_password are both required.',
    });
  }

  if (new_password.length < 8) {
    return res.status(400).json({
      success: false,
      message: 'new_password must be at least 8 characters long.',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [rows] = await connection.execute(
      'SELECT Password_Hash FROM Users WHERE User_ID = ?',
      [userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    const isMatch = await bcrypt.compare(current_password, rows[0].Password_Hash);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Current password is incorrect.',
      });
    }

    const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS, 10) || 12;
    const newHash = await bcrypt.hash(new_password, saltRounds);

    await connection.execute(
      'UPDATE Users SET Password_Hash = ? WHERE User_ID = ?',
      [newHash, userId]
    );

    return res.status(200).json({
      success: true,
      message: 'Password changed successfully. Please log in again with your new password.',
    });
  } catch (err) {
    console.error('[changePassword] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error changing password.',
    });
  } finally {
    if (connection) connection.release();
  }
};

module.exports = { registerUser, loginUser, getUserProfile, updateProfile, changePassword };
