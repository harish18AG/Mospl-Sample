class Review {
  const Review({required this.user, required this.comment, required this.rating});
  final String user;
  final String comment;
  final double rating;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        user: json['user'] as String,
        comment: json['comment'] as String,
        rating: (json['rating'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {'user': user, 'comment': comment, 'rating': rating};
}

class Product {
  const Product({
    required this.id,
    required this.category,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.offerPrice,
    required this.discountPercentage,
    required this.images,
    required this.rating,
    required this.stockCount,
    required this.colors,
    required this.sizes,
    required this.deliveryInfo,
    required this.reviews,
  });

  final String id;
  final String category;
  final String name;
  final String shortDescription;
  final String longDescription;
  final int price;
  final int offerPrice;
  final int discountPercentage;
  final List<String> images;
  final double rating;
  final int stockCount;
  final List<String> colors;
  final List<String> sizes;
  final String deliveryInfo;
  final List<Review> reviews;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        category: json['category'] as String,
        name: json['name'] as String,
        shortDescription: json['shortDescription'] as String,
        longDescription: json['longDescription'] as String,
        price: json['price'] as int,
        offerPrice: json['offerPrice'] as int,
        discountPercentage: json['discountPercentage'] as int,
        images: List<String>.from(json['images'] as List),
        rating: (json['rating'] as num).toDouble(),
        stockCount: json['stockCount'] as int,
        colors: List<String>.from(json['colors'] as List),
        sizes: List<String>.from(json['sizes'] as List),
        deliveryInfo: json['deliveryInfo'] as String,
        reviews: (json['reviews'] as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'name': name,
        'shortDescription': shortDescription,
        'longDescription': longDescription,
        'price': price,
        'offerPrice': offerPrice,
        'discountPercentage': discountPercentage,
        'images': images,
        'rating': rating,
        'stockCount': stockCount,
        'colors': colors,
        'sizes': sizes,
        'deliveryInfo': deliveryInfo,
        'reviews': reviews.map((e) => e.toJson()).toList(),
      };
}
