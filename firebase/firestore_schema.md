# MOSPL Firestore Schema

## Collections

### `users/{uid}`
Fields: `uid`, `name`, `email`, `phone`, `profileImage`, `role`, `addresses[]`, `createdAt`, `updatedAt`, `lastLogin`, `isBlocked`, `rewardPoints`, `loginProvider`.

### `admins/{uid}`
Fields: `uid`, `name`, `email`, `phone`, `role`, `permissions[]`, `createdAt`, `updatedAt`, `lastLogin`, `isBlocked`.

### `products/{productId}`
Fields: `productId`, `name`, `categoryId`, `categoryName`, `shortDescription`, `longDescription`, `price`, `offerPrice`, `discountPercentage`, `images[]`, `rating`, `reviewCount`, `stock`, `colors[]`, `sizes[]`, `material`, `brand`, `tags[]`, `isFeatured`, `isBestSeller`, `isNewArrival`, `deliveryInfo`, `createdAt`, `updatedAt`.

### `categories/{categoryId}`
Fields: `categoryId`, `name`, `description`, `heroImage`, `productCount`, `sortOrder`, `active`, `createdAt`, `updatedAt`.

### `cart/{userId}`
Fields: `userId`, `items[{ productId, quantity, selectedColor, selectedSize, price, addedAt }]`, `createdAt`, `updatedAt`.

### `wishlist/{userId}`
Fields: `userId`, `productIds[]`, `createdAt`, `updatedAt`.

### `orders/{orderId}`
Fields: `orderId`, `userId`, `products[]`, `totalAmount`, `discountAmount`, `deliveryCharge`, `finalAmount`, `paymentStatus`, `paymentMethod`, `razorpayOrderId`, `razorpayPaymentId`, `orderStatus`, `shippingAddress`, `trackingStatus`, `createdAt`, `updatedAt`.

### `payments/{paymentId}`
Fields: `paymentId`, `userId`, `orderId`, `razorpayOrderId`, `razorpayPaymentId`, `razorpaySignature`, `amount`, `currency`, `status`, `method`, `createdAt`.

### `reviews/{reviewId}`
Fields: `reviewId`, `productId`, `userId`, `userName`, `rating`, `comment`, `images[]`, `createdAt`, `isApproved`.

### `coupons/{couponId}`
Fields: `code`, `discountType`, `discountValue`, `minCartValue`, `usageLimit`, `usedCount`, `validFrom`, `validTo`, `active`.

### `banners/{bannerId}`
Fields: `title`, `subtitle`, `imageUrl`, `targetRoute`, `sortOrder`, `active`, `startsAt`, `endsAt`.

### `notifications/{notificationId}`
Fields: `userId`, `title`, `body`, `type`, `read`, `payload`, `createdAt`.

### `tracking/{orderId}`
Fields: `orderId`, `courier`, `awb`, `status`, `timeline[]`, `expectedDelivery`, `updatedAt`.

### `returns/{returnId}`
Fields: `returnId`, `userId`, `orderId`, `items[]`, `reason`, `status`, `pickupSlot`, `createdAt`, `updatedAt`.

### `refunds/{refundId}`
Fields: `refundId`, `userId`, `orderId`, `paymentId`, `amount`, `status`, `reason`, `razorpayRefundId`, `createdAt`, `updatedAt`.

### `settings/{userId}`
Fields: `account`, `notifications`, `privacy`, `payment`, `preferences`, `ai`, `updatedAt`.

### `analytics/{docId}`
Fields: `totalUsers`, `totalOrders`, `totalRevenue`, `totalProducts`, `monthlySales[]`, `categorySales[]`, `topSellingProducts[]`, `lowStockProducts[]`, `dailyVisitors`, `updatedAt`.

### `activity_logs/{logId}`
Fields: `actorId`, `role`, `action`, `entity`, `metadata`, `ip`, `createdAt`.

### `support_tickets/{ticketId}`
Fields: `ticketId`, `userId`, `subject`, `messages[]`, `priority`, `status`, `assignedTo`, `createdAt`, `updatedAt`.

### `ai_recommendations/{userId}`
Fields: `userId`, `productIds[]`, `signals`, `modelVersion`, `createdAt`, `updatedAt`.

## Recommended indexes

- `products`: `categoryId ASC, offerPrice ASC`; `isFeatured ASC, rating DESC`; `isBestSeller ASC, rating DESC`.
- `orders`: `userId ASC, createdAt DESC`; `orderStatus ASC, createdAt DESC`.
- `payments`: `userId ASC, createdAt DESC`; `orderId ASC`.
- `reviews`: `productId ASC, createdAt DESC`; `isApproved ASC, createdAt DESC`.
- `activity_logs`: `actorId ASC, createdAt DESC`.
