// lib/main.dart — COMPLETE VERSION with all routes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'themes/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'providers/auth_provider.dart';
import 'providers/providers.dart';
import 'models/models.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/auth/auth_screens.dart';
import 'screens/home/home_screen.dart';
import 'screens/product/product_screens.dart';
import 'screens/cart/cart_checkout_screens.dart';
import 'screens/profile/profile_screens.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/admin_product_form.dart';
import 'screens/ai/ai_settings_screens.dart';
import 'screens/misc/remaining_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'YOUR_API_KEY',
        appId: '1:000000000000:android:0000000000000000',
        messagingSenderId: '000000000000',
        projectId: 'mospl-app',
        storageBucket: 'mospl-app.appspot.com',
      ),
    );
  } catch (e) {
    debugPrint('Firebase init: $e');
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MOSPLApp());
}

class MOSPLApp extends StatelessWidget {
  const MOSPLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            onGenerateRoute: AppRouter.generate,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}

// ==================== ROUTER ====================
class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name ?? '';

    // Dynamic route matching
    if (name.startsWith('/product/')) {
      if (args is ProductModel) return _slide(ProductDetailScreen(product: args));
      return _slide(const HomeScreen());
    }
    if (name.startsWith('/order/') && name.length > 7) {
      return _slide(const OrderHistoryScreen());
    }
    if (name.startsWith('/order-tracking/')) {
      final id = name.replaceFirst('/order-tracking/', '');
      return _slide(OrderTrackingScreen(orderId: id));
    }
    if (name.startsWith('/reviews/')) {
      return _slide(const HomeScreen()); // placeholder
    }
    if (name.startsWith('/admin/products/') && name.endsWith('/edit')) {
      return _slide(AdminAddProductScreen(existingProduct: args as Map<String, dynamic>?));
    }
    if (name.startsWith('/return-request/')) {
      return _slide(const OrderHistoryScreen());
    }
    if (name.startsWith('/invoice/')) {
      return _slide(const OrderHistoryScreen());
    }

    switch (name) {
      case AppRoutes.splash:
        return _fade(const SplashScreen());
      case AppRoutes.onboarding:
        return _slide(const OnboardingScreen());
      case AppRoutes.login:
        return _fade(const LoginScreen());
      case AppRoutes.register:
        return _slide(const RegisterScreen());
      case AppRoutes.forgotPassword:
        return _slide(const ForgotPasswordScreen());
      case AppRoutes.otpVerification:
        final phone = (args as Map<String, dynamic>?)?['phone'] ?? '';
        return _slide(OtpVerificationScreen(phone: phone));
      case AppRoutes.home:
        return _fade(const HomeScreen());
      case AppRoutes.productListing:
        final a = args as Map<String, dynamic>?;
        return _slide(ProductListingScreen(
          categoryId: a?['categoryId'],
          categoryName: a?['categoryName'],
          filter: a?['filter'],
        ));
      case AppRoutes.search:
        return _fade(const SearchScreen());
      case AppRoutes.cart:
        return _slide(const CartScreen());
      case AppRoutes.wishlist:
        return _slide(const WishlistScreen());
      case AppRoutes.checkout:
        return _slide(const CheckoutScreen());
      case AppRoutes.addressSelection:
        return _slide(const AddAddressScreen());
      case AppRoutes.addAddress:
        return _slide(const AddAddressScreen());
      case AppRoutes.orderConfirmation:
        if (args is OrderModel) return _fade(OrderConfirmationScreen(order: args));
        return _fade(const HomeScreen());
      case AppRoutes.orderHistory:
        return _slide(const OrderHistoryScreen());
      case AppRoutes.profile:
        return _fade(const ProfileScreen());
      case AppRoutes.editProfile:
        return _slide(const EditProfileScreen());
      case AppRoutes.settings:
        return _slide(const SettingsScreen());
      case AppRoutes.notifications:
        return _slide(const NotificationsScreen());
      case AppRoutes.aiChat:
        return _slide(const AIChatScreen());
      case AppRoutes.coupons:
        return _slide(const CouponsScreen());
      case AppRoutes.rewardPoints:
        return _slide(const RewardPointsScreen());
      case AppRoutes.support:
        return _slide(const SupportScreen());
      case AppRoutes.faq:
        return _slide(const FAQScreen());
      case AppRoutes.privacy:
        return _slide(const PrivacyPolicyScreen());
      case AppRoutes.terms:
        return _slide(const TermsAndConditionsScreen());
      case AppRoutes.adminDashboard:
        return _slide(const AdminDashboardScreen());
      case AppRoutes.adminAddProduct:
        return _slide(const AdminAddProductScreen());
      case AppRoutes.adminProducts:
        return _slide(const AdminDashboardScreen());
      case AppRoutes.adminOrders:
        return _slide(const AdminDashboardScreen());
      case AppRoutes.adminUsers:
        return _slide(const AdminDashboardScreen());
      case AppRoutes.adminAnalytics:
        return _slide(const AdminDashboardScreen());
      default:
        return _fade(const HomeScreen());
    }
  }

  static PageRoute _fade(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: AppConstants.pageTransition,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );

  static PageRoute _slide(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: AppConstants.pageTransition,
    transitionsBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
      child: child,
    ),
  );
}

// ==================== EDIT PROFILE SCREEN ====================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final auth = context.read<AuthProvider>();
    final success = await auth.updateProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
    setState(() => _isSaving = false);
    if (success && mounted) {
      AppSnackbar.show(context, AppStrings.profileUpdated);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Avatar
          Center(
            child: Stack(
              children: [
                Consumer<AuthProvider>(
                  builder: (_, auth, __) => CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.warmBeige,
                    backgroundImage: auth.user?.profileImage != null
                        ? NetworkImage(auth.user!.profileImage!)
                        : null,
                    child: auth.user?.profileImage == null
                        ? Text(
                      auth.user?.name.isNotEmpty == true
                          ? auth.user!.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.softBrown,
                      ),
                    )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.softBrown,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_outlined,
                        size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _nameCtrl,
            label: 'Full Name',
            prefixIcon: Icons.person_outline,
            validator: (v) =>
            v == null || v.isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _phoneCtrl,
            label: 'Mobile Number',
            prefixIcon: Icons.phone_outlined,
            prefixText: '+91 ',
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _emailCtrl,
            label: 'Email Address',
            prefixIcon: Icons.email_outlined,
            readOnly: true,
          ),
          const SizedBox(height: 8),
          const Text(
            'Email cannot be changed here. Use Account Settings to change email.',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textLight),
          ),
          const SizedBox(height: 32),
          LoadingButton(
            onPressed: _save,
            isLoading: _isSaving,
            label: 'Save Changes',
          ),
        ],
      ),
    );
  }
}