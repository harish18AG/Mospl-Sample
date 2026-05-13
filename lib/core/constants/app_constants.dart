// lib/core/constants/app_constants.dart

class AppConstants {
  // App Info
  static const String appName = 'MOSPL';
  static const String companyName = 'onlinemadras.com';
  static const String appTagline = 'Premium Leather Collection';
  static const String appVersion = '1.0.0';

  // API Base URL - Change to your Node.js backend URL
  static const String baseUrl = 'https://api.mospl.onlinemadras.com/api/v1';
  static const String devBaseUrl = 'http://10.0.2.2:3000/api/v1';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String ordersCollection = 'orders';
  static const String cartCollection = 'cart';
  static const String wishlistCollection = 'wishlist';
  static const String reviewsCollection = 'reviews';
  static const String notificationsCollection = 'notifications';
  static const String couponsCollection = 'coupons';
  static const String bannersCollection = 'banners';
  static const String supportCollection = 'support';
  static const String analyticsCollection = 'analytics';
  static const String activityLogsCollection = 'activity_logs';
  static const String trackingCollection = 'tracking';
  static const String settingsCollection = 'settings';

  // Shared Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyUserToken = 'user_token';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyLanguage = 'language';
  static const String keySearchHistory = 'search_history';
  static const String keyRecentlyViewed = 'recently_viewed';
  static const String keyPushNotifications = 'push_notifications';
  static const String keyAiRecommendations = 'ai_recommendations';

  // Pagination
  static const int pageSize = 20;
  static const int adminPageSize = 50;

  // Image Sizes
  static const double thumbnailSize = 150;
  static const double productImageSize = 400;
  static const double bannerHeight = 200;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 300);

  // Cart
  static const int maxCartItems = 10;
  static const double freeShippingThreshold = 999;
  static const double standardShipping = 99;
  static const double expressShipping = 199;

  // Orders
  static const int maxReturnDays = 7;
  static const int maxExchangeDays = 15;

  // Rewards
  static const double rewardPointsPerRupee = 0.1;
  static const double rewardPointValue = 0.5; // 1 point = ₹0.50

  // Razorpay
  static const String razorpayKeyId = 'rzp_test_YOUR_KEY_HERE';

  // Google Sign In
  static const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID';

  // AI Model Settings
  static const String aiModel = 'gpt-3.5-turbo';
  static const int aiMaxTokens = 500;
  static const double aiTemperature = 0.7;

  // Delivery Days
  static const int standardDeliveryDays = 5;
  static const int expressDeliveryDays = 2;
  static const int premiumDeliveryDays = 1;
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String biometricSetup = '/biometric-setup';
  static const String home = '/home';
  static const String productListing = '/products';
  static const String productDetail = '/product/:id';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String checkout = '/checkout';
  static const String addressSelection = '/address-selection';
  static const String addAddress = '/add-address';
  static const String paymentMethod = '/payment-method';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderDetail = '/order/:id';
  static const String orderTracking = '/order-tracking/:id';
  static const String orderHistory = '/order-history';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String reviews = '/reviews/:productId';
  static const String writeReview = '/write-review/:productId';
  static const String support = '/support';
  static const String chat = '/chat';
  static const String aiChat = '/ai-chat';
  static const String coupons = '/coupons';
  static const String rewardPoints = '/reward-points';
  static const String recentlyViewed = '/recently-viewed';
  static const String returnRequest = '/return-request/:orderId';
  static const String invoice = '/invoice/:orderId';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String faq = '/faq';

  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminProducts = '/admin/products';
  static const String adminAddProduct = '/admin/products/add';
  static const String adminEditProduct = '/admin/products/:id/edit';
  static const String adminOrders = '/admin/orders';
  static const String adminOrderDetail = '/admin/orders/:id';
  static const String adminUsers = '/admin/users';
  static const String adminCategories = '/admin/categories';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminInventory = '/admin/inventory';
  static const String adminBanners = '/admin/banners';
  static const String adminCoupons = '/admin/coupons';
  static const String adminNotifications = '/admin/notifications';
  static const String adminReviews = '/admin/reviews';
  static const String adminDelivery = '/admin/delivery';
  static const String adminRevenue = '/admin/revenue';
  static const String adminAiInsights = '/admin/ai-insights';
}

class AppStrings {
  // Auth
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to your MOSPL account';
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle = 'Join MOSPL Premium Leather';
  static const String forgotPasswordTitle = 'Forgot Password?';
  static const String forgotPasswordSubtitle = 'Enter your email to reset your password';
  static const String otpTitle = 'Verify OTP';
  static const String otpSubtitle = 'Enter the 6-digit code sent to your number';

  // Home
  static const String homeGreetingMorning = 'Good Morning';
  static const String homeGreetingAfternoon = 'Good Afternoon';
  static const String homeGreetingEvening = 'Good Evening';
  static const String shopNow = 'Shop Now';
  static const String seeAll = 'See All';
  static const String featuredCollection = 'Featured Collection';
  static const String newArrivals = 'New Arrivals';
  static const String trendingNow = 'Trending Now';
  static const String bestSellers = 'Best Sellers';
  static const String exclusiveDeals = 'Exclusive Deals';

  // Product
  static const String addToCart = 'Add to Cart';
  static const String buyNow = 'Buy Now';
  static const String addToWishlist = 'Add to Wishlist';
  static const String outOfStock = 'Out of Stock';
  static const String inStock = 'In Stock';
  static const String freeDelivery = 'Free Delivery';
  static const String standardDelivery = 'Standard Delivery';
  static const String deliveryIn = 'Delivery in';
  static const String days = 'days';

  // Cart
  static const String cartTitle = 'My Cart';
  static const String cartEmpty = 'Your cart is empty';
  static const String cartEmptySubtitle = 'Add items to get started';
  static const String proceedToCheckout = 'Proceed to Checkout';

  // Order Status
  static const String orderPlaced = 'Order Placed';
  static const String orderConfirmed = 'Order Confirmed';
  static const String orderProcessing = 'Processing';
  static const String orderShipped = 'Shipped';
  static const String orderOutForDelivery = 'Out for Delivery';
  static const String orderDelivered = 'Delivered';
  static const String orderCancelled = 'Cancelled';
  static const String orderReturned = 'Returned';

  // Messages
  static const String addedToCart = 'Added to cart successfully!';
  static const String addedToWishlist = 'Added to wishlist!';
  static const String removedFromWishlist = 'Removed from wishlist';
  static const String orderSuccess = 'Order placed successfully!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String reviewSubmitted = 'Review submitted successfully!';
  static const String copiedToClipboard = 'Copied to clipboard!';
}