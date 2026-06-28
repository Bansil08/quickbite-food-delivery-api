-- 1. Retrieve customers using Gmail
SELECT UserID, User_Name, Email
FROM Users
WHERE Email LIKE '%@gmail.com';

-- 2. Total amount spent by each customer
SELECT U.User_Name, SUM(MI.Price * OI.Quantity) AS Total_Spent
FROM Users U
JOIN Orders O ON U.UserID = O.UserID
JOIN Order_Item OI ON O.OrderID = OI.OrderID
JOIN Menu_Item MI ON OI.Item_ID = MI.Item_ID
GROUP BY U.User_Name;

-- 3. Customers from Bangalore
SELECT User_Name
FROM Users
WHERE UserID IN (
    SELECT UHA.UserID
    FROM User_Has_Address UHA
    JOIN User_Address UA ON UHA.Add_ID = UA.Add_ID
    WHERE UA.City = 'Bangalore'
);

-- 4. Total orders per customer
SELECT U.User_Name, COUNT(O.OrderID) AS Order_Count
FROM Users U
LEFT JOIN Orders O ON U.UserID = O.UserID
GROUP BY U.User_Name;

-- 5. Customers with at least one order
SELECT U.User_Name
FROM Users U
JOIN Orders O ON U.UserID = O.UserID
GROUP BY U.User_Name;

-- 6. Distinct cities
SELECT City FROM User_Address
UNION
SELECT City FROM Restaurant_Address;

-- 7. Customers who placed orders
SELECT DISTINCT U.User_Name
FROM Users U
JOIN Orders O ON U.UserID = O.UserID;

-- 8. Pagination of users
SELECT UserID, User_Name
FROM Users
ORDER BY User_Name
LIMIT 5 OFFSET 5;

-- 9. Total orders overall
SELECT COUNT(*) AS Total_Orders
FROM Orders;

-- 10. Average spending per order
SELECT AVG(MI.Price * OI.Quantity) AS Avg_Order_Value
FROM Order_Item OI
JOIN Menu_Item MI ON OI.Item_ID = MI.Item_ID;

-- 11. Highest spending customer
SELECT U.User_Name, SUM(MI.Price * OI.Quantity) AS Total_Spent
FROM Users U
JOIN Orders O ON U.UserID = O.UserID
JOIN Order_Item OI ON O.OrderID = OI.OrderID
JOIN Menu_Item MI ON OI.Item_ID = MI.Item_ID
GROUP BY U.User_Name
ORDER BY Total_Spent DESC
LIMIT 1;