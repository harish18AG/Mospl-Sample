# MOSPL Postman API Testing Guide

Base URL: `http://localhost:5000`

## 1. Health

`GET /health`

## 2. Register

`POST /api/auth/register`

```json
{
  "name": "Aarav Sharma",
  "email": "aarav@example.com",
  "phone": "+919876543210",
  "password": "Password@123"
}
```

Save `data.token` as `customerToken`.

## 3. Login

`POST /api/auth/login`

```json
{ "email": "aarav@example.com", "password": "Password@123" }
```

## 4. OTP test login

- `POST /api/auth/otp-login` with `{ "phone": "+919876543210" }`.
- `POST /api/auth/verify-otp` with `{ "phone": "+919876543210", "otp": "123456" }`.

## 5. Products

- `GET /api/products`
- `GET /api/products/search?q=wallet`
- `GET /api/products/featured`
- `GET /api/products/bestsellers`

## 6. Cart

Use `Authorization: Bearer {{customerToken}}`.

`POST /api/cart/add`

```json
{
  "userId": "{{uid}}",
  "productId": "wallet-01",
  "quantity": 1,
  "selectedColor": "Tan Brown",
  "selectedSize": "One Size",
  "price": 1499
}
```

## 7. Create order

`POST /api/orders/create`

```json
{
  "products": [{ "productId": "wallet-01", "name": "MOSPL Wallet", "quantity": 1, "price": 1499, "categoryName": "Wallets" }],
  "shippingAddress": { "name": "Aarav", "phone": "+919876543210", "line1": "Anna Salai", "city": "Chennai", "state": "Tamil Nadu", "pincode": "600002" },
  "paymentMethod": "razorpay"
}
```

Save `data.order.orderId`.

## 8. Create Razorpay order

`POST /api/payments/create-order`

```json
{ "orderId": "{{orderId}}" }
```

## 9. Verify payment

Use Razorpay Checkout response values in this request:

`POST /api/payments/verify`

```json
{
  "orderId": "{{orderId}}",
  "razorpayOrderId": "order_xxx",
  "razorpayPaymentId": "pay_xxx",
  "razorpaySignature": "signature_from_checkout"
}
```

## 10. Admin APIs

Login as a seeded admin, save `adminToken`, then use:

- `GET /api/admin/dashboard`
- `GET /api/admin/sales`
- `GET /api/admin/revenue`
- `GET /api/admin/low-stock`
- `GET /api/ai/admin-sales-insights`
