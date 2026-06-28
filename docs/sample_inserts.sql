-- Quick-Bite Project — Data Insertion Script

-- 1. Users (10 rows)
INSERT INTO Users (UserID, User_Name, Phone_No, Email, Password) VALUES
(1,  'Aarav Sharma',    9876543210, 'aarav.sharma@gmail.com',    'hashed_pw_001'),
(2,  'Priya Patel',     9876543211, 'priya.patel@gmail.com',     'hashed_pw_002'),
(3,  'Rohan Mehta',     9876543212, 'rohan.mehta@yahoo.com',     'hashed_pw_003'),
(4,  'Sneha Iyer',      9876543213, 'sneha.iyer@outlook.com',    'hashed_pw_004'),
(5,  'Vikram Singh',    9876543214, 'vikram.singh@gmail.com',    'hashed_pw_005'),
(6,  'Ananya Reddy',    9876543215, 'ananya.reddy@gmail.com',    'hashed_pw_006'),
(7,  'Karthik Nair',    9876543216, 'karthik.nair@yahoo.com',    'hashed_pw_007'),
(8,  'Diya Gupta',      9876543217, 'diya.gupta@outlook.com',    'hashed_pw_008'),
(9,  'Arjun Das',       9876543218, 'arjun.das@gmail.com',       'hashed_pw_009'),
(10, 'Meera Joshi',     9876543219, 'meera.joshi@gmail.com',     'hashed_pw_010');

-- 2. User_Address (10 rows)
INSERT INTO User_Address (Add_ID, Add_line_1, Add_line_2, Area, City, Pincode) VALUES
(1,  '12 MG Road',          'Apt 4B',       'Koramangala',  'Bangalore',  560034),
(2,  '45 Park Street',      'Floor 2',      'Bandra',       'Mumbai',     400050),
(3,  '78 Anna Salai',       NULL,            'T Nagar',      'Chennai',    600017),
(4,  '23 Connaught Place',  'Block C',      'CP',           'Delhi',      110001),
(5,  '56 FC Road',          'Suite 301',    'Deccan',       'Pune',       411004),
(6,  '89 Brigade Road',     NULL,            'MG Road',      'Bangalore',  560001),
(7,  '34 Marine Drive',     'Flat 12A',     'Churchgate',   'Mumbai',     400020),
(8,  '67 Residency Road',   'Block B',      'Ashok Nagar',  'Bangalore',  560025),
(9,  '11 Salt Lake',        'Tower 3',      'Sector V',     'Kolkata',    700091),
(10, '90 Jubilee Hills',    NULL,            'Film Nagar',   'Hyderabad',  500033);

-- 3. User_Has_Address (10 rows)
INSERT INTO User_Has_Address (Add_ID, UserID) VALUES
(1,  1),
(2,  2),
(3,  3),
(4,  4),
(5,  5),
(6,  6),
(7,  7),
(8,  8),
(9,  9),
(10, 10);

-- 4. Restaurant (10 rows)
INSERT INTO Restaurant (Restaurant_ID, Name, Open_Time, Close_Time, Restaurant_Status, FSSAI_License_No, Contact_No) VALUES
(1,  'Spice Garden',        '2026-01-01 09:00:00', '2026-01-01 23:00:00', TRUE,  10020034000,  8801234567),
(2,  'Tandoor Nights',      '2026-01-01 11:00:00', '2026-01-01 23:30:00', TRUE,  10020034001,  8801234568),
(3,  'Dragon Wok',          '2026-01-01 10:00:00', '2026-01-01 22:00:00', TRUE,  10020034002,  8801234569),
(4,  'Pizza Planet',        '2026-01-01 08:00:00', '2026-01-02 00:00:00', TRUE,  10020034003,  8801234570),
(5,  'Biryani House',       '2026-01-01 11:00:00', '2026-01-01 23:00:00', TRUE,  10020034004,  8801234571),
(6,  'Sushi Station',       '2026-01-01 12:00:00', '2026-01-01 22:30:00', FALSE, 10020034005,  8801234572),
(7,  'Burger Barn',         '2026-01-01 09:30:00', '2026-01-02 01:00:00', TRUE,  10020034006,  8801234573),
(8,  'Dosa Corner',         '2026-01-01 06:00:00', '2026-01-01 21:00:00', TRUE,  10020034007,  8801234574),
(9,  'Cafe Mocha',          '2026-01-01 07:00:00', '2026-01-01 23:00:00', TRUE,  10020034008,  8801234575),
(10, 'Wok & Roll',          '2026-01-01 10:30:00', '2026-01-01 22:00:00', FALSE, 10020034009,  8801234576);

-- 5. Restaurant_Address (10 rows)
INSERT INTO Restaurant_Address (Add_ID, Add_line_1, Add_line_2, Area, City, Pincode, Restaurant_ID) VALUES
(101, '1 Food Street',      'Shop 4',       'Indiranagar',   'Bangalore',  560038, 1),
(102, '22 Linking Road',    NULL,            'Bandra West',   'Mumbai',     400050, 2),
(103, '55 Mount Road',      'Floor 1',      'Nungambakkam',  'Chennai',    600034, 3),
(104, '88 Karol Bagh',      'Sector 2',     'Rajouri',       'Delhi',      110005, 4),
(105, '10 JM Road',         NULL,            'Shivajinagar',  'Pune',       411005, 5),
(106, '33 Church Street',   'Suite 5',      'MG Road',       'Bangalore',  560001, 6),
(107, '77 Colaba Cswy',     NULL,            'Colaba',        'Mumbai',     400005, 7),
(108, '44 Basavanagudi',    'Block A',      'Gandhi Bazaar',  'Bangalore',  560004, 8),
(109, '99 Lavelle Road',    NULL,            'Ashok Nagar',   'Bangalore',  560001, 9),
(110, '66 Hitech City',     'Tower B',      'Madhapur',      'Hyderabad',  500081, 10);

-- 6. Cuisine (10 rows)
INSERT INTO Cuisine (Cuisine, Restaurant_ID) VALUES
('North Indian',    1),
('Mughlai',         2),
('Chinese',         3),
('Italian',         4),
('Hyderabadi',      5),
('Japanese',        6),
('American',        7),
('South Indian',    8),
('Continental',     9),
('Thai',            10);

-- 7. Menu_Category (10 rows)
INSERT INTO Menu_Category (Category_Name, Type, Restaurant_ID) VALUES
('Starters',        'Veg',       1),
('Main Course',     'Non-Veg',   2),
('Noodles',         'Veg',       3),
('Pizzas',          'Veg',       4),
('Biryanis',        'Non-Veg',   5),
('Sushi Rolls',     'Non-Veg',   6),
('Burgers',         'Non-Veg',   7),
('Dosas',           'Veg',       8),
('Beverages',       'Veg',       9),
('Curries',         'Non-Veg',   10);

-- 8. Menu_Item (10 rows)
INSERT INTO Menu_Item (Item_ID, Item_Name, Description, Price, Preparation_Time, Category_Name, Restaurant_ID) VALUES
(1,  'Paneer Tikka',       'Grilled cottage cheese cubes',     250, 15, 'Starters',     1),
(2,  'Butter Chicken',     'Creamy tomato-based chicken',      350, 20, 'Main Course',  2),
(3,  'Hakka Noodles',      'Stir-fried vegetable noodles',     200, 12, 'Noodles',      3),
(4,  'Margherita Pizza',   'Classic tomato and mozzarella',    300, 18, 'Pizzas',       4),
(5,  'Chicken Biryani',    'Dum cooked basmati with chicken',  400, 30, 'Biryanis',     5),
(6,  'Salmon Nigiri',      'Fresh salmon over rice',           500, 10, 'Sushi Rolls',  6),
(7,  'Classic Burger',     'Beef patty with cheese',           280, 15, 'Burgers',      7),
(8,  'Masala Dosa',        'Crispy crepe with potato filling', 120, 10, 'Dosas',        8),
(9,  'Cold Coffee',        'Iced blended coffee',              150,  5, 'Beverages',    9),
(10, 'Green Curry',        'Thai green curry with basil',      320, 20, 'Curries',      10);

-- 9. Review (10 rows)
INSERT INTO Review (Review_ID, Review, Rating, Restaurant_ID, UserID) VALUES
(1,  'Amazing food and quick service!',          4.5, 1,  1),
(2,  'Butter chicken was heavenly.',             4.8, 2,  2),
(3,  'Decent noodles but a bit oily.',           3.5, 3,  3),
(4,  'Best pizza in town!',                      4.7, 4,  4),
(5,  'Authentic biryani, loved it.',             4.9, 5,  5),
(6,  'Fresh sushi, great ambiance.',             4.2, 6,  6),
(7,  'Burger was juicy and well seasoned.',      4.0, 7,  7),
(8,  'Crispy dosa, perfect chutney.',            4.6, 8,  8),
(9,  'Coffee was average, nothing special.',     3.0, 9,  9),
(10, 'Thai curry had great flavors!',            4.3, 10, 10);

-- 10. Cart (10 rows)
INSERT INTO Cart (Cart_ID, Created_At, Status, UserID) VALUES
(1,  '2026-03-01 12:00:00', 'Active',     1),
(2,  '2026-03-01 12:30:00', 'Active',     2),
(3,  '2026-03-01 13:00:00', 'Checked Out', 3),
(4,  '2026-03-01 13:15:00', 'Checked Out', 4),
(5,  '2026-03-01 14:00:00', 'Abandoned',  5),
(6,  '2026-03-02 10:00:00', 'Active',     6),
(7,  '2026-03-02 11:00:00', 'Checked Out', 7),
(8,  '2026-03-02 12:00:00', 'Active',     8),
(9,  '2026-03-02 13:30:00', 'Abandoned',  9),
(10, '2026-03-02 14:00:00', 'Active',     10);

-- 11. Cart_Item (10 rows)
INSERT INTO Cart_Item (Item_ID, Cart_ID, Quantity) VALUES
(1,  1,  2),
(2,  2,  1),
(3,  3,  3),
(4,  4,  1),
(5,  5,  2),
(6,  6,  1),
(7,  7,  2),
(8,  8,  4),
(9,  9,  1),
(10, 10, 2);

-- 12. Orders (10 rows)
INSERT INTO Orders (OrderID, Date_Time, UserID, Restaurant_ID) VALUES
(1,  '2026-03-01 12:10:00', 1,  1),
(2,  '2026-03-01 12:40:00', 2,  2),
(3,  '2026-03-01 13:05:00', 3,  3),
(4,  '2026-03-01 13:20:00', 4,  4),
(5,  '2026-03-01 14:10:00', 5,  5),
(6,  '2026-03-02 10:15:00', 6,  6),
(7,  '2026-03-02 11:10:00', 7,  7),
(8,  '2026-03-02 12:20:00', 8,  8),
(9,  '2026-03-02 13:40:00', 9,  9),
(10, '2026-03-02 14:15:00', 10, 10);

-- 13. Order_Item (10 rows)
INSERT INTO Order_Item (Item_ID, OrderID, Quantity) VALUES
(1,  1,  2),
(2,  2,  1),
(3,  3,  3),
(4,  4,  1),
(5,  5,  2),
(6,  6,  1),
(7,  7,  2),
(8,  8,  4),
(9,  9,  1),
(10, 10, 2);

-- 14. Payment (10 rows)
INSERT INTO Payment (Transaction_ID, Mode, Order_ID) VALUES
(1001, 'UPI',        1),
(1002, 'Card',       2),
(1003, 'UPI',        3),
(1004, 'Cash',       4),
(1005, 'Wallet',     5),
(1006, 'Card',       6),
(1007, 'UPI',        7),
(1008, 'Cash',       8),
(1009, 'Wallet',     9),
(1010, 'Card',       10);

-- 15. Delivery_Partner (10 rows)
INSERT INTO Delivery_Partner (Partner_ID, Name, Phone_No, Vehicle_No, Rating) VALUES
(1,  'Raju Kumar',       7700110011, 'KA01AB1234', 4.5),
(2,  'Suresh Yadav',     7700110012, 'MH02CD5678', 4.2),
(3,  'Manoj Pillai',     7700110013, 'TN03EF9012', 4.8),
(4,  'Deepak Verma',     7700110014, 'DL04GH3456', 3.9),
(5,  'Amit Chauhan',     7700110015, 'MH05IJ7890', 4.6),
(6,  'Ganesh Patil',     7700110016, 'KA06KL1122', 4.0),
(7,  'Sanjay Mishra',    7700110017, 'MH07MN3344', 4.3),
(8,  'Vinod Rajan',      7700110018, 'KA08OP5566', 4.7),
(9,  'Prakash Gowda',    7700110019, 'TN09QR7788', 3.8),
(10, 'Naveen Reddy',     7700110020, 'TS10ST9900', 4.1);

-- 16. Delivery (10 rows)
INSERT INTO Delivery (Delivery_ID, Pickup_Time, Delivery_Time, Status, OrderID, Partner_ID) VALUES
(1,  '2026-03-01 12:25:00', '2026-03-01 12:55:00', 'Delivered',  1,  1),
(2,  '2026-03-01 12:55:00', '2026-03-01 13:20:00', 'Delivered',  2,  2),
(3,  '2026-03-01 13:20:00', '2026-03-01 13:50:00', 'Delivered',  3,  3),
(4,  '2026-03-01 13:35:00', '2026-03-01 14:05:00', 'Delivered',  4,  4),
(5,  '2026-03-01 14:25:00', '2026-03-01 14:55:00', 'Delivered',  5,  5),
(6,  '2026-03-02 10:30:00', '2026-03-02 11:00:00', 'Delivered',  6,  6),
(7,  '2026-03-02 11:25:00', '2026-03-02 11:50:00', 'Delivered',  7,  7),
(8,  '2026-03-02 12:35:00', NULL,                   'In Transit', 8,  8),
(9,  '2026-03-02 13:55:00', NULL,                   'Picked Up',  9,  9),
(10, '2026-03-02 14:30:00', NULL,                   'Assigned',   10, 10);

-- 17. Wallet (10 rows)
INSERT INTO Wallet (Wallet_ID, Balance, Created_At, UserID) VALUES
(1,  1500, '2026-01-01 10:00:00', 1),
(2,  2300, '2026-01-02 11:00:00', 2),
(3,   800, '2026-01-03 09:00:00', 3),
(4,  5000, '2026-01-04 10:30:00', 4),
(5,  1200, '2026-01-05 12:00:00', 5),
(6,  3400, '2026-01-06 08:00:00', 6),
(7,   600, '2026-01-07 14:00:00', 7),
(8,  4100, '2026-01-08 16:00:00', 8),
(9,   950, '2026-01-09 10:00:00', 9),
(10, 2750, '2026-01-10 11:00:00', 10);

-- 18. Wallet_Transaction (10 rows)
INSERT INTO Wallet_Transaction (Wallet_ID, Transaction_ID, Type, Amount, Date_Time) VALUES
(1,  2001, 'Credit',  500,  '2026-02-01 10:00:00'),
(2,  2002, 'Debit',   200,  '2026-02-01 11:30:00'),
(3,  2003, 'Credit',  1000, '2026-02-02 09:00:00'),
(4,  2004, 'Debit',   350,  '2026-02-02 14:00:00'),
(5,  2005, 'Credit',  750,  '2026-02-03 10:00:00'),
(6,  2006, 'Debit',   400,  '2026-02-03 16:00:00'),
(7,  2007, 'Credit',  600,  '2026-02-04 08:00:00'),
(8,  2008, 'Debit',   150,  '2026-02-04 12:00:00'),
(9,  2009, 'Credit',  200,  '2026-02-05 10:30:00'),
(10, 2010, 'Debit',   300,  '2026-02-05 15:00:00');

-- 19. Wallet_TopUP (10 rows)
INSERT INTO Wallet_TopUP (Transaction_ID, Status, Payment_mode, Transaction_Ref, Date_Time, Wallet_ID) VALUES
(2001, 'Success',  'UPI',        3001, '2026-02-01 10:00:00', 1),
(2003, 'Success',  'Card',       3002, '2026-02-02 09:00:00', 3),
(2005, 'Success',  'UPI',        3003, '2026-02-03 10:00:00', 5),
(2007, 'Success',  'NetBanking', 3004, '2026-02-04 08:00:00', 7),
(2009, 'Success',  'UPI',        3005, '2026-02-05 10:30:00', 9),
(2011, 'Failed',   'Card',       3006, '2026-02-06 09:00:00', 2),
(2012, 'Pending',  'UPI',        3007, '2026-02-06 10:00:00', 4),
(2013, 'Success',  'Card',       3008, '2026-02-07 11:00:00', 6),
(2014, 'Success',  'NetBanking', 3009, '2026-02-07 14:00:00', 8),
(2015, 'Failed',   'UPI',        3010, '2026-02-08 09:30:00', 10);

-- 20. Discount (10 rows)
INSERT INTO Discount (Discount_ID, Discount_PR, Discount_Amount, OrderID) VALUES
(1,  10, 50,   1),
(2,  15, 52,   2),
(3,  20, 120,  3),
(4,   5, 15,   4),
(5,  25, 200,  5),
(6,  10, 50,   6),
(7,  30, 168,  7),
(8,  12, 58,   8),
(9,   8, 12,   9),
(10, 18, 115,  10);

-- 21. Complaint (10 rows)
INSERT INTO Complaint (OrderID, Complaint_ID, Issue_Type, Description, Created_At, Status, Resolved_At) VALUES
(1,  1,  'Late Delivery',    'Order arrived 30 mins late',              '2026-03-01 13:30:00', 'Resolved',  '2026-03-01 14:00:00'),
(2,  2,  'Wrong Item',       'Received veg instead of non-veg',         '2026-03-01 14:00:00', 'Resolved',  '2026-03-01 15:00:00'),
(3,  3,  'Cold Food',        'Noodles were completely cold',             '2026-03-01 14:30:00', 'Resolved',  '2026-03-02 10:00:00'),
(4,  4,  'Missing Item',     'Garlic bread was missing from order',      '2026-03-01 14:45:00', 'Open',      NULL),
(5,  5,  'Quality Issue',    'Biryani tasted stale',                     '2026-03-01 15:30:00', 'Resolved',  '2026-03-02 12:00:00'),
(6,  6,  'Late Delivery',    'Delivery took over an hour',               '2026-03-02 11:30:00', 'Open',      NULL),
(7,  7,  'Packaging',        'Burger was squished during delivery',      '2026-03-02 12:30:00', 'Resolved',  '2026-03-02 13:00:00'),
(8,  8,  'Wrong Item',       'Got plain dosa instead of masala dosa',    '2026-03-02 13:00:00', 'Open',      NULL),
(9,  9,  'Spill',            'Coffee leaked in the bag',                 '2026-03-02 14:30:00', 'Resolved',  '2026-03-02 15:00:00'),
(10, 10, 'Late Delivery',    'Order delayed by 45 minutes',              '2026-03-02 15:00:00', 'Open',      NULL);

-- 22. Refund (10 rows)
INSERT INTO Refund (Refund_ID, OrderID, Complaint_ID, Refund_Amount, Refund_Status, Completed_At, Wallet_ID) VALUES
(1,  1,  1,  50,   'Completed', '2026-03-01 14:30:00', 1),
(2,  2,  2,  350,  'Completed', '2026-03-01 15:30:00', 2),
(3,  3,  3,  200,  'Completed', '2026-03-02 10:30:00', 3),
(4,  4,  4,  100,  'Pending',   NULL,                   4),
(5,  5,  5,  400,  'Completed', '2026-03-02 12:30:00', 5),
(6,  6,  6,  150,  'Pending',   NULL,                   6),
(7,  7,  7,  280,  'Completed', '2026-03-02 13:30:00', 7),
(8,  8,  8,  120,  'Pending',   NULL,                   8),
(9,  9,  9,  150,  'Completed', '2026-03-02 15:30:00', 9),
(10, 10, 10, 320,  'Pending',   NULL,                   10);

-- 23. Cancellation (10 rows)
INSERT INTO Cancellation (Cancellation_ID, Cancelled_By, Cancellation_Reason, Cancelled_At, Refund_Eligible, Penalty_Amount, OrderID) VALUES
(1,  'Customer',    'Changed my mind',                     '2026-03-01 12:12:00', TRUE,  0,   1),
(2,  'Customer',    'Found better option',                 '2026-03-01 12:42:00', TRUE,  0,   2),
(3,  'Restaurant',  'Item out of stock',                   '2026-03-01 13:08:00', TRUE,  0,   3),
(4,  'Customer',    'Ordered by mistake',                  '2026-03-01 13:22:00', TRUE,  0,   4),
(5,  'Restaurant',  'Kitchen closed early',                '2026-03-01 14:12:00', TRUE,  0,   5),
(6,  'Customer',    'Delivery taking too long',            '2026-03-02 10:45:00', FALSE, 50,  6),
(7,  'System',      'Payment failed after timeout',        '2026-03-02 11:15:00', TRUE,  0,   7),
(8,  'Customer',    'Wrong address entered',               '2026-03-02 12:25:00', FALSE, 30,  8),
(9,  'Restaurant',  'Ingredient unavailable',              '2026-03-02 13:45:00', TRUE,  0,   9),
(10, 'Customer',    'Duplicate order placed accidentally', '2026-03-02 14:18:00', TRUE,  0,   10);
