// lib/models/models.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String categoryId;
  final String categoryName;
  final double originalPrice;
  final double offerPrice;
  final int discountPercentage;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final int stockCount;
  final List<String> availableColors;
  final List<String> availableSizes;
  final String brand;
  final String sku;
  final Map<String, dynamic> deliveryInfo;
  final List<String> tags;
  final bool isFeatured;
  final bool isNewArrival;
  final bool isBestSeller;
  final bool isTrending;
  final Map<String, dynamic> specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.categoryId,
    required this.categoryName,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercentage,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.stockCount,
    required this.availableColors,
    required this.availableSizes,
    required this.brand,
    required this.sku,
    required this.deliveryInfo,
    required this.tags,
    required this.isFeatured,
    required this.isNewArrival,
    required this.isBestSeller,
    required this.isTrending,
    required this.specifications,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOnOffer => discountPercentage > 0;
  bool get isInStock => stockCount > 0;
  double get savings => originalPrice - offerPrice;
  String get formattedPrice => '₹${offerPrice.toStringAsFixed(0)}';
  String get formattedOriginalPrice => '₹${originalPrice.toStringAsFixed(0)}';

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      longDescription: data['longDescription'] ?? '',
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      originalPrice: (data['originalPrice'] ?? 0).toDouble(),
      offerPrice: (data['offerPrice'] ?? 0).toDouble(),
      discountPercentage: data['discountPercentage'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      stockCount: data['stockCount'] ?? 0,
      availableColors: List<String>.from(data['availableColors'] ?? []),
      availableSizes: List<String>.from(data['availableSizes'] ?? []),
      brand: data['brand'] ?? 'MOSPL',
      sku: data['sku'] ?? '',
      deliveryInfo: Map<String, dynamic>.from(data['deliveryInfo'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
      isFeatured: data['isFeatured'] ?? false,
      isNewArrival: data['isNewArrival'] ?? false,
      isBestSeller: data['isBestSeller'] ?? false,
      isTrending: data['isTrending'] ?? false,
      specifications: Map<String, dynamic>.from(data['specifications'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'originalPrice': originalPrice,
      'offerPrice': offerPrice,
      'discountPercentage': discountPercentage,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'stockCount': stockCount,
      'availableColors': availableColors,
      'availableSizes': availableSizes,
      'brand': brand,
      'sku': sku,
      'deliveryInfo': deliveryInfo,
      'tags': tags,
      'isFeatured': isFeatured,
      'isNewArrival': isNewArrival,
      'isBestSeller': isBestSeller,
      'isTrending': isTrending,
      'specifications': specifications,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? originalPrice,
    double? offerPrice,
    int? stockCount,
    bool? isFeatured,
    bool? isNewArrival,
    bool? isBestSeller,
    bool? isTrending,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortDescription: shortDescription,
      longDescription: longDescription,
      categoryId: categoryId,
      categoryName: categoryName,
      originalPrice: originalPrice ?? this.originalPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      discountPercentage: discountPercentage,
      images: images,
      rating: rating,
      reviewCount: reviewCount,
      stockCount: stockCount ?? this.stockCount,
      availableColors: availableColors,
      availableSizes: availableSizes,
      brand: brand,
      sku: sku,
      deliveryInfo: deliveryInfo,
      tags: tags,
      isFeatured: isFeatured ?? this.isFeatured,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isTrending: isTrending ?? this.isTrending,
      specifications: specifications,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// lib/models/category_model.dart
class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String icon;
  final int productCount;
  final int sortOrder;
  final bool isActive;
  final String slug;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.productCount,
    required this.sortOrder,
    required this.isActive,
    required this.slug,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      icon: data['icon'] ?? '',
      productCount: data['productCount'] ?? 0,
      sortOrder: data['sortOrder'] ?? 0,
      isActive: data['isActive'] ?? true,
      slug: data['slug'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'icon': icon,
    'productCount': productCount,
    'sortOrder': sortOrder,
    'isActive': isActive,
    'slug': slug,
  };
}

// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String role; // 'user' | 'admin'
  final List<Map<String, dynamic>> addresses;
  final int rewardPoints;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final bool isActive;
  final String? referralCode;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.role,
    required this.addresses,
    required this.rewardPoints,
    required this.preferences,
    required this.createdAt,
    required this.isActive,
    this.referralCode,
  });

  bool get isAdmin => role == 'admin';

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      profileImage: data['profileImage'],
      role: data['role'] ?? 'user',
      addresses: List<Map<String, dynamic>>.from(data['addresses'] ?? []),
      rewardPoints: data['rewardPoints'] ?? 0,
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      referralCode: data['referralCode'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
    'role': role,
    'addresses': addresses,
    'rewardPoints': rewardPoints,
    'preferences': preferences,
    'createdAt': createdAt,
    'isActive': isActive,
    'referralCode': referralCode,
  };
}

// lib/models/order_model.dart
class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final Map<String, dynamic> shippingAddress;
  final String? couponCode;
  final String? trackingId;
  final List<OrderStatusHistory> statusHistory;
  final DateTime createdAt;
  final DateTime estimatedDelivery;
  final int rewardPointsEarned;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.shippingAddress,
    this.couponCode,
    this.trackingId,
    required this.statusHistory,
    required this.createdAt,
    required this.estimatedDelivery,
    required this.rewardPointsEarned,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      deliveryCharge: (data['deliveryCharge'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      orderStatus: data['orderStatus'] ?? '',
      shippingAddress: Map<String, dynamic>.from(data['shippingAddress'] ?? {}),
      couponCode: data['couponCode'],
      trackingId: data['trackingId'],
      statusHistory: (data['statusHistory'] as List<dynamic>? ?? [])
          .map((s) => OrderStatusHistory.fromMap(s as Map<String, dynamic>))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      estimatedDelivery: (data['estimatedDelivery'] as Timestamp?)?.toDate() ?? DateTime.now().add(const Duration(days: 5)),
      rewardPointsEarned: data['rewardPointsEarned'] ?? 0,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      selectedColor: map['selectedColor'],
      selectedSize: map['selectedSize'],
    );
  }

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'price': price,
    'quantity': quantity,
    'selectedColor': selectedColor,
    'selectedSize': selectedSize,
  };
}

class OrderStatusHistory {
  final String status;
  final String message;
  final DateTime timestamp;

  OrderStatusHistory({
    required this.status,
    required this.message,
    required this.timestamp,
  });

  factory OrderStatusHistory.fromMap(Map<String, dynamic> map) {
    return OrderStatusHistory(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

// lib/models/cart_model.dart
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final int maxStock;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    required this.maxStock,
  });

  double get totalPrice => price * quantity;
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedTotal => '₹${totalPrice.toStringAsFixed(0)}';

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      selectedColor: map['selectedColor'],
      selectedSize: map['selectedSize'],
      maxStock: map['maxStock'] ?? 10,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'price': price,
    'quantity': quantity,
    'selectedColor': selectedColor,
    'selectedSize': selectedSize,
    'maxStock': maxStock,
  };
}

// lib/models/review_model.dart
class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userImage;
  final double rating;
  final String title;
  final String comment;
  final List<String> images;
  final bool isVerifiedPurchase;
  final DateTime createdAt;
  final int helpfulCount;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.rating,
    required this.title,
    required this.comment,
    required this.images,
    required this.isVerifiedPurchase,
    required this.createdAt,
    required this.helpfulCount,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userImage: data['userImage'],
      rating: (data['rating'] ?? 0).toDouble(),
      title: data['title'] ?? '',
      comment: data['comment'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      isVerifiedPurchase: data['isVerifiedPurchase'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      helpfulCount: data['helpfulCount'] ?? 0,
    );
  }
}

// lib/models/coupon_model.dart
class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String discountType; // 'flat' | 'percentage'
  final double discountValue;
  final double minOrderValue;
  final double maxDiscount;
  final int usageLimit;
  final int usedCount;
  final DateTime expiryDate;
  final bool isActive;
  final List<String> applicableCategories;

  CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    required this.maxDiscount,
    required this.usageLimit,
    required this.usedCount,
    required this.expiryDate,
    required this.isActive,
    required this.applicableCategories,
  });

  bool get isExpired => expiryDate.isBefore(DateTime.now());
  bool get isValid => isActive && !isExpired && usedCount < usageLimit;

  double calculateDiscount(double orderTotal) {
    if (!isValid || orderTotal < minOrderValue) return 0;
    double discount = discountType == 'percentage'
        ? (orderTotal * discountValue / 100)
        : discountValue;
    return discount > maxDiscount ? maxDiscount : discount;
  }

  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CouponModel(
      id: doc.id,
      code: data['code'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      discountType: data['discountType'] ?? 'flat',
      discountValue: (data['discountValue'] ?? 0).toDouble(),
      minOrderValue: (data['minOrderValue'] ?? 0).toDouble(),
      maxDiscount: (data['maxDiscount'] ?? 0).toDouble(),
      usageLimit: data['usageLimit'] ?? 100,
      usedCount: data['usedCount'] ?? 0,
      expiryDate: (data['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      applicableCategories: List<String>.from(data['applicableCategories'] ?? []),
    );
  }
}