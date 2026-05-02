import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/add_product_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_orders_screen.dart';
import '../../features/admin/presentation/screens/admin_products_screen.dart';
import '../../features/admin/presentation/screens/admin_users_screen.dart';
import '../../features/admin/presentation/screens/edit_product_screen.dart';
import '../../features/admin/presentation/screens/order_management_screen.dart';
import '../../features/admin/presentation/screens/sales_analytics_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_one_screen.dart';
import '../../features/auth/presentation/screens/onboarding_three_screen.dart';
import '../../features/auth/presentation/screens/onboarding_two_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/cart/presentation/screens/order_success_screen.dart';
import '../../features/cart/presentation/screens/payment_screen.dart';
import '../../features/cart/presentation/screens/shipping_address_screen.dart';
import '../../features/categories/presentation/screens/accessories_screen.dart';
import '../../features/categories/presentation/screens/bags_screen.dart';
import '../../features/categories/presentation/screens/belts_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/categories/presentation/screens/jackets_screen.dart';
import '../../features/categories/presentation/screens/wallets_screen.dart';
import '../../features/chatbot/presentation/screens/chat_history_screen.dart';
import '../../features/chatbot/presentation/screens/chat_ui_screen.dart';
import '../../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../../features/home/presentation/screens/accessories_screen.dart';
import '../../features/home/presentation/screens/bags_screen.dart';
import '../../features/home/presentation/screens/belts_screen.dart';
import '../../features/home/presentation/screens/category_listing_screen.dart';
import '../../features/home/presentation/screens/home_dashboard_screen.dart';
import '../../features/home/presentation/screens/jackets_screen.dart';
import '../../features/home/presentation/screens/notifications_screen.dart';
import '../../features/home/presentation/screens/offers_screen.dart';
import '../../features/home/presentation/screens/product_detail_screen.dart';
import '../../features/home/presentation/screens/product_grid_screen.dart';
import '../../features/home/presentation/screens/search_filter_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';
import '../../features/home/presentation/screens/wallets_screen.dart';
import '../../features/orders/presentation/screens/order_history_screen.dart';
import '../../features/orders/presentation/screens/order_tracking_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/return_request_screen.dart';
import '../../features/product/presentation/screens/product_details_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';
import '../../features/product/presentation/screens/reviews_screen.dart';
import '../../features/product/presentation/screens/similar_products_screen.dart';
import '../../features/product/presentation/screens/size_guide_screen.dart';
import '../../features/profile/presentation/screens/address_book_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/payment_methods_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/shopping/presentation/screens/address_management_screen.dart';
import '../../features/shopping/presentation/screens/cart_screen.dart';
import '../../features/shopping/presentation/screens/checkout_screen.dart';
import '../../features/shopping/presentation/screens/coupon_screen.dart';
import '../../features/shopping/presentation/screens/invoice_screen.dart';
import '../../features/shopping/presentation/screens/order_confirmation_screen.dart';
import '../../features/shopping/presentation/screens/order_tracking_screen.dart';
import '../../features/shopping/presentation/screens/payment_screen.dart';
import '../../features/shopping/presentation/screens/returns_screen.dart';
import '../../features/shopping/presentation/screens/shipping_method_screen.dart';
import '../../features/user/presentation/screens/about_screen.dart';
import '../../features/user/presentation/screens/edit_profile_screen.dart';
import '../../features/user/presentation/screens/help_support_screen.dart';
import '../../features/user/presentation/screens/notifications_screen.dart';
import '../../features/user/presentation/screens/privacy_screen.dart';
import '../../features/user/presentation/screens/profile_screen.dart';
import '../../features/user/presentation/screens/settings_screen.dart';
import '../../features/user/presentation/screens/wishlist_screen.dart';
import '../../features/wishlist/presentation/screens/saved_for_later_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) => GoRouter(initialLocation: '/', routes: [
      GoRoute(path: '/add-product', pageBuilder: (c,s)=>_page(const AddProductScreen())),
      GoRoute(path: '/admin-dashboard', pageBuilder: (c,s)=>_page(const AdminDashboardScreen())),
      GoRoute(path: '/admin-orders', pageBuilder: (c,s)=>_page(const AdminOrdersScreen())),
      GoRoute(path: '/admin-products', pageBuilder: (c,s)=>_page(const AdminProductsScreen())),
      GoRoute(path: '/admin-users', pageBuilder: (c,s)=>_page(const AdminUsersScreen())),
      GoRoute(path: '/edit-product', pageBuilder: (c,s)=>_page(const EditProductScreen())),
      GoRoute(path: '/order-management', pageBuilder: (c,s)=>_page(const OrderManagementScreen())),
      GoRoute(path: '/sales-analytics', pageBuilder: (c,s)=>_page(const SalesAnalyticsScreen())),
      GoRoute(path: '/forgot-password', pageBuilder: (c,s)=>_page(const ForgotPasswordScreen())),
      GoRoute(path: '/login', pageBuilder: (c,s)=>_page(const LoginScreen())),
      GoRoute(path: '/onboarding-one', pageBuilder: (c,s)=>_page(const OnboardingOneScreen())),
      GoRoute(path: '/onboarding-three', pageBuilder: (c,s)=>_page(const OnboardingThreeScreen())),
      GoRoute(path: '/onboarding-two', pageBuilder: (c,s)=>_page(const OnboardingTwoScreen())),
      GoRoute(path: '/otp', pageBuilder: (c,s)=>_page(const OtpScreen())),
      GoRoute(path: '/register', pageBuilder: (c,s)=>_page(const RegisterScreen())),
      GoRoute(path: '/signup', pageBuilder: (c,s)=>_page(const SignupScreen())),
      GoRoute(path: '/', pageBuilder: (c,s)=>_page(const SplashScreen())),
      GoRoute(path: '/cart', pageBuilder: (c,s)=>_page(const CartScreen())),
      GoRoute(path: '/checkout', pageBuilder: (c,s)=>_page(const CheckoutScreen())),
      GoRoute(path: '/order-success', pageBuilder: (c,s)=>_page(const OrderSuccessScreen())),
      GoRoute(path: '/payment', pageBuilder: (c,s)=>_page(const PaymentScreen())),
      GoRoute(path: '/shipping-address', pageBuilder: (c,s)=>_page(const ShippingAddressScreen())),
      GoRoute(path: '/accessories', pageBuilder: (c,s)=>_page(const AccessoriesScreen())),
      GoRoute(path: '/bags', pageBuilder: (c,s)=>_page(const BagsScreen())),
      GoRoute(path: '/belts', pageBuilder: (c,s)=>_page(const BeltsScreen())),
      GoRoute(path: '/categories', pageBuilder: (c,s)=>_page(const CategoriesScreen())),
      GoRoute(path: '/jackets', pageBuilder: (c,s)=>_page(const JacketsScreen())),
      GoRoute(path: '/wallets', pageBuilder: (c,s)=>_page(const WalletsScreen())),
      GoRoute(path: '/chat-history', pageBuilder: (c,s)=>_page(const ChatHistoryScreen())),
      GoRoute(path: '/chat-ui', pageBuilder: (c,s)=>_page(const ChatUiScreen())),
      GoRoute(path: '/chatbot', pageBuilder: (c,s)=>_page(const ChatbotScreen())),
      GoRoute(path: '/accessories', pageBuilder: (c,s)=>_page(const AccessoriesScreen())),
      GoRoute(path: '/bags', pageBuilder: (c,s)=>_page(const BagsScreen())),
      GoRoute(path: '/belts', pageBuilder: (c,s)=>_page(const BeltsScreen())),
      GoRoute(path: '/category-listing', pageBuilder: (c,s)=>_page(const CategoryListingScreen())),
      GoRoute(path: '/home-dashboard', pageBuilder: (c,s)=>_page(const HomeDashboardScreen())),
      GoRoute(path: '/jackets', pageBuilder: (c,s)=>_page(const JacketsScreen())),
      GoRoute(path: '/notifications', pageBuilder: (c,s)=>_page(const NotificationsScreen())),
      GoRoute(path: '/offers', pageBuilder: (c,s)=>_page(const OffersScreen())),
      GoRoute(path: '/product-detail', pageBuilder: (c,s)=>_page(const ProductDetailScreen())),
      GoRoute(path: '/product-grid', pageBuilder: (c,s)=>_page(const ProductGridScreen())),
      GoRoute(path: '/search-filter', pageBuilder: (c,s)=>_page(const SearchFilterScreen())),
      GoRoute(path: '/search', pageBuilder: (c,s)=>_page(const SearchScreen())),
      GoRoute(path: '/wallets', pageBuilder: (c,s)=>_page(const WalletsScreen())),
      GoRoute(path: '/order-history', pageBuilder: (c,s)=>_page(const OrderHistoryScreen())),
      GoRoute(path: '/order-tracking', pageBuilder: (c,s)=>_page(const OrderTrackingScreen())),
      GoRoute(path: '/orders', pageBuilder: (c,s)=>_page(const OrdersScreen())),
      GoRoute(path: '/return-request', pageBuilder: (c,s)=>_page(const ReturnRequestScreen())),
      GoRoute(path: '/product-details', pageBuilder: (c,s)=>_page(const ProductDetailsScreen())),
      GoRoute(path: '/product-list', pageBuilder: (c,s)=>_page(const ProductListScreen())),
      GoRoute(path: '/reviews', pageBuilder: (c,s)=>_page(const ReviewsScreen())),
      GoRoute(path: '/similar-products', pageBuilder: (c,s)=>_page(const SimilarProductsScreen())),
      GoRoute(path: '/size-guide', pageBuilder: (c,s)=>_page(const SizeGuideScreen())),
      GoRoute(path: '/address-book', pageBuilder: (c,s)=>_page(const AddressBookScreen())),
      GoRoute(path: '/edit-profile', pageBuilder: (c,s)=>_page(const EditProfileScreen())),
      GoRoute(path: '/payment-methods', pageBuilder: (c,s)=>_page(const PaymentMethodsScreen())),
      GoRoute(path: '/profile', pageBuilder: (c,s)=>_page(const ProfileScreen())),
      GoRoute(path: '/settings', pageBuilder: (c,s)=>_page(const SettingsScreen())),
      GoRoute(path: '/address-management', pageBuilder: (c,s)=>_page(const AddressManagementScreen())),
      GoRoute(path: '/cart', pageBuilder: (c,s)=>_page(const CartScreen())),
      GoRoute(path: '/checkout', pageBuilder: (c,s)=>_page(const CheckoutScreen())),
      GoRoute(path: '/coupon', pageBuilder: (c,s)=>_page(const CouponScreen())),
      GoRoute(path: '/invoice', pageBuilder: (c,s)=>_page(const InvoiceScreen())),
      GoRoute(path: '/order-confirmation', pageBuilder: (c,s)=>_page(const OrderConfirmationScreen())),
      GoRoute(path: '/order-tracking', pageBuilder: (c,s)=>_page(const OrderTrackingScreen())),
      GoRoute(path: '/payment', pageBuilder: (c,s)=>_page(const PaymentScreen())),
      GoRoute(path: '/returns', pageBuilder: (c,s)=>_page(const ReturnsScreen())),
      GoRoute(path: '/shipping-method', pageBuilder: (c,s)=>_page(const ShippingMethodScreen())),
      GoRoute(path: '/about', pageBuilder: (c,s)=>_page(const AboutScreen())),
      GoRoute(path: '/edit-profile', pageBuilder: (c,s)=>_page(const EditProfileScreen())),
      GoRoute(path: '/help-support', pageBuilder: (c,s)=>_page(const HelpSupportScreen())),
      GoRoute(path: '/notifications', pageBuilder: (c,s)=>_page(const NotificationsScreen())),
      GoRoute(path: '/privacy', pageBuilder: (c,s)=>_page(const PrivacyScreen())),
      GoRoute(path: '/profile', pageBuilder: (c,s)=>_page(const ProfileScreen())),
      GoRoute(path: '/settings', pageBuilder: (c,s)=>_page(const SettingsScreen())),
      GoRoute(path: '/wishlist', pageBuilder: (c,s)=>_page(const WishlistScreen())),
      GoRoute(path: '/saved-for-later', pageBuilder: (c,s)=>_page(const SavedForLaterScreen())),
      GoRoute(path: '/wishlist', pageBuilder: (c,s)=>_page(const WishlistScreen())),
]));

CustomTransitionPage<void> _page(Widget child) => CustomTransitionPage<void>(
  child: child,
  transitionsBuilder: (_, animation, __, child) => FadeTransition(
    opacity: animation,
    child: SlideTransition(position: Tween(begin: const Offset(0.07, 0), end: Offset.zero).animate(animation), child: child),
  ),
);
