import 'package:flutter/material.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/auth_screens.dart';
import '../screens/catalog_screens.dart';
import '../screens/feature_screen.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const product = '/product';
  static const settings = '/settings';
  static const admin = '/admin';

  static final featureScreens = <FeatureSpec>[
    ..._auth,
    ..._shop,
    ..._orders,
    ..._settings,
    ..._admin,
  ];

  static Map<String, WidgetBuilder> routes() => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingScreen(),
        login: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
        settings: (_) => const SettingsScreen(),
        admin: (_) => const AdminDashboardScreen(),
        for (final spec in featureScreens) spec.route: (_) => FeatureScreen(spec: spec),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == product) {
      return MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: settings.arguments! as String));
    }
    return null;
  }
}

const _auth = [
  FeatureSpec('/auth/otp-login', 'OTP Login', 'Verify mobile numbers using Firebase phone authentication.', Icons.sms_outlined),
  FeatureSpec('/auth/password-login', 'Password Login', 'Secure email and password authentication with JWT sessions.', Icons.password),
  FeatureSpec('/auth/email-login', 'Email Login', 'Magic-link style email login flow ready for Firebase Auth.', Icons.alternate_email),
  FeatureSpec('/auth/signup', 'Sign Up', 'Create premium customer accounts with profile preferences.', Icons.person_add_alt),
  FeatureSpec('/auth/forgot-password', 'Forgot Password', 'Send password reset instructions and validate requests.', Icons.lock_reset),
  FeatureSpec('/auth/reset-password', 'Reset Password', 'Confirm reset tokens and update credentials securely.', Icons.key),
  FeatureSpec('/auth/google', 'Google Login', 'Google Sign-In integration placeholder and Firebase linking.', Icons.g_mobiledata),
  FeatureSpec('/auth/session', 'Session Management', 'View active sessions and revoke trusted devices.', Icons.devices),
  FeatureSpec('/auth/biometric', 'Biometric Auth', 'Fingerprint and Face Unlock backed by local_auth.', Icons.fingerprint),
  FeatureSpec('/auth/two-factor', 'Two-Factor Auth', 'Enable app, SMS, or email second-factor verification.', Icons.verified_user),
];

const _shop = [
  FeatureSpec('/shop/cart', 'Cart', 'Review selected products, quantities, offers, taxes, and checkout total.', Icons.shopping_bag_outlined),
  FeatureSpec('/shop/wishlist', 'Wishlist', 'Saved luxury leather products synchronized to Firestore.', Icons.favorite_border),
  FeatureSpec('/shop/search', 'Smart Search', 'Text and voice search with AI recommendations and history.', Icons.search),
  FeatureSpec('/shop/voice-search', 'Voice Search', 'Speech-to-text product discovery flow placeholder.', Icons.mic_none),
  FeatureSpec('/shop/filters', 'Filter & Sort', 'Filter by category, price, rating, color, size, and discount.', Icons.tune),
  FeatureSpec('/shop/ai-recommendations', 'AI Recommendations', 'Personalized products inferred from views, wishlist, and orders.', Icons.auto_awesome),
  FeatureSpec('/shop/chatbot', 'AI Chatbot', 'Shopping assistant for sizing, gift ideas, leather care, and order help.', Icons.support_agent),
  FeatureSpec('/shop/checkout', 'Checkout', 'Address, coupon, payment, and order confirmation flow.', Icons.payments_outlined),
  FeatureSpec('/shop/payments', 'Payment Integration', 'UPI, cards, wallets, COD, and secure payment status handling.', Icons.credit_card),
  FeatureSpec('/shop/address', 'Address Management', 'Create and manage shipping and billing addresses.', Icons.location_on_outlined),
  FeatureSpec('/shop/coupons', 'Coupons & Offers', 'Premium offers, coupon validation, and discount eligibility.', Icons.local_offer_outlined),
  FeatureSpec('/shop/notifications', 'Notifications', 'Order, offer, wishlist, and support notifications.', Icons.notifications_none),
  FeatureSpec('/shop/reviews', 'Reviews & Ratings', 'Verified purchase reviews with moderation-ready data.', Icons.star_border),
  FeatureSpec('/shop/support', 'Customer Support', 'Support tickets, live chat, FAQ, and complaint tracking.', Icons.headset_mic_outlined),
  FeatureSpec('/shop/recently-viewed', 'Recently Viewed', 'Continue browsing products viewed across sessions.', Icons.history),
  FeatureSpec('/shop/rewards', 'Reward Points', 'Track loyalty points, premium tiers, and redemption options.', Icons.card_giftcard),
  FeatureSpec('/shop/profile', 'User Profile', 'Manage identity, contact details, preferences, and sizing.', Icons.person_outline),
];

const _orders = [
  FeatureSpec('/orders/list', 'Order Management', 'All orders with filters by status, date, and amount.', Icons.receipt_long),
  FeatureSpec('/orders/tracking', 'Live Order Tracking', 'Courier stages and real-time tracking events.', Icons.local_shipping_outlined),
  FeatureSpec('/orders/timeline', 'Delivery Timeline', 'Shipment timeline from confirmation to delivery.', Icons.timeline),
  FeatureSpec('/orders/invoice', 'Invoice Download', 'Generate and download tax invoices for completed orders.', Icons.picture_as_pdf),
  FeatureSpec('/orders/returns', 'Returns & Refunds', 'Return eligibility, pickup scheduling, and refund status.', Icons.assignment_return_outlined),
  FeatureSpec('/orders/refund-tracking', 'Refund Tracking', 'Track payment reversals, wallet credits, and bank refunds.', Icons.currency_rupee),
];

const _settings = [
  FeatureSpec('/settings/edit-profile', 'Edit Profile', 'Update profile image, name, email, mobile, and gender.', Icons.edit),
  FeatureSpec('/settings/change-password', 'Change Password', 'Authenticated password update with security checks.', Icons.lock_outline),
  FeatureSpec('/settings/change-email', 'Change Email', 'Email verification and account relinking workflow.', Icons.email_outlined),
  FeatureSpec('/settings/change-mobile', 'Change Mobile', 'OTP verification for mobile number changes.', Icons.phone_android),
  FeatureSpec('/settings/delete-account', 'Delete Account', 'Privacy-compliant account deletion request flow.', Icons.delete_outline),
  FeatureSpec('/settings/push', 'Push Notifications', 'Manage push, offers, delivery, wishlist, email, and SMS alerts.', Icons.notifications_active_outlined),
  FeatureSpec('/settings/privacy', 'Privacy Controls', 'Data permissions, app lock, devices, and login activity.', Icons.privacy_tip_outlined),
  FeatureSpec('/settings/payments', 'Payment Settings', 'Saved cards, UPI IDs, wallets, transactions, and refunds.', Icons.account_balance_wallet_outlined),
  FeatureSpec('/settings/preferences', 'App Preferences', 'Theme, language, currency, animation, and layout controls.', Icons.palette_outlined),
  FeatureSpec('/settings/ai', 'AI Settings', 'Toggle recommendations, personalization, smart suggestions, and chatbot memory.', Icons.psychology_outlined),
  FeatureSpec('/settings/help', 'Help Center', 'FAQ, contact support, complaint escalation, terms, and privacy policy.', Icons.help_outline),
  FeatureSpec('/settings/activity', 'Tracking & Analytics', 'Recently viewed, search history, login history, and purchase insights.', Icons.insights),
];

const _admin = [
  FeatureSpec('/admin/login', 'Admin Login', 'Role-based admin authentication and privileged session checks.', Icons.admin_panel_settings),
  FeatureSpec('/admin/add-product', 'Add Products', 'Create products, variants, pricing, stock, delivery, and SEO data.', Icons.add_box_outlined),
  FeatureSpec('/admin/edit-product', 'Edit Products', 'Update descriptions, images, variants, stock, and offers.', Icons.edit_note),
  FeatureSpec('/admin/delete-product', 'Delete Products', 'Soft delete and audit product removal actions.', Icons.delete_sweep_outlined),
  FeatureSpec('/admin/upload-images', 'Upload Images', 'Firebase Storage upload workflow for product galleries.', Icons.cloud_upload_outlined),
  FeatureSpec('/admin/categories', 'Manage Categories', 'Create and organize leather product categories.', Icons.category_outlined),
  FeatureSpec('/admin/users', 'Manage Users', 'Search customers, view profiles, roles, and account status.', Icons.group_outlined),
  FeatureSpec('/admin/orders', 'Manage Orders', 'Update order status, payment verification, and fulfillment.', Icons.inventory_2_outlined),
  FeatureSpec('/admin/inventory', 'Inventory Management', 'Stock levels, reorder points, warehouse and vendor fields.', Icons.warehouse_outlined),
  FeatureSpec('/admin/stock', 'Stock Management', 'Low-stock alerts, stock adjustments, and audit logs.', Icons.production_quantity_limits),
  FeatureSpec('/admin/revenue', 'Revenue Tracking', 'Daily, weekly, monthly revenue and margin reports.', Icons.currency_rupee),
  FeatureSpec('/admin/sales', 'Sales Tracking', 'Sales funnel and product/category performance monitoring.', Icons.trending_up),
  FeatureSpec('/admin/activity', 'User Activity', 'Customer behavior, sessions, events, and conversion metrics.', Icons.query_stats),
  FeatureSpec('/admin/product-analytics', 'Product Analytics', 'Views, wishlist rate, cart conversion, and return rate.', Icons.bar_chart),
  FeatureSpec('/admin/ai-sales', 'AI Sales Prediction', 'Demand forecasts and suggested campaigns from sales patterns.', Icons.auto_graph),
  FeatureSpec('/admin/bar-graphs', 'Bar Graphs', 'Revenue and stock visualization using fl_chart.', Icons.bar_chart_outlined),
  FeatureSpec('/admin/pie-charts', 'Pie Charts', 'Category share, customer cohorts, and order state analytics.', Icons.pie_chart_outline),
  FeatureSpec('/admin/notifications', 'Notifications Management', 'Create campaigns and transactional push notifications.', Icons.campaign_outlined),
  FeatureSpec('/admin/discounts', 'Discount Management', 'Schedule discounts, flash sales, and premium collection offers.', Icons.discount_outlined),
  FeatureSpec('/admin/coupons', 'Coupon Management', 'Coupon rules, usage limits, eligibility, and analytics.', Icons.confirmation_number_outlined),
  FeatureSpec('/admin/banners', 'Banner Management', 'Home carousel banners and campaign landing screens.', Icons.view_carousel_outlined),
  FeatureSpec('/admin/reviews', 'Review Moderation', 'Approve, reject, flag, or reply to customer reviews.', Icons.rate_review_outlined),
  FeatureSpec('/admin/delivery', 'Delivery Management', 'Courier partners, zones, timeline, SLA and delay handling.', Icons.delivery_dining),
  FeatureSpec('/admin/settings', 'Admin Settings', 'Dashboard customization, inventory alerts, and AI business insights.', Icons.settings_applications),
];
