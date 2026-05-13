// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeIn)),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.elasticOut)),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic)),
    );

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(AppConstants.keyOnboardingDone) ?? false;
    final authProvider = context.read<AuthProvider>();

    if (!onboardingDone) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    } else if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.matteBlack,
      body: Stack(
        children: [
          // Background texture pattern
          Positioned.fill(
            child: CustomPaint(painter: _LeatherTexturePainter()),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                ScaleTransition(
                  scale: _scaleAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.softGold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.softGold.withOpacity(0.5), width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              'M',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 56,
                                fontWeight: FontWeight.w700,
                                color: AppColors.softGold,
                                letterSpacing: -2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'MOSPL',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                            color: AppColors.creamWhite,
                            letterSpacing: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tagline
                SlideTransition(
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 1,
                          color: AppColors.softGold.withOpacity(0.6),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppConstants.appTagline.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.warmBeige.withOpacity(0.7),
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 40,
                          height: 1,
                          color: AppColors.softGold.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom branding
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  // Loading dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildDot(index)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'by ${AppConstants.companyName}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.warmBeige.withOpacity(0.4),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index * 0.15;
        final value = ((_controller.value - delay).clamp(0, 0.5)) / 0.5;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.softGold.withOpacity(0.3 + 0.7 * value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _LeatherTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.softBrown.withOpacity(0.04)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 24) {
      for (double j = 0; j < size.height; j += 24) {
        canvas.drawCircle(Offset(i, j), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== ONBOARDING SCREEN ====================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Premium\nLeather Craft',
      subtitle: 'Discover exquisite leather products crafted by master artisans from Chennai. Each piece tells a story.',
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600',
      accentText: 'ARTISAN QUALITY',
    ),
    _OnboardingData(
      title: 'Curated\nCollections',
      subtitle: 'From slim wallets to executive briefcases — explore 10 premium categories of genuine leather goods.',
      imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600',
      accentText: 'HANDPICKED',
    ),
    _OnboardingData(
      title: 'Smart\nShopping',
      subtitle: 'Our AI learns your style and suggests products you\'ll love. Get personalized recommendations every time.',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
      accentText: 'AI POWERED',
    ),
    _OnboardingData(
      title: 'Fast &\nSecure Delivery',
      subtitle: 'Pan-India delivery with real-time tracking. Free shipping on orders above ₹999. Easy 7-day returns.',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      accentText: 'ACROSS INDIA',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingDone, true);
    if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
          ),
          // Bottom Controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bgOffWhite.withOpacity(0),
                    AppColors.bgOffWhite,
                    AppColors.bgOffWhite,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                          (i) => AnimatedContainer(
                        duration: AppConstants.shortAnimation,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage ? AppColors.softBrown : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Buttons
                  Row(
                    children: [
                      if (_currentPage < _pages.length - 1) ...[
                        Expanded(
                          child: TextButton(
                            onPressed: _complete,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                color: AppColors.textDarkGray,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => _pageController.nextPage(
                              duration: AppConstants.mediumAnimation,
                              curve: Curves.easeInOut,
                            ),
                            child: const Text('Next'),
                          ),
                        ),
                      ] else
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _complete,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                            child: const Text('Get Started'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String accentText;

  _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.accentText,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image - takes 55% of screen
        SizedBox(
          height: size.height * 0.55,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                data.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.warmBeige,
                  child: const Icon(Icons.image, size: 60, color: AppColors.softBrown),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.bgOffWhite.withOpacity(0.4),
                      AppColors.bgOffWhite,
                    ],
                    stops: const [0.5, 0.85, 1.0],
                  ),
                ),
              ),
              // Accent badge
              Positioned(
                top: 60,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.matteBlack.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data.accentText,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.softGold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textCharcoal,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                data.subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  color: AppColors.textDarkGray,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}