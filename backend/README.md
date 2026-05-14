# MOSPL Backend

Production-level Node.js + Express backend for the MOSPL premium leather e-commerce Flutter app by onlinemadras.com. It uses Firebase Authentication, Firestore, Firebase Storage, JWT, Razorpay test payments, admin APIs, analytics, notifications, and rule-based AI services.

## Features

- Firebase Authentication + JWT sessions.
- Email/password, Google token, and OTP test login (`123456`) endpoints.
- Product, category, cart, wishlist, review, order, notification, admin, analytics, and AI APIs.
- Razorpay test-mode order creation, HMAC SHA256 signature verification, payment persistence, invoice data, failed payment logging, and refund requests.
- Firebase Storage image upload with `multer` memory uploads.
- Role-based access control, Helmet, CORS, rate limiting, validation, and centralized error handling.

## Setup

1. Create a Firebase project.
2. Enable Firebase Authentication providers: Email/Password, Phone, and Google.
3. Create a Firestore database in production or test mode.
4. Enable Firebase Storage.
5. Download a Firebase Admin service account JSON and save it as `backend/serviceAccountKey.json` for local development, or set `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, and `FIREBASE_PRIVATE_KEY` in `.env`.
6. Create a Razorpay test account from the Razorpay dashboard.
7. Copy test keys into `.env` as `RAZORPAY_KEY_ID` and `RAZORPAY_KEY_SECRET`. Dummy defaults are included for scaffold development only.
8. Install and run:

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

## Seed data

```bash
cd backend
npm run seed
```

This seeds 10 categories, 120 products, an admin user, and dashboard analytics placeholders. Default seeded admin: `admin@onlinemadras.com` / `Admin@123456`.

## Payment flow

1. Flutter creates an order with `POST /api/orders/create`.
2. Flutter calls `POST /api/payments/create-order` with the MOSPL `orderId`.
3. Backend creates a Razorpay order and returns `razorpayOrderId`, paise `amount`, `currency`, and `keyId`.
4. Flutter opens Razorpay Checkout.
5. Flutter sends `orderId`, `razorpayOrderId`, `razorpayPaymentId`, and `razorpaySignature` to `POST /api/payments/verify`.
6. Backend validates `razorpay_order_id|razorpay_payment_id` using HMAC SHA256 and the Razorpay key secret.
7. Backend stores the payment in Firestore and updates the order to `confirmed` / `paid`.
8. Flutter displays success or failure and can fetch invoice data from `GET /api/payments/invoice/:orderId`.

## Deployment notes

- Never commit real Firebase service accounts or live Razorpay keys.
- Use HTTPS, Secret Manager, and restricted service account permissions in production.
- Deploy behind Cloud Run, App Engine, Firebase Functions, or a container platform.
- Configure `CORS_ORIGINS` to exact production domains and app gateway origins.
