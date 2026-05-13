// firebase/seed_data.js
// Run: node firebase/seed_data.js
// Seeds Firestore with all dummy product, category, coupon, and banner data

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // Download from Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// ==================== CATEGORIES ====================
const categories = [
  { id: 'cat_jackets', name: 'Leather Jackets', description: 'Premium genuine leather jackets for men and women', imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400', icon: '🧥', productCount: 12, sortOrder: 1, isActive: true, slug: 'leather-jackets' },
  { id: 'cat_bags', name: 'Leather Bags', description: 'Handcrafted leather bags for every occasion', imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400', icon: '👜', productCount: 15, sortOrder: 2, isActive: true, slug: 'leather-bags' },
  { id: 'cat_wallets', name: 'Wallets', description: 'Slim and classic leather wallets', imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400', icon: '👛', productCount: 14, sortOrder: 3, isActive: true, slug: 'wallets' },
  { id: 'cat_belts', name: 'Belts', description: 'Genuine leather belts with premium buckles', imageUrl: 'https://images.unsplash.com/photo-1624222247344-550fb60583dc?w=400', icon: '🪢', productCount: 12, sortOrder: 4, isActive: true, slug: 'belts' },
  { id: 'cat_shoes', name: 'Shoes', description: 'Handcrafted leather shoes and boots', imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', icon: '👞', productCount: 13, sortOrder: 5, isActive: true, slug: 'shoes' },
  { id: 'cat_watches', name: 'Watches', description: 'Premium watches with genuine leather straps', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', icon: '⌚', productCount: 10, sortOrder: 6, isActive: true, slug: 'watches' },
  { id: 'cat_travel_bags', name: 'Travel Bags', description: 'Durable leather travel bags and duffels', imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400', icon: '🧳', productCount: 10, sortOrder: 7, isActive: true, slug: 'travel-bags' },
  { id: 'cat_office_bags', name: 'Office Bags', description: 'Professional leather laptop bags and briefcases', imageUrl: 'https://images.unsplash.com/photo-1547949003-9792a18a2601?w=400', icon: '💼', productCount: 11, sortOrder: 8, isActive: true, slug: 'office-bags' },
  { id: 'cat_accessories', name: 'Accessories', description: 'Leather keychains, cardholders and more', imageUrl: 'https://images.unsplash.com/photo-1582561424760-0321d75e81fa?w=400', icon: '🔑', productCount: 12, sortOrder: 9, isActive: true, slug: 'accessories' },
  { id: 'cat_premium', name: 'Premium Collections', description: 'Exclusive limited edition leather masterpieces', imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=400', icon: '👑', productCount: 8, sortOrder: 10, isActive: true, slug: 'premium-collections' },
];

// ==================== EXTENDED PRODUCTS (all 10 categories, 10+ each) ====================
const products = [
  // JACKETS (12 products)
  { name: 'Classic Biker Leather Jacket', shortDescription: 'Rugged full-grain leather biker jacket', longDescription: 'Crafted from premium full-grain cowhide leather, this biker jacket exudes timeless masculinity. Features asymmetric front zipper and quilted shoulder panels.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 8999, offerPrice: 6999, discountPercentage: 22, images: ['https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600', 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600'], rating: 4.6, reviewCount: 234, stockCount: 45, availableColors: ['Black', 'Dark Brown', 'Cognac'], availableSizes: ['XS','S','M','L','XL','XXL'], brand: 'MOSPL', sku: 'MSP-JKT-001', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['biker','jacket','men','premium'], isFeatured: true, isNewArrival: false, isBestSeller: true, isTrending: true, specifications: { Material: 'Full-Grain Cowhide', Lining: 'Satin', Closure: 'YKK Zipper', Weight: '1.8 kg' } },
  { name: 'Slim Fit Café Racer Jacket', shortDescription: 'Sleek café racer in premium napa leather', longDescription: 'The epitome of understated cool, tailored from buttery-soft napa leather with band collar and front zip for a clean silhouette.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 7499, offerPrice: 5999, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1520975954732-35dd22299614?w=600'], rating: 4.4, reviewCount: 187, stockCount: 32, availableColors: ['Black','Navy','Burgundy'], availableSizes: ['S','M','L','XL','XXL'], brand: 'MOSPL', sku: 'MSP-JKT-002', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['cafe racer','slim','men'], isFeatured: false, isNewArrival: true, isBestSeller: false, isTrending: true, specifications: { Material: 'Napa Leather', Collar: 'Band Collar', Weight: '1.5 kg' } },
  { name: 'Women\'s Belted Leather Trench', shortDescription: 'Elegant belted leather trench coat in cognac', longDescription: 'A sophisticated fusion of classic trench silhouette and premium leather craftsmanship with double-breasted front and waist-defining belt.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 12999, offerPrice: 9999, discountPercentage: 23, images: ['https://images.unsplash.com/photo-1594938298603-a8ffa3e82fc1?w=600'], rating: 4.8, reviewCount: 95, stockCount: 18, availableColors: ['Cognac','Black','Camel'], availableSizes: ['XS','S','M','L','XL'], brand: 'MOSPL', sku: 'MSP-JKT-003', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['women','trench','elegant'], isFeatured: true, isNewArrival: true, isBestSeller: false, isTrending: false, specifications: { Material: 'Top-Grain Leather', Style: 'Belted Trench', Weight: '2.1 kg' } },
  { name: 'Bomber Leather Flight Jacket', shortDescription: 'Classic bomber with ribbed cuffs in genuine leather', longDescription: 'Inspired by WWII flight jackets, crafted from genuine cowhide with ribbed wool cuffs and vintage map-print satin interior.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 9499, offerPrice: 7499, discountPercentage: 21, images: ['https://images.unsplash.com/photo-1510945509543-8c2bfc0c5f4b?w=600'], rating: 4.5, reviewCount: 156, stockCount: 28, availableColors: ['Tan','Black','Dark Green'], availableSizes: ['S','M','L','XL','XXL','3XL'], brand: 'MOSPL', sku: 'MSP-JKT-004', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['bomber','flight','vintage'], isFeatured: false, isNewArrival: false, isBestSeller: true, isTrending: false, specifications: { Material: 'Genuine Cowhide', Cuffs: 'Ribbed Knit', Weight: '1.7 kg' } },
  { name: 'Suede Western Fringe Jacket', shortDescription: 'Authentic western suede jacket with fringe', longDescription: 'Channel your inner cowboy with this authentic suede western jacket featuring intricate fringe detailing along the chest and sleeves.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 6999, offerPrice: 5499, discountPercentage: 21, images: ['https://images.unsplash.com/photo-1594938298603-a8ffa3e82fc1?w=600'], rating: 4.2, reviewCount: 67, stockCount: 15, availableColors: ['Sand','Chestnut','Grey'], availableSizes: ['S','M','L','XL'], brand: 'MOSPL', sku: 'MSP-JKT-005', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['suede','western','fringe'], isFeatured: false, isNewArrival: true, isBestSeller: false, isTrending: false, specifications: { Material: 'Genuine Suede', Style: 'Western', Weight: '1.4 kg' } },
  { name: 'Moto Perforated Jacket', shortDescription: 'Ventilated moto jacket with perforated panels', longDescription: 'Perfect for warm weather riding, this moto jacket features strategically placed perforated panels for maximum airflow without compromising style.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 7999, offerPrice: 6499, discountPercentage: 19, images: ['https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600'], rating: 4.3, reviewCount: 88, stockCount: 22, availableColors: ['Black','Brown'], availableSizes: ['S','M','L','XL','XXL'], brand: 'MOSPL', sku: 'MSP-JKT-006', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['moto','perforated','summer'], isFeatured: false, isNewArrival: false, isBestSeller: false, isTrending: true, specifications: { Material: 'Perforated Leather', Style: 'Moto', Weight: '1.6 kg' } },
  { name: 'Double Breasted Officer Jacket', shortDescription: 'Military-inspired double breasted leather jacket', longDescription: 'A commanding piece inspired by military officer coats, featuring double-breasted brass buttons, epaulettes, and a structured silhouette.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 10999, offerPrice: 8799, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1520975954732-35dd22299614?w=600'], rating: 4.6, reviewCount: 45, stockCount: 12, availableColors: ['Black','Forest Green','Navy'], availableSizes: ['S','M','L','XL'], brand: 'MOSPL', sku: 'MSP-JKT-007', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['officer','military','premium'], isFeatured: true, isNewArrival: false, isBestSeller: false, isTrending: false, specifications: { Material: 'Top-Grain Leather', Buttons: 'Brass', Weight: '2.0 kg' } },
  { name: 'Vintage Distressed Jacket', shortDescription: 'Hand-distressed vintage leather jacket', longDescription: 'Each jacket is individually hand-distressed by skilled artisans to create a unique worn-in look. No two jackets are exactly alike.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 8499, offerPrice: 6799, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600'], rating: 4.7, reviewCount: 123, stockCount: 30, availableColors: ['Distressed Brown','Vintage Black'], availableSizes: ['S','M','L','XL','XXL'], brand: 'MOSPL', sku: 'MSP-JKT-008', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['vintage','distressed','unique'], isFeatured: false, isNewArrival: false, isBestSeller: true, isTrending: true, specifications: { Material: 'Full-Grain Leather', Finish: 'Hand-Distressed', Weight: '1.9 kg' } },
  { name: 'Minimalist Clean Cut Jacket', shortDescription: 'Sleek minimalist leather jacket with no hardware', longDescription: 'For lovers of clean aesthetics, this jacket strips away excess hardware and detailing to let the quality of the leather speak for itself.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 6499, offerPrice: 5199, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1520975954732-35dd22299614?w=600'], rating: 4.3, reviewCount: 72, stockCount: 40, availableColors: ['Black','Camel','Cream'], availableSizes: ['XS','S','M','L','XL'], brand: 'MOSPL', sku: 'MSP-JKT-009', deliveryInfo: { freeDelivery: true, standardDays: 5, expressDays: 2, expressCharge: 199 }, tags: ['minimalist','clean','unisex'], isFeatured: false, isNewArrival: true, isBestSeller: false, isTrending: false, specifications: { Material: 'Smooth Grain Leather', Style: 'Minimalist', Weight: '1.3 kg' } },
  { name: 'Patchwork Artisan Jacket', shortDescription: 'Handcrafted patchwork leather jacket by artisans', longDescription: 'A wearable work of art, this jacket combines different leather hides in complementary colors, stitched together by skilled Chennai artisans.', categoryId: 'cat_jackets', categoryName: 'Leather Jackets', originalPrice: 11999, offerPrice: 9499, discountPercentage: 21, images: ['https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600'], rating: 4.9, reviewCount: 28, stockCount: 8, availableColors: ['Multi-Tan','Multi-Brown'], availableSizes: ['S','M','L','XL'], brand: 'MOSPL Artisan', sku: 'MSP-JKT-010', deliveryInfo: { freeDelivery: true, standardDays: 7, expressDays: 3, expressCharge: 299 }, tags: ['patchwork','artisan','unique','premium'], isFeatured: true, isNewArrival: true, isBestSeller: false, isTrending: true, specifications: { Material: 'Mixed Leather Hides', Craft: 'Handstitched', Weight: '1.7 kg' } },

  // WALLETS (10 more)
  { name: 'Classic Bifold Slim Wallet', shortDescription: 'Ultra-slim RFID bifold wallet', longDescription: 'Crafted from premium full-grain leather with RFID blocking. 8 card slots, 2 bill compartments, and a clear ID window.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 1499, offerPrice: 1199, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1627123424574-724758594e93?w=600'], rating: 4.6, reviewCount: 456, stockCount: 120, availableColors: ['Black','Dark Brown','Tan','Navy'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-001', deliveryInfo: { freeDelivery: false, standardDays: 4, standardCharge: 49, expressDays: 2, expressCharge: 99 }, tags: ['wallet','slim','RFID','men'], isFeatured: false, isNewArrival: false, isBestSeller: true, isTrending: true, specifications: { Material: 'Full-Grain Leather', RFID: 'Protected', CardSlots: '8', Dimensions: '11x8.5x1cm' } },
  { name: 'Women\'s Long Clutch Wallet', shortDescription: 'Elegant long wallet with multiple slots', longDescription: 'An elegant organizational masterpiece with 12 card slots, 3 bill compartments, zip coin pocket, and checkbook holder.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 1999, offerPrice: 1599, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1615485500704-8e990f9900f7?w=600'], rating: 4.5, reviewCount: 234, stockCount: 85, availableColors: ['Rose Gold','Black','Burgundy','Camel'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-002', deliveryInfo: { freeDelivery: false, standardDays: 4, standardCharge: 49, expressDays: 2, expressCharge: 99 }, tags: ['wallet','women','long','clutch'], isFeatured: false, isNewArrival: true, isBestSeller: false, isTrending: true, specifications: { Material: 'Genuine Leather', CardSlots: '12', CoinPocket: 'Zip', Dimensions: '19x9.5x2cm' } },
  { name: 'Vintage Trifold Wallet', shortDescription: 'Classic trifold in aged vintage leather', longDescription: 'Hand-aged leather wallet with 6 card slots, 2 currency pockets, zipper coin compartment, and 2 ID windows.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 1299, offerPrice: 999, discountPercentage: 23, images: ['https://images.unsplash.com/photo-1627123424574-724758594e93?w=600'], rating: 4.3, reviewCount: 178, stockCount: 95, availableColors: ['Vintage Brown','Dark Tan','Mahogany'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-003', deliveryInfo: { freeDelivery: false, standardDays: 4, standardCharge: 49, expressDays: 2, expressCharge: 99 }, tags: ['wallet','vintage','trifold','men'], isFeatured: false, isNewArrival: false, isBestSeller: false, isTrending: false, specifications: { Material: 'Hand-Aged Leather', CardSlots: '6', IDWindows: '2', Weight: '95g' } },
  { name: 'Card Holder Minimalist', shortDescription: 'Ultra-slim 5mm card holder with RFID blocking', longDescription: 'Just 5mm thick, holds 6 cards with RFID blocking and a quick-access front slot for your most-used card.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 699, offerPrice: 549, discountPercentage: 21, images: ['https://images.unsplash.com/photo-1627123424574-724758594e93?w=600'], rating: 4.6, reviewCount: 312, stockCount: 200, availableColors: ['Black','Brown','Navy','Forest Green','Burgundy','Tan'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-004', deliveryInfo: { freeDelivery: false, standardDays: 3, standardCharge: 49, expressDays: 1, expressCharge: 99 }, tags: ['card holder','minimalist','RFID'], isFeatured: false, isNewArrival: true, isBestSeller: true, isTrending: true, specifications: { Material: 'Top-Grain Leather', Thickness: '5mm', CardCapacity: '6', RFID: 'Blocked' } },
  { name: 'Zip-Around Travel Wallet', shortDescription: 'Large zip-around wallet for travel essentials', longDescription: 'A comprehensive travel companion with passport slot, 12 card slots, document pockets, pen loop, and zipper coin compartment.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 2499, offerPrice: 1999, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1615485500704-8e990f9900f7?w=600'], rating: 4.7, reviewCount: 145, stockCount: 60, availableColors: ['Black','Cognac','Camel'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-005', deliveryInfo: { freeDelivery: false, standardDays: 4, standardCharge: 49, expressDays: 2, expressCharge: 99 }, tags: ['wallet','travel','zip','passport'], isFeatured: false, isNewArrival: false, isBestSeller: false, isTrending: false, specifications: { Material: 'Full-Grain Leather', PassportSlot: 'Yes', CardSlots: '12', Closure: 'YKK Zip' } },
  { name: 'Money Clip Wallet', shortDescription: 'Sleek money clip combo wallet', longDescription: 'The modern alternative to the traditional wallet — a stainless steel money clip backed with premium leather housing 4 card slots.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 999, offerPrice: 799, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1627123424574-724758594e93?w=600'], rating: 4.2, reviewCount: 98, stockCount: 150, availableColors: ['Black/Silver','Brown/Gold','Tan/Gold'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-006', deliveryInfo: { freeDelivery: false, standardDays: 3, standardCharge: 49, expressDays: 1, expressCharge: 99 }, tags: ['wallet','money clip','men','slim'], isFeatured: false, isNewArrival: true, isBestSeller: false, isTrending: false, specifications: { Material: 'Leather + Stainless Steel', Clip: 'Spring Money Clip', CardSlots: '4' } },
  { name: 'Handmade Braided Wallet', shortDescription: 'Uniquely braided leather weave wallet', longDescription: 'A true artisan piece — individual leather strands are hand-woven in a traditional Indian pattern to create this distinctive wallet.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 1599, offerPrice: 1299, discountPercentage: 19, images: ['https://images.unsplash.com/photo-1627123424574-724758594e93?w=600'], rating: 4.4, reviewCount: 67, stockCount: 45, availableColors: ['Tan/Brown','Black/Grey'], availableSizes: ['Standard'], brand: 'MOSPL Artisan', sku: 'MSP-WLT-007', deliveryInfo: { freeDelivery: false, standardDays: 4, standardCharge: 49, expressDays: 2, expressCharge: 99 }, tags: ['braided','artisan','handmade','unique'], isFeatured: false, isNewArrival: true, isBestSeller: false, isTrending: false, specifications: { Material: 'Braided Leather', Craft: 'Handwoven', CardSlots: '4' } },
  { name: 'RFID Blocking Passport Wallet', shortDescription: 'Slim passport and cards wallet with RFID shielding', longDescription: 'Protect your identity while traveling with this slim passport wallet featuring RFID shielding, 6 card slots, and a boarding pass pocket.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 1799, offerPrice: 1399, discountPercentage: 22, images: ['https://images.unsplash.com/photo-1615485500704-8e990f9900f7?w=600'], rating: 4.5, reviewCount: 112, stockCount: 75, availableColors: ['Black','Navy','Brown'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-008', deliveryInfo: { freeDelivery: false, standardDays: 4, standardCharge: 49, expressDays: 2, expressCharge: 99 }, tags: ['passport','RFID','travel','security'], isFeatured: false, isNewArrival: false, isBestSeller: false, isTrending: false, specifications: { Material: 'Top-Grain Leather', RFID: 'Full Shielding', PassportFit: 'Yes', CardSlots: '6' } },
  { name: 'Coin Purse with Zip', shortDescription: 'Compact leather coin purse with zip closure', longDescription: 'Small but perfectly formed, this leather coin purse holds coins, keys, and small essentials with a smooth YKK zipper closure.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 499, offerPrice: 399, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1627123424574-724758594e93?w=600'], rating: 4.1, reviewCount: 89, stockCount: 200, availableColors: ['Black','Brown','Tan','Red','Navy'], availableSizes: ['Standard'], brand: 'MOSPL', sku: 'MSP-WLT-009', deliveryInfo: { freeDelivery: false, standardDays: 3, standardCharge: 49, expressDays: 1, expressCharge: 99 }, tags: ['coin purse','compact','women'], isFeatured: false, isNewArrival: false, isBestSeller: false, isTrending: false, specifications: { Material: 'Genuine Leather', Closure: 'YKK Zip', Dimensions: '12x9cm' } },
  { name: 'Luxury Crocodile-Embossed Wallet', shortDescription: 'Premium crocodile-embossed leather bifold', longDescription: 'Make a statement with this luxury crocodile-embossed leather bifold. The exotic texture is achieved without harming animals, using high-definition embossing.', categoryId: 'cat_wallets', categoryName: 'Wallets', originalPrice: 2999, offerPrice: 2399, discountPercentage: 20, images: ['https://images.unsplash.com/photo-1627123424574-724758594e93?w=600'], rating: 4.7, reviewCount: 78, stockCount: 35, availableColors: ['Black','Dark Brown','Burgundy'], availableSizes: ['Standard'], brand: 'MOSPL Premium', sku: 'MSP-WLT-010', deliveryInfo: { freeDelivery: true, standardDays: 4, expressDays: 2, expressCharge: 149 }, tags: ['luxury','crocodile','embossed','premium'], isFeatured: true, isNewArrival: false, isBestSeller: false, isTrending: false, specifications: { Material: 'Croc-Embossed Leather', CardSlots: '8', Lining: 'Suede', Weight: '110g' } },
];

// ==================== COUPONS ====================
const coupons = [
  { code: 'MOSPL10', title: '10% Off Your Order', description: 'Get 10% off on any order. Valid for all products.', discountType: 'percentage', discountValue: 10, minOrderValue: 999, maxDiscount: 500, usageLimit: 1000, usedCount: 234, expiryDate: new Date('2024-12-31'), isActive: true, applicableCategories: [] },
  { code: 'LEATHER500', title: '₹500 Off on Orders Above ₹3999', description: 'Flat ₹500 discount on orders worth ₹3999 or more.', discountType: 'flat', discountValue: 500, minOrderValue: 3999, maxDiscount: 500, usageLimit: 500, usedCount: 89, expiryDate: new Date('2024-12-31'), isActive: true, applicableCategories: [] },
  { code: 'NEWUSER', title: '15% Off for New Users', description: 'First order exclusive — 15% off up to ₹750.', discountType: 'percentage', discountValue: 15, minOrderValue: 1499, maxDiscount: 750, usageLimit: 1, usedCount: 0, expiryDate: new Date('2024-12-31'), isActive: true, applicableCategories: [] },
  { code: 'PREMIUM20', title: '20% Off Premium Collection', description: '20% off on all Premium Collection items.', discountType: 'percentage', discountValue: 20, minOrderValue: 5000, maxDiscount: 2000, usageLimit: 200, usedCount: 45, expiryDate: new Date('2024-12-31'), isActive: true, applicableCategories: ['cat_premium'] },
  { code: 'FREESHIP', title: 'Free Shipping on Any Order', description: 'Get free shipping on any order regardless of amount.', discountType: 'flat', discountValue: 99, minOrderValue: 0, maxDiscount: 99, usageLimit: 300, usedCount: 156, expiryDate: new Date('2024-12-31'), isActive: true, applicableCategories: [] },
];

// ==================== BANNERS ====================
const banners = [
  { title: 'New Arrivals 2024', subtitle: 'Discover Premium Leather Collections', imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800', actionUrl: '/products?filter=new_arrival', buttonText: 'Shop Now', isActive: true, sortOrder: 1 },
  { title: 'Up to 25% Off', subtitle: 'On Premium Leather Bags & Wallets', imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', actionUrl: '/products?filter=on_sale', buttonText: 'Grab Deal', isActive: true, sortOrder: 2 },
  { title: 'Artisan Collection', subtitle: 'Handcrafted by Chennai\'s Master Craftsmen', imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800', actionUrl: '/products?category=cat_premium', buttonText: 'Explore', isActive: true, sortOrder: 3 },
  { title: 'Free Shipping', subtitle: 'On All Orders Above ₹999', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800', actionUrl: '/products', buttonText: 'Shop Now', isActive: true, sortOrder: 4 },
];

// ==================== SEED FUNCTION ====================
async function seedDatabase() {
  console.log('🌱 Starting MOSPL database seeding...\n');

  try {
    // Seed categories
    console.log('📂 Seeding categories...');
    const catBatch = db.batch();
    for (const cat of categories) {
      const { id, ...data } = cat;
      catBatch.set(db.collection('categories').doc(id), { ...data, createdAt: admin.firestore.FieldValue.serverTimestamp() });
    }
    await catBatch.commit();
    console.log(`   ✅ ${categories.length} categories seeded`);

    // Seed products in batches of 500
    console.log('📦 Seeding products...');
    const prodBatches = [];
    for (let i = 0; i < products.length; i += 499) {
      prodBatches.push(products.slice(i, i + 499));
    }
    let totalProds = 0;
    for (const batch of prodBatches) {
      const batchWrite = db.batch();
      for (const product of batch) {
        const ref = db.collection('products').doc();
        batchWrite.set(ref, { ...product, createdAt: admin.firestore.FieldValue.serverTimestamp(), updatedAt: admin.firestore.FieldValue.serverTimestamp() });
        totalProds++;
      }
      await batchWrite.commit();
    }
    console.log(`   ✅ ${totalProds} products seeded`);

    // Seed coupons
    console.log('🎟️  Seeding coupons...');
    const couponBatch = db.batch();
    for (const coupon of coupons) {
      couponBatch.set(db.collection('coupons').doc(), { ...coupon, createdAt: admin.firestore.FieldValue.serverTimestamp() });
    }
    await couponBatch.commit();
    console.log(`   ✅ ${coupons.length} coupons seeded`);

    // Seed banners
    console.log('🖼️  Seeding banners...');
    const bannerBatch = db.batch();
    for (const banner of banners) {
      bannerBatch.set(db.collection('banners').doc(), { ...banner, createdAt: admin.firestore.FieldValue.serverTimestamp() });
    }
    await bannerBatch.commit();
    console.log(`   ✅ ${banners.length} banners seeded`);

    // Create demo admin user doc (Firebase Auth must be created separately)
    console.log('👤 Creating demo admin placeholder...');
    await db.collection('users').doc('ADMIN_UID_REPLACE_ME').set({
      name: 'MOSPL Admin',
      email: 'admin@mospl.com',
      phone: '9876543210',
      role: 'admin',
      addresses: [],
      rewardPoints: 0,
      preferences: { notifications: true, aiRecommendations: true },
      isActive: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log('   ✅ Admin user placeholder created (update UID after Firebase Auth creation)');

    console.log('\n✨ MOSPL database seeded successfully!');
    console.log(`   Categories: ${categories.length}`);
    console.log(`   Products: ${totalProds}`);
    console.log(`   Coupons: ${coupons.length}`);
    console.log(`   Banners: ${banners.length}`);

  } catch (error) {
    console.error('❌ Seeding error:', error);
  } finally {
    process.exit(0);
  }
}

seedDatabase();