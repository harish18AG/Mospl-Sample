export function recommendProducts(products, { viewedIds = [], wishlistIds = [], previousOrders = [], categoryPreference, minPrice = 0, maxPrice = Number.MAX_SAFE_INTEGER } = {}) {
  const orderedIds = previousOrders.flatMap((order) => (order.products || []).map((item) => item.productId || item.id));
  const preferredCategories = new Set([categoryPreference].filter(Boolean));
  for (const item of previousOrders.flatMap((order) => order.products || [])) {
    if (item.categoryName || item.category) preferredCategories.add(item.categoryName || item.category);
  }
  return products
    .filter((p) => Number(p.offerPrice || p.price) >= minPrice && Number(p.offerPrice || p.price) <= maxPrice)
    .map((p) => ({
      ...p,
      aiScore:
        (viewedIds.includes(p.productId || p.id) ? 18 : 0) +
        (wishlistIds.includes(p.productId || p.id) ? 24 : 0) +
        (orderedIds.includes(p.productId || p.id) ? 12 : 0) +
        (preferredCategories.has(p.categoryName || p.category) ? 20 : 0) +
        Number(p.rating || 0) * 4 +
        Number(p.discountPercentage || 0) +
        (p.isFeatured ? 8 : 0) +
        (p.isBestSeller ? 10 : 0),
    }))
    .sort((a, b) => b.aiScore - a.aiScore)
    .slice(0, 20);
}

export function chatbotReply(message = '', context = {}) {
  const text = message.toLowerCase();
  if (text.includes('order') || text.includes('track')) return `Your MOSPL order ${context.orderId || ''} can be tracked from Orders > Live Tracking. Confirmed orders move through packed, shipped, out for delivery, and delivered stages.`;
  if (text.includes('return')) return 'MOSPL supports eligible returns within 7 days when products are unused, tags are intact, and original packaging is available.';
  if (text.includes('refund')) return 'Refunds are initiated after return quality check and usually reflect in the original payment method within 5-7 bank working days.';
  if (text.includes('delivery')) return 'Premium insured delivery usually takes 3-6 business days across India. Orders above ₹1,999 qualify for free delivery.';
  if (text.includes('size')) return 'For jackets and shoes, compare your body measurements with the size guide. Choose one size up if you prefer a relaxed leather fit.';
  if (text.includes('care') || text.includes('leather')) return 'Keep leather away from water, use a soft dry cloth, condition every 3-4 months, and store in a breathable dust bag.';
  if (text.includes('wallet')) return 'For wallets, compact full-grain leather options between ₹999 and ₹1,999 are popular gifting choices.';
  return 'I can help with product search, order status, returns, refunds, delivery, size guidance, and leather care.';
}

export function adminInsights({ dashboard }) {
  const bestCategory = [...(dashboard.categorySales || [])].sort((a, b) => b.units - a.units)[0]?.category || 'Premium Collections';
  const revenuePrediction = Math.round((dashboard.totalRevenue || 0) * 1.18);
  return {
    bestSellingCategory: bestCategory,
    lowStockPrediction: (dashboard.lowStockProducts || []).length > 10 ? 'High replenishment risk in the next 14 days.' : 'Inventory risk is controlled.',
    revenuePrediction,
    customerBehaviorSummary: 'Customers respond best to wallets, belts, premium bags, and bundled gifting campaigns during high-intent sessions.',
    recommendedActions: ['Restock best sellers', 'Promote premium collections', 'Bundle wallets with belts', 'Send wishlist price-drop notifications'],
  };
}
