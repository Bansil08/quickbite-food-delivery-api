const { pool } = require('../config/db');

const getMenuByRestaurant = async (req, res) => {
  const { restaurantId } = req.params;

  if (!restaurantId || isNaN(parseInt(restaurantId, 10))) {
    return res.status(400).json({
      success: false,
      message: 'Invalid restaurant ID.',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [restaurant] = await connection.execute(
      'SELECT Restaurant_ID, Name FROM Restaurants WHERE Restaurant_ID = ?',
      [restaurantId]
    );

    if (restaurant.length === 0) {
      return res.status(404).json({
        success: false,
        message: `Restaurant with ID ${restaurantId} not found.`,
      });
    }

    const [rows] = await connection.execute(
      `SELECT
         mc.Category_ID,
         mc.Category_Name,
         mi.Item_ID,
         mi.Name         AS Item_Name,
         mi.Description,
         mi.Price,
         mi.Image_URL,
         mi.Is_Available
       FROM Menu_Items mi
       JOIN Menu_Categories mc ON mi.Category_ID = mc.Category_ID
       WHERE mi.Restaurant_ID = ?
       ORDER BY mc.Category_Name ASC, mi.Name ASC`,
      [restaurantId]
    );

    const categoryMap = new Map();

    for (const row of rows) {
      if (!categoryMap.has(row.Category_ID)) {
        categoryMap.set(row.Category_ID, {
          category_id: row.Category_ID,
          category_name: row.Category_Name,
          items: [],
        });
      }

      categoryMap.get(row.Category_ID).items.push({
        item_id: row.Item_ID,
        name: row.Item_Name,
        description: row.Description,
        price: parseFloat(row.Price), 
        image_url: row.Image_URL,
        is_available: Boolean(row.Is_Available),
      });
    }

    const menu = Array.from(categoryMap.values());

    return res.status(200).json({
      success: true,
      data: {
        restaurant_id: parseInt(restaurantId, 10),
        restaurant_name: restaurant[0].Name,
        category_count: menu.length,
        menu,
      },
    });
  } catch (err) {
    console.error('[getMenuByRestaurant] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error fetching menu.',
    });
  } finally {
    if (connection) connection.release();
  }
};

module.exports = { getMenuByRestaurant };
