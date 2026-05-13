// lib/screens/ai/ai_settings_screens.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/providers.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _ctrl = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _quickReplies = [
    'Best leather wallets under ₹1500',
    'Recommend office bags',
    'What leather jackets are trending?',
    'Free shipping details',
    'Return policy',
  ];

  @override
  void initState() {
    super.initState();
    _addBotMessage('Hello! 👋 I\'m MOSPL\'s AI assistant. I can help you find the perfect leather product, answer questions about orders, shipping, and more.\n\nWhat are you looking for today?');
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: false, time: DateTime.now()));
    });
    _scrollToBottom();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _ctrl.clear();
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isTyping = false);
      _addBotMessage(_getAIResponse(text));
    });
  }

  String _getAIResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('wallet') || q.contains('वॉलेट')) {
      return '🔥 Our top wallets right now:\n\n1. **Slim Bifold Wallet** — ₹1,199 (RFID protected)\n2. **Long Envelope Clutch** — ₹1,599 (Women\'s)\n3. **Vintage Trifold** — ₹999 (Classic style)\n\nAll made from premium leather with RFID blocking. Would you like me to show you more details on any of these?';
    } else if (q.contains('jacket') || q.contains('जैकेट')) {
      return '🧥 Trending leather jackets this season:\n\n1. **Classic Biker Jacket** — ₹6,999 (Best seller!)\n2. **Slim Fit Café Racer** — ₹5,999 (New arrival)\n3. **Bomber Flight Jacket** — ₹7,499\n\nAll available in multiple colors. Free delivery on all jackets!';
    } else if (q.contains('office') || q.contains('laptop') || q.contains('bag')) {
      return '💼 Perfect for the modern professional:\n\n1. **Executive Briefcase** — ₹7,999 (Fits 15.6" laptop)\n2. **Leather Laptop Backpack** — ₹5,499 (Anti-theft)\n3. **Heritage Tote** — ₹4,499 (Best seller)\n\nAll bags come with free delivery and 7-day returns!';
    } else if (q.contains('return') || q.contains('refund')) {
      return '↩️ **MOSPL Return Policy:**\n\n• 7-day hassle-free returns\n• 15-day exchange policy\n• Full refund for manufacturing defects\n• Free reverse pickup from your doorstep\n\nTo initiate a return, go to Profile → My Orders → Request Return. Need help with a specific order?';
    } else if (q.contains('shipping') || q.contains('delivery') || q.contains('free')) {
      return '🚚 **Delivery Information:**\n\n• **Free Delivery** on orders above ₹999\n• Standard: 5-7 days\n• Express: 1-2 days (₹199)\n• Same-day available in select cities\n\nWe deliver pan-India including remote areas!';
    } else if (q.contains('coupon') || q.contains('discount') || q.contains('offer')) {
      return '🎁 **Active Coupons:**\n\n• **MOSPL10** — 10% off (min ₹999)\n• **LEATHER500** — ₹500 off (min ₹3,999)\n• **NEWUSER** — 15% off for first order\n\nCopy the code and apply at checkout. Happy shopping! 🛍️';
    } else if (q.contains('payment') || q.contains('upi') || q.contains('card')) {
      return '💳 **Payment Options:**\n\n• UPI (GPay, PhonePe, Paytm)\n• Credit/Debit Cards (All major)\n• Net Banking\n• Cash on Delivery\n• MOSPL Wallet\n\nAll payments are 100% secure with SSL encryption!';
    } else if (q.contains('track') || q.contains('order status')) {
      return '📦 To track your order:\n\n1. Go to Profile → My Orders\n2. Select your order\n3. Click "Track Order"\n\nYou\'ll see real-time tracking with delivery partner details. Need me to check a specific order?';
    } else if (q.contains('recommend') || q.contains('suggest') || q.contains('gift')) {
      return '🎁 Based on popular choices, here are my top gift recommendations:\n\n• **Under ₹1,500:** Slim Bifold Wallet or Keychain Set\n• **Under ₹5,000:** Heritage Tote or Crossbody Satchel\n• **Under ₹10,000:** Executive Briefcase or Biker Jacket\n\nAll come in premium gift packaging! Who\'s the gift for?';
    } else {
      return 'I\'m here to help! You can ask me about:\n\n🛍️ Product recommendations\n📦 Order tracking & returns\n🚚 Shipping & delivery\n💳 Payment options\n🎁 Gift suggestions\n💰 Coupons & offers\n\nWhat would you like to know?';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.softBrown, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 22)),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('MOSPL AI', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700)),
            Row(children: [
              CircleAvatar(radius: 4, backgroundColor: AppColors.accentSuccess),
              SizedBox(width: 5),
              Text('Online', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.accentSuccess)),
            ]),
          ]),
        ]),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length && _isTyping) return _TypingIndicator();
                return _MessageBubble(message: _messages[i]);
              },
            ),
          ),
          // Quick replies
          if (_messages.length <= 2)
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _quickReplies.map((q) => GestureDetector(
                  onTap: () => _sendMessage(q),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.softBrown), borderRadius: BorderRadius.circular(20), color: AppColors.warmBeige),
                    child: Text(q, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softBrown, fontWeight: FontWeight.w500)),
                  ),
                )).toList(),
              ),
            ),
          const SizedBox(height: 8),
          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))]),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Ask me anything...',
                    hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textLight),
                    filled: true,
                    fillColor: AppColors.bgLightCream,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _sendMessage(_ctrl.text),
                child: Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: AppColors.softBrown, shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  _ChatMessage({required this.text, required this.isUser, required this.time});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.softBrown, shape: BoxShape.circle), child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.matteBlack : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Text(
                message.text,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: message.isUser ? Colors.white : AppColors.textCharcoal, height: 1.5),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.softBrown, shape: BoxShape.circle), child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18), bottomLeft: Radius.circular(4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)]),
          child: Row(children: List.generate(3, (i) => AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final delay = i * 0.2;
              final value = ((_ctrl.value - delay).clamp(0, 1));
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 7, height: 7,
                decoration: BoxDecoration(color: AppColors.softBrown.withOpacity(0.3 + 0.7 * value), shape: BoxShape.circle),
              );
            },
          ))),
        ),
      ],
    );
  }
}

// ==================== SETTINGS SCREEN ====================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _offerNotifications = true;
  bool _deliveryAlerts = true;
  bool _emailNotifications = false;
  bool _biometricLogin = false;
  bool _appLock = false;
  bool _aiRecommendations = true;
  bool _personalizedShopping = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Settings
          _buildSection('Account Settings', [
            _buildNavTile(Icons.person_outline, 'Edit Profile', () => Navigator.pushNamed(context, AppRoutes.editProfile)),
            _buildNavTile(Icons.lock_outline, 'Change Password', () {}),
            _buildNavTile(Icons.email_outlined, 'Change Email', () {}),
            _buildNavTile(Icons.phone_outlined, 'Change Mobile Number', () {}),
            _buildNavTile(Icons.location_on_outlined, 'Manage Addresses', () => Navigator.pushNamed(context, AppRoutes.addAddress)),
          ]),

          // Theme
          _buildSection('Appearance', [
            Consumer<ThemeProvider>(
              builder: (context, theme, _) => _buildSwitchTile(
                Icons.dark_mode_outlined,
                'Dark Mode',
                'Switch between light and dark theme',
                theme.isDark,
                    (val) => theme.toggleTheme(),
              ),
            ),
          ]),

          // Notification Settings
          _buildSection('Notification Settings', [
            _buildSwitchTile(Icons.notifications_outlined, 'Push Notifications', 'Get app notifications', _pushNotifications, (v) => setState(() => _pushNotifications = v)),
            _buildSwitchTile(Icons.local_offer_outlined, 'Offer & Deals', 'Sales and discount alerts', _offerNotifications, (v) => setState(() => _offerNotifications = v)),
            _buildSwitchTile(Icons.local_shipping_outlined, 'Delivery Alerts', 'Order and shipping updates', _deliveryAlerts, (v) => setState(() => _deliveryAlerts = v)),
            _buildSwitchTile(Icons.email_outlined, 'Email Notifications', 'Receive emails from MOSPL', _emailNotifications, (v) => setState(() => _emailNotifications = v)),
          ]),

          // Privacy & Security
          _buildSection('Privacy & Security', [
            _buildSwitchTile(Icons.fingerprint_rounded, 'Biometric Login', 'Use fingerprint or face unlock', _biometricLogin, (v) => setState(() => _biometricLogin = v)),
            _buildSwitchTile(Icons.lock_outlined, 'App Lock', 'Require auth to open app', _appLock, (v) => setState(() => _appLock = v)),
            _buildNavTile(Icons.devices_outlined, 'Manage Devices', () {}),
            _buildNavTile(Icons.history_rounded, 'Login Activity', () {}),
            _buildNavTile(Icons.security_outlined, 'Privacy Controls', () => Navigator.pushNamed(context, AppRoutes.privacy)),
          ]),

          // AI Settings
          _buildSection('AI & Personalization', [
            _buildSwitchTile(Icons.smart_toy_outlined, 'AI Recommendations', 'Get personalized product suggestions', _aiRecommendations, (v) => setState(() => _aiRecommendations = v)),
            _buildSwitchTile(Icons.person_search_outlined, 'Personalized Shopping', 'AI learns your style preferences', _personalizedShopping, (v) => setState(() => _personalizedShopping = v)),
            _buildNavTile(Icons.chat_bubble_outline, 'AI Chat Settings', () => Navigator.pushNamed(context, AppRoutes.aiChat)),
          ]),

          // Payment
          _buildSection('Payment Settings', [
            _buildNavTile(Icons.credit_card_outlined, 'Saved Cards', () {}),
            _buildNavTile(Icons.phone_android_rounded, 'UPI Settings', () {}),
            _buildNavTile(Icons.account_balance_wallet_outlined, 'MOSPL Wallet', () {}),
            _buildNavTile(Icons.receipt_outlined, 'Transaction History', () {}),
          ]),

          // Support
          _buildSection('Support & Help', [
            _buildNavTile(Icons.smart_toy_outlined, 'AI Chat Assistant', () => Navigator.pushNamed(context, AppRoutes.aiChat)),
            _buildNavTile(Icons.headset_mic_outlined, 'Contact Support', () => Navigator.pushNamed(context, AppRoutes.support)),
            _buildNavTile(Icons.help_outline_rounded, 'FAQ', () => Navigator.pushNamed(context, AppRoutes.faq)),
            _buildNavTile(Icons.description_outlined, 'Terms & Conditions', () => Navigator.pushNamed(context, AppRoutes.terms)),
            _buildNavTile(Icons.policy_outlined, 'Privacy Policy', () => Navigator.pushNamed(context, AppRoutes.privacy)),
          ]),

          // App Info
          _buildSection('App Info', [
            _buildInfoTile('App Version', AppConstants.appVersion),
            _buildInfoTile('Company', AppConstants.companyName),
            _buildInfoTile('Build', 'Production v1.0.0'),
          ]),

          const SizedBox(height: 16),
          // Delete account
          Container(
            decoration: BoxDecoration(border: Border.all(color: AppColors.accentError.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: AppColors.accentError),
              title: const Text('Delete Account', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accentError)),
              subtitle: const Text('Permanently delete your account and data', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
              onTap: () => _confirmDeleteAccount(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Text(title, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textCharcoal, letterSpacing: 0.3)),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(
            children: children.asMap().entries.map((e) => Column(children: [
              e.value,
              if (e.key < children.length - 1) const Divider(height: 1, color: AppColors.divider, indent: 56),
            ])).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNavTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: AppColors.softBrown)),
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textCharcoal)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: AppColors.softBrown)),
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textCharcoal)),
      subtitle: Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.softBrown),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textCharcoal)),
      trailing: Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray, fontWeight: FontWeight.w500)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account?', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: AppColors.accentError)),
        content: const Text('This action is permanent. All your data, orders history, and reward points will be deleted and cannot be recovered.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins'))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().deleteAccount();
              if (context.mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentError),
            child: const Text('Delete My Account', style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }
}

// ==================== ORDER TRACKING SCREEN ====================
class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Order Placed', 'sub': 'Your order was confirmed', 'icon': Icons.check_circle_rounded, 'done': true, 'time': '05 Jan, 10:30 AM'},
      {'label': 'Order Confirmed', 'sub': 'Payment verified, packing started', 'icon': Icons.inventory_2_rounded, 'done': true, 'time': '05 Jan, 11:00 AM'},
      {'label': 'Shipped', 'sub': 'Handed to BlueDart Express', 'icon': Icons.local_shipping_rounded, 'done': true, 'time': '06 Jan, 02:15 PM'},
      {'label': 'Out for Delivery', 'sub': 'Your package is on the way!', 'icon': Icons.delivery_dining_rounded, 'done': false, 'time': 'Today'},
      {'label': 'Delivered', 'sub': 'Estimated: Today by 7 PM', 'icon': Icons.home_rounded, 'done': false, 'time': 'Expected Today'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking ID card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.matteBlack, borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const Icon(Icons.qr_code_rounded, color: AppColors.softGold, size: 40),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Tracking ID', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white54)),
                  Text('MSPTRK${orderId.hashCode.abs()}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  const Text('BlueDart Express · In Transit', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.softGold)),
                ])),
              ]),
            ),
            const SizedBox(height: 24),

            const Text('Delivery Progress', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            // Timeline
            ...steps.asMap().entries.map((e) {
              final step = e.value;
              final isLast = e.key == steps.length - 1;
              final isDone = step['done'] as bool;
              final isActive = e.key == steps.indexWhere((s) => !(s['done'] as bool));

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isDone ? AppColors.accentSuccess : (isActive ? AppColors.softBrown : AppColors.bgLightCream),
                          shape: BoxShape.circle,
                          border: Border.all(color: isDone ? AppColors.accentSuccess : (isActive ? AppColors.softBrown : AppColors.border), width: 2),
                        ),
                        child: Icon(step['icon'] as IconData, size: 20, color: isDone || isActive ? Colors.white : AppColors.textLight),
                      ),
                      if (!isLast) Container(width: 2, height: 50, color: isDone ? AppColors.accentSuccess : AppColors.border),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: 8),
                        Text(step['label'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isDone || isActive ? AppColors.textCharcoal : AppColors.textLight)),
                        Text(step['sub'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                        Text(step['time'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: isActive ? AppColors.softBrown : AppColors.textLight, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ),
                ],
              );
            }).toList(),
            const SizedBox(height: 24),

            // Map placeholder
            Container(
              height: 160,
              decoration: BoxDecoration(color: AppColors.bgLightCream, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.map_outlined, size: 40, color: AppColors.softBrown),
                SizedBox(height: 8),
                Text('Live Map Tracking', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray, fontWeight: FontWeight.w500)),
                Text('Map available after dispatch', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
              ])),
            ),
          ],
        ),
      ),
    );
  }
}