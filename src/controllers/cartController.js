const { pool } = require('../config/db');

const getOrCreateActiveCart = async (connection, userId) => {
  const [carts] = await connection.execute(
    "SELECT Cart_ID, Restaurant_ID FROM Carts WHERE User_ID = ? AND Status = 'active' LIMIT 1",
    [userId]
  );
  if (carts.length > 0) return carts[0];

  const [result] = await connection.execute(
    "INSERT INTO Carts (User_ID, Status) VALUES (?, 'active')",
    [userId]
  );
  return { Cart_ID: result.insertId, Restaurant_ID: null };
};

const getCart = async (req, res) => {
  const userId = req.user.id;
  let connection;

  try {
    connection = await pool.getConnection();

    const [carts] = await connection.execute(
      "SELECT Cart_ID, Restaurant_ID, Created_At FROM Carts WHERE User_ID = ? AND Status = 'active' LIMIT 1",
      [userId]
    );

    if (carts.length === 0) {
      return res.status(200).json({
        success: true,
        message: 'Cart is empty.',
        data: { cart: null, items: [], total: 0 },
      });
    }

    const cart = carts[0];

    const [items] = await connection.execute(
      `SELECT
         ci.Cart_Item_ID,
         ci.Item_ID,
         ci.Quantity,
         mi.Name        AS Item_Name,
         mi.Price       AS Unit_Price,
         mi.Image_URL,
         mi.Is_Available,
         (ci.Quantity * mi.Price) AS Line_Total
       FROM Cart_Items ci
       JOIN Menu_Items mi ON ci.Item_ID = mi.Item_ID
       WHERE ci.Cart_ID = ?
       ORDER BY ci.Cart_Item_ID ASC`,
      [cart.Cart_ID]
    );

    const total = items.reduce((sum, i) => sum + parseFloat(i.Line_Total), 0);

    return res.status(200).json({
      success: true,
      data: {
        cart_id: cart.Cart_ID,
        restaurant_id: cart.Restaurant_ID,
        item_count: items.length,
        items,
        subtotal: parseFloat(total.toFixed(2)),
      },
    });
  } catch (err) {
    console.error('[getCart] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error fetching cart.' });
  } finally {
    if (connection) connection.release();
  }
};

const addToCart = async (req, res) => {
  const userId = req.user.id;
  const { item_id, quantity = 1 } = req.body;

  if (!item_id || quantity < 1) {
    return res.status(400).json({
      success: false,
      message: 'item_id is required and quantity must be at least 1.',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [items] = await connection.execute(
      'SELECT Item_ID, Name, Price, Is_Available, Restaurant_ID FROM Menu_Items WHERE Item_ID = ?',
      [item_id]
    );

    if (items.length === 0) {
      return res.status(404).json({ success: false, message: 'Menu item not found.' });
    }

    const menuItem = items[0];

    if (!menuItem.Is_Available) {
      return res.status(400).json({
        success: false,
        message: `"${menuItem.Name}" is currently unavailable.`,
      });
    }

    const cart = await getOrCreateActiveCart(connection, userId);
    const cartId = cart.Cart_ID;

    if (cart.Restaurant_ID && cart.Restaurant_ID !== menuItem.Restaurant_ID) {
      return res.status(409).json({
        success: false,
        message:
          'Your cart already contains items from a different restaurant. Please clear your cart before adding items from a new restaurant.',
      });
    }

    if (!cart.Restaurant_ID) {
      await connection.execute(
        'UPDATE Carts SET Restaurant_ID = ? WHERE Cart_ID = ?',
        [menuItem.Restaurant_ID, cartId]
      );
    }

    const [existing] = await connection.execute(
      'SELECT Cart_Item_ID, Quantity FROM Cart_Items WHERE Cart_ID = ? AND Item_ID = ?',
      [cartId, item_id]
    );

    if (existing.length > 0) {
      const newQty = existing[0].Quantity + parseInt(quantity, 10);
      await connection.execute(
        'UPDATE Cart_Items SET Quantity = ? WHERE Cart_Item_ID = ?',
        [newQty, existing[0].Cart_Item_ID]
      );
    } else {
      await connection.execute(
        'INSERT INTO Cart_Items (Cart_ID, Item_ID, Quantity) VALUES (?, ?, ?)',
        [cartId, item_id, parseInt(quantity, 10)]
      );
    }

    return res.status(200).json({
      success: true,
      message: `"${menuItem.Name}" added to cart.`,
      data: { cart_id: cartId, item_id, quantity },
    });
  } catch (err) {
    console.error('[addToCart] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error adding to cart.' });
  } finally {
    if (connection) connection.release();
  }
};

const updateCartItem = async (req, res) => {
  const userId = req.user.id;
  const { cartItemId } = req.params;
  const { quantity } = req.body;

  if (quantity === undefined || quantity < 0) {
    return res.status(400).json({
      success: false,
      message: 'quantity is required and must be 0 or greater (0 removes the item).',
    });
  }

  let connection;
  try {
    connection = await pool.getConnection();

    const [rows] = await connection.execute(
      `SELECT ci.Cart_Item_ID
       FROM Cart_Items ci
       JOIN Carts c ON ci.Cart_ID = c.Cart_ID
       WHERE ci.Cart_Item_ID = ? AND c.User_ID = ? AND c.Status = 'active'`,
      [cartItemId, userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Cart item not found in your active cart.',
      });
    }

    if (parseInt(quantity, 10) === 0) {
      
      await connection.execute('DELETE FROM Cart_Items WHERE Cart_Item_ID = ?', [cartItemId]);
      return res.status(200).json({ success: true, message: 'Item removed from cart.' });
    }

    await connection.execute(
      'UPDATE Cart_Items SET Quantity = ? WHERE Cart_Item_ID = ?',
      [parseInt(quantity, 10), cartItemId]
    );

    return res.status(200).json({
      success: true,
      message: 'Cart item quantity updated.',
      data: { cart_item_id: parseInt(cartItemId, 10), quantity: parseInt(quantity, 10) },
    });
  } catch (err) {
    console.error('[updateCartItem] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error updating cart item.' });
  } finally {
    if (connection) connection.release();
  }
};

const removeFromCart = async (req, res) => {
  const userId = req.user.id;
  const { cartItemId } = req.params;

  let connection;
  try {
    connection = await pool.getConnection();

    const [rows] = await connection.execute(
      `SELECT ci.Cart_Item_ID
       FROM Cart_Items ci
       JOIN Carts c ON ci.Cart_ID = c.Cart_ID
       WHERE ci.Cart_Item_ID = ? AND c.User_ID = ? AND c.Status = 'active'`,
      [cartItemId, userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Cart item not found in your active cart.',
      });
    }

    await connection.execute('DELETE FROM Cart_Items WHERE Cart_Item_ID = ?', [cartItemId]);

    return res.status(200).json({ success: true, message: 'Item removed from cart.' });
  } catch (err) {
    console.error('[removeFromCart] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error removing cart item.' });
  } finally {
    if (connection) connection.release();
  }
};

const clearCart = async (req, res) => {
  const userId = req.user.id;
  let connection;

  try {
    connection = await pool.getConnection();

    const [carts] = await connection.execute(
      "SELECT Cart_ID FROM Carts WHERE User_ID = ? AND Status = 'active' LIMIT 1",
      [userId]
    );

    if (carts.length === 0) {
      return res.status(404).json({ success: false, message: 'No active cart to clear.' });
    }

    const cartId = carts[0].Cart_ID;

    await connection.execute('DELETE FROM Cart_Items WHERE Cart_ID = ?', [cartId]);
    await connection.execute(
      'UPDATE Carts SET Restaurant_ID = NULL WHERE Cart_ID = ?',
      [cartId]
    );

    return res.status(200).json({ success: true, message: 'Cart cleared successfully.' });
  } catch (err) {
    console.error('[clearCart] Error:', err);
    return res.status(500).json({ success: false, message: 'Server error clearing cart.' });
  } finally {
    if (connection) connection.release();
  }
};

module.exports = { getCart, addToCart, updateCartItem, removeFromCart, clearCart };
