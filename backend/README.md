# MOSPL Backend (Spring Boot + Kotlin)

## Features
- REST API architecture with layered controllers/services/repositories
- JWT authentication and secure endpoints
- Modules: Auth, Product, Cart, Order, User, Admin
- PostgreSQL-ready JPA models
- Firebase Admin SDK dependency included for optional Firebase integration
- Image upload endpoint
- Pagination support on products
- Global error handling with standardized responses

## Run
```bash
cd backend
./gradlew bootRun
```

## Key Endpoints
- `POST /api/auth/register` (phone + OTP + password)
- `POST /api/auth/login`
- `POST /api/products`
- `GET /api/products?page=0&size=20`
- `GET /api/products/category/{category}`
- `POST /api/cart/{userId}`
- `POST /api/orders`
- `PUT /api/users/{userId}/profile`
- `GET /api/admin/sales-analytics`
