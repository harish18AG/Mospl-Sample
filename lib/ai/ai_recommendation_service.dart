import '../models/product.dart';

class AiRecommendationService {
  List<Product> recommend({required List<Product> catalog, required List<String> viewedIds, required Set<String> wishlistIds}) {
    final affinity = <String, int>{};
    for (final p in catalog.where((p) => viewedIds.contains(p.id) || wishlistIds.contains(p.id))) {
      affinity[p.category] = (affinity[p.category] ?? 0) + 1;
    }
    final scored = [...catalog]..sort((a, b) {
      final as = (affinity[a.category] ?? 0) * 10 + (a.rating * 2).round() + a.discountPercentage;
      final bs = (affinity[b.category] ?? 0) * 10 + (b.rating * 2).round() + b.discountPercentage;
      return bs.compareTo(as);
    });
    return scored.take(12).toList();
  }

  String chatbotReply(String message) {
    final text = message.toLowerCase();
    if (text.contains('return')) return 'MOSPL offers easy 7-day returns on eligible premium leather products.';
    if (text.contains('wallet')) return 'For wallets, I recommend compact full-grain models between ₹999 and ₹1,999.';
    if (text.contains('gift')) return 'A wallet, belt, or premium accessory set makes an elegant leather gift.';
    return 'I can help with product discovery, sizing, offers, order tracking, returns, and leather care.';
  }
}
