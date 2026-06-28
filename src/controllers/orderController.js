const { pool } = require('../config/db');

const createOrder = async (req, res) => {
  const userId = req.user.id; 
  const { delivery_address, payment_method = 'cash_on_delivery' } = req.body;

  let connection;
  try {
    connection = await pool.getConnection();

    const [carts] = await connection.execute(
      "SELECT Cart_ID FROM Carts WHERE User_ID = ? AND Status = 'active' LIMIT 1",
      [userId]
    );

    if (carts.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'No active cart found. Add items to your cart before placing an order.',
      });
    }

    const cartId = carts[0].Cart_ID;

    const [cartItems] = await connection.execute(
      `SELECT
         ci.Cart_Item_ID,
         ci.Item_ID,
         ci.Quantity,
         mi.Name        AS Item_Name,
         mi.Price       AS Unit_Price,
         mi.Is_Available,
         mi.Restaurant_ID
       FROM Cart_Items ci
       JOIN Menu_Items mi ON ci.Item_ID = mi.Item_ID
       WHERE ci.Cart_ID = ?`,
      [cartId]
    );

    if (cartItems.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Your cart is empty.',
      });
    }

    const unavailableItems = cartItems.filter((item) => !item.Is_Available);
    if (unavailableItems.length > 0) {
      const names = unavailableItems.map((i) => i.Item_Name).join(', ');
      return res.status(400).json({
        success: false,
        message: `The following items are currently unavailable: ${names}. Please remove them and try again.`,
      });
    }

    const restaurantId = cartItems[0].Restaurant_ID;
    const DELIVERY_FEE = 30.00; 
    const TAX_RATE = 0.05;      

    const subtotal = cartItems.reduce(
      (sum, item) => sum + parseFloat(item.Unit_Price) * item.Quantity,
      0
    );
    const tax = parseFloat((subtotal * TAX_RATE).toFixed(2));
    const totalAmount = parseFloat((subtotal + tax + DELIVERY_FEE).toFixed(2));

    let finalDeliveryAddress = delivery_address;
    if (!finalDeliveryAddress) {
      const [userRows] = await connection.execute(
        'SELECT Address FROM Users WHERE User_ID = ?',
        [userId]
      );
      finalDeliveryAddress = userRows[0]?.Address || null;
    }

    if (!finalDeliveryAddress) {
      return res.status(400).json({
        success: false,
        message: 'No delivery address provided and no default address found on your profile.',
      });
    }

    await connection.beginTransaction();

    try {
      
      const [orderResult] = await connection.execute(
        `INSERT INTO Orders
           (User_ID, Restaurant_ID, Total_Amount, Delivery_Fee, Tax, Delivery_Address, Payment_Method, Status)
         VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')`,
        [userId, restaurantId, totalAmount, DELIVERY_FEE, tax, finalDeliveryAddress, payment_method]
      );

      const orderId = orderResult.insertId;

      const orderItemValues = cartItems.map((item) => [
        orderId,
        item.Item_ID,
        item.Quantity,
        parseFloat(item.Unit_Price),
        parseFloat((item.Unit_Price * item.Quantity).toFixed(2)),
      ]);

      await connection.query(
        `INSERT INTO Order_Items (Order_ID, Item_ID, Quantity, Unit_Price, Subtotal)
         VALUES ?`,
        [orderItemValues]
      );

      await connection.execute(
        "UPDATE Carts SET Status = 'checked_out' WHERE Cart_ID = ?",
        [cartId]
      );

      await connection.commit();

      return res.status(201).json({
        success: true,
        message: 'Order placed successfully!',
        data: {
          order_id: orderId,
          restaurant_id: restaurantId,
          status: 'pending',
          subtotal: parseFloat(subtotal.toFixed(2)),
          delivery_fee: DELIVERY_FEE,
          tax,
          total_amount: totalAmount,
          delivery_address: finalDeliveryAddress,
          payment_method,
          item_count: cartItems.length,
        },
      });
    } catch (txErr) {
      
      await connection.rollback();
      console.error('[createOrder] Transaction rolled back:', txErr);
      return res.status(500).json({
        success: false,
        message: 'Order creation failed. The transaction was rolled back.',
      });
    }
  } catch (err) {
    console.error('[createOrder] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error while creating the order.',
    });
  } finally {
    if (connection) connection.release();
  }
};

const getUserOrders = async (req, res) => {
  const userId = req.user.id;

  let connection;
  try {
    connection = await pool.getConnection();

    const [orders] = await connection.execute(
      `SELECT
         o.Order_ID,
         o.Status,
         o.Total_Amount,
         o.Delivery_Fee,
         o.Tax,
         o.Delivery_Address,
         o.Payment_Method,
         o.Created_At,
         r.Name AS Restaurant_Name,
         r.Image_URL AS Restaurant_Image
       FROM Orders o
       JOIN Restaurants r ON o.Restaurant_ID = r.Restaurant_ID
       WHERE o.User_ID = ?
       ORDER BY o.Created_At DESC`,
      [userId]
    );

    return res.status(200).json({
      success: true,
      count: orders.length,
      data: { orders },
    });
  } catch (err) {
    console.error('[getUserOrders] Error:', err);
    return res.status(500).json({
      success: false,
      message: 'Server error fetching orders.',
    });
  } finally {
    if (connection) connection.release();
  }
};

module.exports = { createOrder, getUserOrders };
