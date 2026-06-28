-- Quick-Bite — MySQL Security: Users, Roles & Privileges
-- MySQL does not have Row-Level Security (RLS) like PostgreSQL.
-- Security is enforced via dedicated DB users with least-privilege GRANTs.
--
-- Three application roles:
--   qb_readonly  → SELECT only (for analytics / reporting services)
--   qb_app       → SELECT, INSERT, UPDATE, DELETE on operational tables
--   qb_admin     → All privileges (internal admin tool / migrations)
--
-- Run as root / superuser on the MySQL server.

-- =============================================================================
-- 1. Create application database users
-- =============================================================================

CREATE USER IF NOT EXISTS 'qb_readonly'@'%' IDENTIFIED BY 'ReadOnly@QB2025!';
CREATE USER IF NOT EXISTS 'qb_app'@'%'      IDENTIFIED BY 'AppUser@QB2025!';
CREATE USER IF NOT EXISTS 'qb_admin'@'%'    IDENTIFIED BY 'Admin@QB2025!';


-- =============================================================================
-- 2. Read-Only User — Analytics / Reporting
-- =============================================================================
-- Can only SELECT from non-sensitive tables and views.
-- Cannot see Users.Password or Wallet balances.

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

-- Grant access to views (no access to raw sensitive tables)
GRANT SELECT ON quick_bite_db.v_order_summary          TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.v_restaurant_leaderboard TO 'qb_readonly'@'%';
GRANT SELECT ON quick_bite_db.v_menu_with_category     TO 'qb_readonly'@'%';


-- =============================================================================
-- 3. Application User — Backend API (Node.js / Express)
-- =============================================================================
-- Can read and write all operational tables needed by the API.
-- Cannot DROP, TRUNCATE, or ALTER tables.
-- Cannot read Users.Password directly (handled by the app layer with bcrypt).

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

-- Allow app user to call stored procedure
GRANT EXECUTE ON PROCEDURE quick_bite_db.place_order TO 'qb_app'@'%';

-- Allow app user to read from views
GRANT SELECT ON quick_bite_db.v_order_summary          TO 'qb_app'@'%';
GRANT SELECT ON quick_bite_db.v_restaurant_leaderboard TO 'qb_app'@'%';
GRANT SELECT ON quick_bite_db.v_menu_with_category     TO 'qb_app'@'%';


-- =============================================================================
-- 4. Admin User — Internal Tools / Migrations
-- =============================================================================

GRANT ALL PRIVILEGES ON quick_bite_db.* TO 'qb_admin'@'%';


-- =============================================================================
-- 5. Apply privilege changes
-- =============================================================================

FLUSH PRIVILEGES;
