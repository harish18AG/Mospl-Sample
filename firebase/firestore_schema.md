# MOSPL Firestore Schema Design

## Architecture Goals
- Fast product browsing/filtering by category/price/in-stock
- User-centric reads (cart, wishlist, orders) with low document fan-out
- Append-only order + review writes for auditability
- Security-rule friendly ownership boundaries

## Collections

### 1) `users/{userId}`
```json
{
  "name": "Ava Miller",
  "phone": "+15551234567",
  "email": "ava@example.com",
  "address": {
    "line1": "123 Main St",
    "city": "Austin",
    "state": "TX",
    "zip": "78701",
    "country": "US"
  },
  "wishlistCount": 2,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```
Subcollections:
- `users/{userId}/wishlist/{productId}`
```json
{ "productId": "prod_001", "addedAt": "timestamp" }
```
- `users/{userId}/addresses/{addressId}`
- `users/{userId}/cart/{productId}`
```json
{ "productId": "prod_001", "qty": 2, "priceSnapshot": 49.99, "updatedAt": "timestamp" }
```

### 2) `products/{productId}`
```json
{
  "name": "Premium Leather Wallet",
  "category": "wallets",
  "price": 49.99,
  "description": "Full-grain leather wallet",
  "images": ["https://.../wallet-1.jpg", "https://.../wallet-2.jpg"],
  "stock": 140,
  "isActive": true,
  "ratingAvg": 4.6,
  "ratingCount": 231,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### 3) `orders/{orderId}`
```json
{
  "userId": "uid_123",
  "productList": [
    {"productId": "prod_001", "name": "Premium Leather Wallet", "qty": 2, "unitPrice": 49.99, "lineTotal": 99.98}
  ],
  "totalAmount": 99.98,
  "status": "PLACED",
  "shippingAddress": {"line1": "123 Main St", "city": "Austin", "state": "TX", "zip": "78701", "country": "US"},
  "payment": {"method": "CARD", "status": "PAID"},
  "timestamp": "timestamp",
  "updatedAt": "timestamp"
}
```

### 4) `reviews/{reviewId}`
```json
{
  "productId": "prod_001",
  "userId": "uid_123",
  "rating": 5,
  "comment": "Excellent finish and stitching.",
  "createdAt": "timestamp"
}
```

### 5) `admins/{adminId}`
```json
{ "role": "SUPER_ADMIN", "permissions": ["PRODUCT_WRITE", "ORDER_WRITE", "ANALYTICS_READ"], "createdAt": "timestamp" }
```

## Firebase Authentication (OTP Login)
- Use **Phone Auth** as primary sign-in.
- `userId` in Firestore must match Firebase Auth `uid`.
- First login flow:
  1. Verify OTP via Firebase Auth.
  2. Upsert `users/{uid}` with `phone`, timestamps, optional profile fields.

## Firebase Storage (Product Images)
- Bucket path: `products/{productId}/{imageId}.jpg`
- Store final CDN URL in `products.images[]`.
- Keep max 8 images per product for mobile performance.

## Query Patterns
- Product listing: `where(isActive==true).where(category==X).orderBy(price).limit(20)`
- New arrivals: `where(isActive==true).orderBy(createdAt, desc).limit(20)`
- User orders: `where(userId==uid).orderBy(timestamp, desc).limit(20)`
- Product reviews: `where(productId==id).orderBy(createdAt, desc).limit(20)`

## Indexing Strategy (Composite)
1. `products`: `isActive ASC, category ASC, price ASC`
2. `products`: `isActive ASC, createdAt DESC`
3. `orders`: `userId ASC, timestamp DESC`
4. `reviews`: `productId ASC, createdAt DESC`
5. `orders`: `status ASC, timestamp DESC` (admin dashboard)

## Write/Consistency Notes
- Use Cloud Functions trigger on `reviews/*` to update `products.ratingAvg/ratingCount`.
- Use transaction for checkout: validate stock, decrement stock, create order, clear user cart atomically.
- Keep order line item snapshots to preserve historical pricing.
