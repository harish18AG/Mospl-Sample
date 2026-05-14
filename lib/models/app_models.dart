class AppUser {
  AppUser({required this.id, required this.name, required this.email, this.role = 'customer'});
  final String id;
  final String name;
  final String email;
  final String role;
}

class CartLine {
  CartLine({required this.productId, required this.quantity});
  final String productId;
  int quantity;
}

class OrderModel {
  OrderModel({required this.id, required this.total, required this.status, required this.createdAt});
  final String id;
  final int total;
  final String status;
  final DateTime createdAt;
}

class SettingItem {
  const SettingItem(this.title, this.subtitle, this.iconName);
  final String title;
  final String subtitle;
  final String iconName;
}
