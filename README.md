# QuickBite Food Delivery API

[![Node.js](https://img.shields.io/badge/Node.js-18%2B-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![Express](https://img.shields.io/badge/Express-4.x-000000?logo=express&logoColor=white)](https://expressjs.com)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](https://mysql.com)
[![JWT](https://img.shields.io/badge/Auth-JWT-FB015B?logo=jsonwebtokens&logoColor=white)](https://jwt.io)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)

A production-ready **RESTful backend API** for a food delivery platform, built with **Node.js**, **Express.js**, and **MySQL 8.0**. Features JWT-based authentication, role-based access control, transactional order processing, and a fully **BCNF-normalized** relational database with 23 tables.

---

## Table of Contents

- [Database Design](#database-design)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [API Endpoints](#api-endpoints)
- [Database Schema](#database-schema)
- [Security Features](#security-features)
- [Getting Started](#getting-started)
- [Example Requests](#example-requests)
- [Environment Variables](#environment-variables)
- [Author](#author)

---

## Database Design

The database is fully **BCNF-normalized** across 23 tables. All design documents are in the [`docs/`](./docs/) folder:

| Document | Description |
|---|---|
| [ER_Diagram.pdf](./docs/ER_Diagram.pdf) | Entity-Relationship diagram — all entities, attributes, and relationships |
| [Relational_Schema.pdf](./docs/Relational_Schema.pdf) | Final relational table schema derived from the ER diagram |
| [BCNF_Proof.pdf](./docs/BCNF_Proof.pdf) | Formal proof that all 23 relations satisfy Boyce-Codd Normal Form |
| [sample_inserts.sql](./docs/sample_inserts.sql) | 300+ line SQL seed script — populates all 23 tables with realistic data (10 rows each) |
| [queries.sql](./docs/queries.sql) | 11 analytical SQL queries — JOINs, aggregations, subqueries, UNION, pagination |
| [01\_ddl.sql](./docs/01_ddl.sql) | Full DDL — `CREATE TABLE` for all 23 tables with `CHECK`, `ENUM`, `FK`, `NOT NULL` constraints (MySQL 8.0) |
| [02\_indexes.sql](./docs/02_indexes.sql) | 40+ performance indexes on FK, filter, sort, and search columns across all tables |
| [03\_views\_triggers.sql](./docs/03_views_triggers.sql) | 3 views (`v_order_summary`, `v_restaurant_leaderboard`, `v_menu_with_category`), 4 triggers (rating sync, wallet debit/credit), and `place_order` stored procedure |
| [04\_security.sql](./docs/04_security.sql) | MySQL DB users with least-privilege `GRANT`/`REVOKE` — `qb_readonly`, `qb_app`, `qb_admin` |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Runtime | Node.js 18+ |
| Framework | Express.js 4.x |
| Database | MySQL 8.0 (via `mysql2` connection pool) |
| Authentication | JSON Web Tokens (JWT) |
| Password Security | bcryptjs (default 12 salt rounds) |
| Environment Config | dotenv |
| Dev Server | nodemon |

---

## Architecture

```
quickbite-food-delivery-api/
├── docs/
│   ├── ER_Diagram.pdf              # Entity-Relationship diagram
│   ├── Relational_Schema.pdf       # Relational table schema
│   ├── BCNF_Proof.pdf              # BCNF normalization proof
│   ├── sample_inserts.sql          # Seed data — all 23 tables, 10 rows each
│   ├── queries.sql                 # 11 SQL queries — JOINs, aggregations, subqueries
│   ├── 01_ddl.sql                  # Full DDL with constraints (MySQL 8.0)
│   ├── 02_indexes.sql              # 40+ performance indexes
│   ├── 03_views_triggers.sql       # Views, triggers & place_order stored proc
│   └── 04_security.sql             # MySQL users, GRANT/REVOKE
├── src/
│   ├── server.js                   # Entry point — HTTP server + graceful shutdown
│   ├── app.js                      # Express app factory — middleware, routes, error handling
│   ├── config/
│   │   └── db.js                   # MySQL connection pool + startup health check
│   ├── middleware/
│   │   ├── authMiddleware.js        # JWT verification (verifyToken)
│   │   └── roleMiddleware.js        # Role-based access control (requireRole)
│   ├── controllers/
│   │   ├── userController.js        # Register, Login, Profile, Update, Change Password
│   │   ├── restaurantController.js  # CRUD for restaurants
│   │   ├── menuController.js        # Menu items grouped by category
│   │   ├── cartController.js        # Cart management (add, update, remove, clear)
│   │   └── orderController.js       # Transactional order creation from cart
│   └── routes/
│       ├── userRoutes.js
│       ├── restaurantRoutes.js
│       ├── menuRoutes.js
│       ├── cartRoutes.js
│       └── orderRoutes.js
├── .env.example                    # Environment variable template
├── package.json
└── README.md
```

---

## API Endpoints

### Auth & Users — `/api/users`

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/register` | Public | Create account, returns JWT |
| `POST` | `/login` | Public | Authenticate, returns JWT |
| `GET` | `/profile` | JWT | Get own profile |
| `PUT` | `/profile` | JWT | Update name / phone / address |
| `PUT` | `/profile/password` | JWT | Change password (verifies current password) |

### Restaurants — `/api/restaurants`

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/` | Public | List all restaurants (`?search=` `?cuisine=`) |
| `GET` | `/:id` | Public | Single restaurant + category list |
| `POST` | `/` | JWT + Admin | Create restaurant |
| `PUT` | `/:id` | JWT + Admin/Owner | Update restaurant details |
| `PATCH` | `/:id/status` | JWT + Admin | Activate or deactivate |

### Menu — `/api/menu`

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/:restaurantId` | Public | Full menu grouped by category |

### Cart — `/api/cart`

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/` | JWT | View active cart with subtotal |
| `POST` | `/items` | JWT | Add item to cart |
| `PATCH` | `/items/:cartItemId` | JWT | Update item quantity (0 = remove) |
| `DELETE` | `/items/:cartItemId` | JWT | Remove single item |
| `DELETE` | `/` | JWT | Clear entire cart |

### Orders — `/api/orders`

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/` | JWT | Checkout — creates order from active cart |
| `GET` | `/` | JWT | Get all past orders for logged-in user |

---

## Database Schema

All 23 tables with their key columns:

| Table | Key Columns |
|---|---|
| `Users` | `UserID`, `User_Name`, `Phone_No`, `Email`, `Password`, `Role` |
| `User_Address` | `Add_ID`, `Add_line_1`, `Add_line_2`, `Area`, `City`, `Pincode` |
| `User_Has_Address` | `Add_ID` (FK), `UserID` (FK) — junction table |
| `Restaurant` | `Restaurant_ID`, `Name`, `Open_Time`, `Close_Time`, `FSSAI_License_No`, `Contact_No`, `Rating`, `Restaurant_Status` |
| `Restaurant_Address` | `Add_ID`, `Add_line_1`, `Area`, `City`, `Pincode`, `Restaurant_ID` (FK) |
| `Cuisine` | `Cuisine`, `Restaurant_ID` (FK) — multi-cuisine support |
| `Menu_Category` | `Category_Name`, `Type` (Veg/Non-Veg/Vegan), `Restaurant_ID` (FK) |
| `Menu_Item` | `Item_ID`, `Item_Name`, `Description`, `Price`, `Preparation_Time`, `Is_Available`, `Category_Name`, `Restaurant_ID` |
| `Review` | `Review_ID`, `Review`, `Rating`, `Restaurant_ID` (FK), `UserID` (FK), `Created_At` |
| `Cart` | `Cart_ID`, `Created_At`, `Status` (Active/Checked Out/Abandoned), `UserID` (FK) |
| `Cart_Item` | `Item_ID` (FK), `Cart_ID` (FK), `Quantity` |
| `Orders` | `OrderID`, `Date_Time`, `UserID` (FK), `Restaurant_ID` (FK), `Status`, `Total_Amount` |
| `Order_Item` | `Item_ID` (FK), `OrderID` (FK), `Quantity`, `Unit_Price` |
| `Payment` | `Transaction_ID`, `Mode` (UPI/Card/Cash/Wallet/NetBanking), `Status`, `Amount`, `Gateway_Ref`, `Paid_At`, `Order_ID` (FK) |
| `Delivery_Partner` | `Partner_ID`, `Name`, `Phone_No`, `Vehicle_No`, `Rating`, `Is_Active` |
| `Delivery` | `Delivery_ID`, `Pickup_Time`, `Delivery_Time`, `Status`, `OrderID` (FK), `Partner_ID` (FK) |
| `Wallet` | `Wallet_ID`, `Balance`, `Created_At`, `UserID` (FK) |
| `Wallet_Transaction` | `Transaction_ID`, `Wallet_ID` (FK), `Type` (Credit/Debit), `Amount`, `Date_Time` |
| `Wallet_TopUP` | `Transaction_ID` (FK), `Status`, `Payment_mode`, `Transaction_Ref`, `Wallet_ID` (FK) |
| `Discount` | `Discount_ID`, `Discount_PR`, `Discount_Amount`, `OrderID` (FK) |
| `Complaint` | `Complaint_ID`, `OrderID` (FK), `Issue_Type`, `Description`, `Status`, `Created_At`, `Resolved_At` |
| `Refund` | `Refund_ID`, `OrderID` (FK), `Complaint_ID` (FK), `Refund_Amount`, `Refund_Status`, `Wallet_ID` (FK) |
| `Cancellation` | `Cancellation_ID`, `Cancelled_By`, `Cancellation_Reason`, `Cancelled_At`, `Refund_Eligible`, `Penalty_Amount`, `OrderID` (FK) |

### DB Objects (Views, Triggers, Stored Procedure)

| Object | Type | Description |
|---|---|---|
| `v_order_summary` | View | Full order details: customer, restaurant, payment, delivery, discount |
| `v_restaurant_leaderboard` | View | Restaurant rankings: rating, reviews, orders, revenue, cancellations |
| `v_menu_with_category` | View | Menu items joined with category type (Veg/Non-Veg/Vegan) |
| `trg_update_restaurant_rating_insert` | Trigger | Auto-recalculates restaurant `Rating` on new review (AFTER INSERT) |
| `trg_update_restaurant_rating_update` | Trigger | Auto-recalculates restaurant `Rating` on review edit (AFTER UPDATE) |
| `trg_update_restaurant_rating_delete` | Trigger | Auto-recalculates restaurant `Rating` on review delete (AFTER DELETE) |
| `trg_wallet_credit_on_refund` | Trigger | Credits wallet balance when a refund status changes to `Completed` |
| `trg_wallet_debit_on_payment` | Trigger | Debits wallet balance on payment with mode `Wallet`, validates balance |
| `place_order` | Stored Procedure | Atomic order placement — validates cart, computes total, inserts order + items, marks cart checked out |

---

## Security Features

- **Password Hashing** — bcryptjs with configurable salt rounds (default: 12)
- **JWT Authentication** — stateless tokens with configurable expiry, verified on every protected route
- **Role-Based Access Control** — `admin`, `restaurant_owner`, `customer` roles enforced via middleware
- **SQL Injection Prevention** — 100% parameterized queries, zero string concatenation
- **User Enumeration Protection** — login always returns the same generic error regardless of whether email exists
- **Token Error Distinction** — expired tokens → `401`, invalid tokens → `403`
- **DB Transactions** — order creation is fully atomic; rolls back on any failure
- **Least-Privilege DB Users** — `qb_readonly` (SELECT only), `qb_app` (DML only), `qb_admin` (ALL)

---

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/Bansil08/quickbite-food-delivery-api.git
cd quickbite-food-delivery-api
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure environment variables
```bash
cp .env.example .env
```

Edit `.env` with your credentials:
```env
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=quick_bite_db
JWT_SECRET=your_super_secret_key
JWT_EXPIRES_IN=7d
BCRYPT_SALT_ROUNDS=12
```

### 4. Set up the database
```bash
# Run in order inside MySQL:
mysql -u root -p quick_bite_db < docs/01_ddl.sql
mysql -u root -p quick_bite_db < docs/02_indexes.sql
mysql -u root -p quick_bite_db < docs/03_views_triggers.sql
mysql -u root -p quick_bite_db < docs/04_security.sql
mysql -u root -p quick_bite_db < docs/sample_inserts.sql
```

### 5. Run the server
```bash
# Development (auto-restart on file changes)
npm run dev

# Production
npm start
```

### 6. Health check
```
GET http://localhost:3000/health
```

---

## Example Requests

### Register
```bash
curl -X POST http://localhost:3000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Aryan","email":"aryan@mail.com","password":"secret123"}'
```

### Login
```bash
curl -X POST http://localhost:3000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{"email":"aryan@mail.com","password":"secret123"}'
```

### Access a protected route
```bash
curl http://localhost:3000/api/users/profile \
  -H "Authorization: Bearer <your_jwt_token>"
```

### Browse restaurants
```bash
curl "http://localhost:3000/api/restaurants?cuisine=Indian"
```

### Add to cart
```bash
curl -X POST http://localhost:3000/api/cart/items \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{"itemId": 3, "quantity": 2}'
```

### Place an order
```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{"paymentMode": "UPI"}'
```

---

## Environment Variables

| Variable | Description | Default |
|---|---|---|
| `PORT` | Server port | `3000` |
| `DB_HOST` | MySQL host | `localhost` |
| `DB_PORT` | MySQL port | `3306` |
| `DB_USER` | MySQL username | `root` |
| `DB_PASSWORD` | MySQL password | — |
| `DB_NAME` | Database name | `quick_bite_db` |
| `JWT_SECRET` | Secret key for signing JWTs | — |
| `JWT_EXPIRES_IN` | Token expiry duration | `7d` |
| `BCRYPT_SALT_ROUNDS` | bcrypt hashing rounds | `12` |
| `FRONTEND_URL` | Allowed CORS origin | `*` |

---

## Author

**Bansil** — [GitHub @Bansil08](https://github.com/Bansil08)
