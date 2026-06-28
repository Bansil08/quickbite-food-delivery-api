const { pool } = require('../config/db');

const getAllRestaurants = async (req, res) => {
  const { search, cuisine } = req.query;

  const conditions = [];
  const params = [];

  if (search) {
    conditions.push('r.Name LIKE ?');
    params.push(`%${search}%`);
  }

  if (cuisine) {
    conditions.push('r.Cuisine_Type = ?');
    params.push(cuisine);
  }

  const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

  let connection;
  try {
    connection = await pool.getConnection();

    const [rows] = await connection.execute(
      `SELECT
         r.Restaurant_ID,
         r.Name,
         r.Address,
         r.Phone,
         r.Cuisine_Type,
         r.Rating,
         r.Image_URL,
         r.Opening_Hours,
         r.Is_Active
       FROM Restaurants r
       ${whereClause}
       ORDER BY r.Rating DESC`,
      params
    );

    return res.status(200).json({
      success: true,
      count: rows.length,
      data: { restaurants: rows },
    });
  } catch (err) {
    console.error('[getAllRestaurants] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error fetching restaurants.',
    });
  } finally {
    if (connection) connection.release();
  }
};

const getRestaurantById = async (req, res) => {
  const { id } = req.params;

  if (!id || isNaN(parseInt(id, 10))) {
    return res.status(400).json({
      success: false,
      message: 'Invalid restaurant ID.',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [restaurantRows] = await connection.execute(
      `SELECT
         Restaurant_ID,
         Name,
         Address,
         Phone,
         Cuisine_Type,
         Rating,
         Image_URL,
         Opening_Hours,
         Is_Active
       FROM Restaurants
       WHERE Restaurant_ID = ?`,
      [id]
    );

    if (restaurantRows.length === 0) {
      return res.status(404).json({
        success: false,
        message: `Restaurant with ID ${id} not found.`,
      });
    }

    const [categories] = await connection.execute(
      `SELECT DISTINCT
         mc.Category_ID,
         mc.Category_Name
       FROM Menu_Categories mc
       JOIN Menu_Items mi ON mc.Category_ID = mi.Category_ID
       WHERE mi.Restaurant_ID = ?
       ORDER BY mc.Category_Name`,
      [id]
    );

    return res.status(200).json({
      success: true,
      data: {
        restaurant: restaurantRows[0],
        menu_categories: categories,
      },
    });
  } catch (err) {
    console.error('[getRestaurantById] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error fetching restaurant.',
    });
  } finally {
    if (connection) connection.release();
  }
};

const createRestaurant = async (req, res) => {
  const { name, address, phone, cuisine_type, image_url, opening_hours } = req.body;

  if (!name || !address || !cuisine_type) {
    return res.status(400).json({
      success: false,
      message: 'name, address, and cuisine_type are required.',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [result] = await connection.execute(
      `INSERT INTO Restaurants (Name, Address, Phone, Cuisine_Type, Image_URL, Opening_Hours, Is_Active)
       VALUES (?, ?, ?, ?, ?, ?, 1)`,
      [name, address, phone || null, cuisine_type, image_url || null, opening_hours || null]
    );

    const [newRestaurant] = await connection.execute(
      'SELECT * FROM Restaurants WHERE Restaurant_ID = ?',
      [result.insertId]
    );

    return res.status(201).json({
      success: true,
      message: 'Restaurant created successfully.',
      data: { restaurant: newRestaurant[0] },
    });
  } catch (err) {
    console.error('[createRestaurant] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error creating restaurant.' });
  } finally {
    if (connection) connection.release();
  }
};

const updateRestaurant = async (req, res) => {
  const { id } = req.params;
  const { name, address, phone, cuisine_type, image_url, opening_hours } = req.body;

  if (isNaN(parseInt(id, 10))) {
    return res.status(400).json({ success: false, message: 'Invalid restaurant ID.' });
  }

  const fields = [];
  const params = [];

  if (name)          { fields.push('Name = ?');          params.push(name);          }
  if (address)       { fields.push('Address = ?');       params.push(address);       }
  if (phone)         { fields.push('Phone = ?');         params.push(phone);         }
  if (cuisine_type)  { fields.push('Cuisine_Type = ?');  params.push(cuisine_type);  }
  if (image_url)     { fields.push('Image_URL = ?');     params.push(image_url);     }
  if (opening_hours) { fields.push('Opening_Hours = ?'); params.push(opening_hours); }

  if (fields.length === 0) {
    return res.status(400).json({ success: false, message: 'No fields provided to update.' });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    if (req.user.role === 'restaurant_owner') {
      const [check] = await connection.execute(
        'SELECT Owner_ID FROM Restaurants WHERE Restaurant_ID = ?',
        [id]
      );
      if (check.length === 0 || check[0].Owner_ID !== req.user.id) {
        return res.status(403).json({
          success: false,
          message: 'Forbidden. You can only update your own restaurant.',
        });
      }
    }

    params.push(id);
    await connection.execute(
      `UPDATE Restaurants SET ${fields.join(', ')} WHERE Restaurant_ID = ?`,
      params
    );

    const [updated] = await connection.execute(
      'SELECT * FROM Restaurants WHERE Restaurant_ID = ?',
      [id]
    );

    return res.status(200).json({
      success: true,
      message: 'Restaurant updated successfully.',
      data: { restaurant: updated[0] },
    });
  } catch (err) {
    console.error('[updateRestaurant] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error updating restaurant.' });
  } finally {
    if (connection) connection.release();
  }
};

const toggleRestaurantStatus = async (req, res) => {
  const { id } = req.params;
  const { is_active } = req.body;

  if (is_active === undefined) {
    return res.status(400).json({ success: false, message: 'is_active (boolean) is required.' });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [result] = await connection.execute(
      'UPDATE Restaurants SET Is_Active = ? WHERE Restaurant_ID = ?',
      [is_active ? 1 : 0, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Restaurant not found.' });
    }

    return res.status(200).json({
      success: true,
      message: `Restaurant ${is_active ? 'activated' : 'deactivated'} successfully.`,
    });
  } catch (err) {
    console.error('[toggleRestaurantStatus] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error toggling status.' });
  } finally {
    if (connection) connection.release();
  }
};

module.exports = {
  getAllRestaurants,
  getRestaurantById,
  createRestaurant,
  updateRestaurant,
  toggleRestaurantStatus,
};
