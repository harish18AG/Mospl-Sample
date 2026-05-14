# Flutter Integration Guide for MOSPL Backend and Razorpay

## pubspec additions

```yaml
dependencies:
  http: ^1.2.2
  razorpay_flutter: ^1.3.7
```

## Service files to create

Create these Flutter services under `lib/services/`:

- `auth_service.dart`: register, login, Google login, OTP login, profile, logout.
- `product_service.dart`: product list, details, category, featured, bestsellers, search.
- `cart_service.dart`: get, add, update, remove, clear.
- `wishlist_service.dart`: get, add, remove.
- `order_service.dart`: create order, list user orders, tracking, cancel.
- `payment_service.dart`: create Razorpay order, verify payment, history, refund, invoice.
- `admin_service.dart`: dashboard, users, block, orders, sales, revenue, low stock, analytics.
- `ai_service.dart`: recommendations, chatbot, smart search, admin sales insights.

## Razorpay payment flow in Flutter

1. Call `POST /api/orders/create` with cart items and shipping address.
2. Call `POST /api/payments/create-order` with the returned MOSPL `orderId`.
3. Open Razorpay Checkout with backend response values:

```dart
final options = {
  'key': response['keyId'],
  'amount': response['amount'],
  'currency': response['currency'],
  'order_id': response['razorpayOrderId'],
  'name': 'MOSPL',
  'description': 'Premium leather order',
  'prefill': {'contact': user.phone, 'email': user.email},
  'theme': {'color': '#3A2418'},
};
razorpay.open(options);
```

4. In `PaymentSuccessResponse`, call `POST /api/payments/verify`:

```dart
await paymentService.verifyPayment(
  orderId: mosplOrderId,
  razorpayOrderId: response.orderId!,
  razorpayPaymentId: response.paymentId!,
  razorpaySignature: response.signature!,
);
```

5. Navigate to a success screen after backend verification succeeds. If Razorpay fails, call `POST /api/payments/failed` and show a retry screen.

## Android notes

- Use `http://10.0.2.2:5000` for Android emulator local backend access.
- Use HTTPS production URL after deployment.
- Store JWT in secure storage and pass `Authorization: Bearer <token>` for protected APIs.
