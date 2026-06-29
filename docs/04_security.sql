CREATE USER IF NOT EXISTS 'qb_readonly'@'%' IDENTIFIED BY 'ReadOnly@QB2025!';
CREATE USER IF NOT EXISTS 'qb_app'@'%'      IDENTIFIED BY 'AppUser@QB2025!';
CREATE USER IF NOT EXISTS 'qb_admin'@'%'    IDENTIFIED BY 'Admin@QB2025!';

GRANT SELECT ON quick_bite_db.Restaurant         TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Restaurant_Address TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Cuisine            TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Menu_Category      TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Menu_Item          TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Review             TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Orders             TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Order_Item         TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Delivery_Partner   TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Delivery           TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.Discount           TO 'qb_readonly'@'%';

GRANT SELECT ON quick_bite_db.v_order_summary          TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.v_restaurant_leaderboard TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.v_menu_with_category     TO 'qb_readonly'@'%';

GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Users              TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.User_Address       TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.User_Has_Address   TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Restaurant         TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Restaurant_Address TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Cuisine            TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Menu_Category      TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Menu_Item          TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Review             TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Cart               TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Cart_Item          TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Orders             TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Order_Item         TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Payment            TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Delivery           TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Delivery_Partner   TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Wallet             TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Wallet_Transaction TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Wallet_TopUP       TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Discount           TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Complaint          TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Refund             TO 'qb_app'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON quick_bite_db.Cancellation       TO 'qb_app'@'%';

GRANT EXECUTE ON PROCEDURE quick_bite_db.place_order TO 'qb_app'@'%';

GRANT SELECT ON quick_bite_db.v_order_summary          TO 'qb_app'@'%';
GRANT SELECT ON quick_bite_db.v_restaurant_leaderboard TO 'qb_app'@'%';
GRANT SELECT ON quick_bite_db.v_menu_with_category     TO 'qb_app'@'%';

GRANT ALL PRIVILEGES ON quick_bite_db.* TO 'qb_admin'@'%';

FLUSH PRIVILEGES;
