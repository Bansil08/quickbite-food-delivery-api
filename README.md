# QuickBite Food Delivery API

A production-ready **RESTful backend API** for a food delivery platform, built with **Node.js**, **Express.js**, and **MySQL**. Features JWT-based authentication, role-based access control, transactional order processing, and a fully normalized relational database schema.

---

## Database Design

The database is fully **BCNF-normalized**. All design documents are in the [`docs/`](./docs/) folder:

| Document | Description |
|---|---|
| [ER_Diagram.pdf](./docs/ER_Diagram.pdf) | Entity-Relationship diagram — all entities, attributes, and relationships |
| [Relational_Schema.pdf](./docs/Relational_Schema.pdf) | Final relational table schema derived from the ER diagram |
| [BCNF_Proof.pdf](./docs/BCNF_Proof.pdf) | Formal proof that all relations satisfy Boyce-Codd Normal Form |
| [sample_inserts.sql](./docs/sample_inserts.sql) | 301-line SQL script — seeds all 23 tables (Users, Restaurants, Menu, Orders, Cart, Payment, Delivery, Wallet, Refund, Complaints, Cancellations) with 10 rows each |
| [queries.sql](./docs/queries.sql) | SQL queries — JOINs, aggregations, subqueries, and analytical queries on the Quick-Bite schema |
| [01\_ddl.sql](./docs/01_ddl.sql) | Full DDL — CREATE TABLE for all 23 tables with CHECK, ENUM, FK constraints (MySQL 8.0) |
| [02\_indexes.sql](./docs/02_indexes.sql) | Performance indexes on FK, filter, and sort columns across all tables |
| [03\_views\_triggers.sql](./docs/03_views_triggers.sql) | Views (order summary, restaurant leaderboard, menu), triggers (rating sync, wallet), and `place_order` stored procedure |
| [04\_security.sql](./docs/04_security.sql) | MySQL DB users with least-privilege GRANT/REVOKE — `qb_readonly`, `qb_app`, `qb_admin` |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Runtime | Node.js |
| Framework | Express.js |
| Database | MySQL (via `mysql2` connection pool) |
| Authentication | JSON Web Tokens (JWT) |
| Password Security | bcryptjs |
| Environment Config | dotenv |

---

## Architecture

```
quickbite-food-delivery-api/
├── docs/
│   ├── ER_Diagram.pdf              # Entity-Relationship diagram
│   ├── Relational_Schema.pdf       # Relational table schema
│   ├── BCNF_Proof.pdf              # BCNF normalization proof
│   ├── sample_inserts.sql          # Seed data — all 23 tables, 10 rows each
│   ├── queries.sql                 # SQL queries — JOINs, aggregations, subqueries
│   ├── 01_ddl.sql                  # Full DDL with constraints (MySQL 8.0)
│   ├── 02_indexes.sql              # Performance indexes
│   ├── 03_views_triggers.sql       # Views, triggers & place_order stored proc
│   └── 04_security.sql             # MySQL users, GRANT/REVOKE
├── src/
│   ├── server.js               # Entry point — HTTP server + graceful shutdown
│   ├── app.js                  # Express app factory — middleware, routes, error handling
│   ├── config/
│   │   └── db.js               # MySQL connection pool + startup health check
│   ├── middleware/
│   │   ├── authMiddleware.js   # JWT verification (verifyToken)
│   │   └── roleMiddleware.js   # Role-based access control (requireRole)
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
├── .env.example                # Environment variable template
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

## Security Features

- **Password Hashing** — bcryptjs with configurable salt rounds (default: 12)
- **JWT Authentication** — stateless tokens with expiry, verified on every protected route
- **Role-Based Access Control** — `admin`, `restaurant_owner`, `customer` roles enforced via middleware
- **SQL Injection Prevention** — 100% parameterized queries, no string concatenation
- **User Enumeration Protection** — login always returns the same error regardless of whether email exists
- **Token Error Distinction** — expired tokens → 401, invalid tokens → 403
- **DB Transactions** — order creation is fully atomic; rolls back on any failure

---

## Database Schema (Expected Tables)

| Table | Key Columns |
|---|---|
| `Users` | `User_ID`, `Name`, `Email`, `Password_Hash`, `Phone`, `Address`, `Role` |
| `Restaurants` | `Restaurant_ID`, `Name`, `Address`, `Cuisine_Type`, `Rating`, `Is_Active`, `Owner_ID` |
| `Menu_Categories` | `Category_ID`, `Category_Name` |
| `Menu_Items` | `Item_ID`, `Restaurant_ID`, `Category_ID`, `Name`, `Price`, `Is_Available` |
| `Carts` | `Cart_ID`, `User_ID`, `Restaurant_ID`, `Status` |
| `Cart_Items` | `Cart_Item_ID`, `Cart_ID`, `Item_ID`, `Quantity` |
| `Orders` | `Order_ID`, `User_ID`, `Restaurant_ID`, `Total_Amount`, `Status` |
| `Order_Items` | `Order_Item_ID`, `Order_ID`, `Item_ID`, `Quantity`, `Unit_Price` |

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

### 4. Run the server
```bash
# Development (auto-restart on file changes)
npm run dev

# Production
npm start
```

### 5. Health check
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
