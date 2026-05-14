# MOSPL Setup Guide

## 1. Firebase project

1. Open Firebase Console and create a project for MOSPL.
2. Enable Authentication providers: Email/Password, Phone, and Google.
3. Create a Firestore database.
4. Enable Firebase Storage.
5. Go to Project Settings > Service Accounts > Generate new private key.
6. Save the downloaded JSON as `backend/serviceAccountKey.json` for local development, or copy its values into backend `.env`.
7. Publish `firebase/firestore.rules` in Firestore Rules.

## 2. Backend dependencies

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

Local API URL: `http://localhost:5000`. Android emulator URL: `http://10.0.2.2:5000`.

## 3. Seed Firestore

```bash
cd backend
npm run seed
```

This creates categories, 120 premium leather products, admin profile data, and analytics placeholders.

## 4. Razorpay test account

1. Create or open a Razorpay account.
2. Switch to Test Mode.
3. Copy Key ID and Key Secret.
4. Set them in `backend/.env`:

```env
RAZORPAY_KEY_ID=rzp_test_dummyKeyId
RAZORPAY_KEY_SECRET=rzp_test_dummyKeySecret
```

Use real test keys in local/staging. Never commit live keys.

## 5. Flutter app

```bash
flutter pub get
flutterfire configure
flutter run --dart-define=MOSPL_API_BASE_URL=http://10.0.2.2:5000/api
```

If platform folders are missing, run:

```bash
flutter create --platforms=android .
```

## 6. Payment testing

1. Create an order from Flutter or Postman.
2. Create a Razorpay order through `POST /api/payments/create-order`.
3. Open Razorpay Checkout in Flutter using `razorpay_flutter`.
4. Verify success with `POST /api/payments/verify`.
5. Fetch invoice data with `GET /api/payments/invoice/:orderId`.

## 7. Deployment later

- Deploy the backend to Cloud Run, App Engine, Firebase Functions, Render, Railway, or another HTTPS Node host.
- Store secrets in Secret Manager or host-level environment variables.
- Set `NODE_ENV=production` and restrict `CORS_ORIGINS`.
- Use Firebase custom claims for admin users.
- Monitor payment webhooks and order fulfillment jobs in production.

## Additional guides

- Backend README: `backend/README.md`.
- Flutter integration: `docs/flutter_backend_integration.md`.
- Postman testing: `backend/docs/api_testing_postman.md`.
- Firestore schema: `firebase/firestore_schema.md`.
