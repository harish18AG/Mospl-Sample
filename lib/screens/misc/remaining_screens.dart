// lib/screens/misc/remaining_screens.dart
// Add Address, Write Review, Reviews List, Support, Rewards, FAQ, Privacy, Terms

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

// ==================== ADD ADDRESS SCREEN ====================
class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _line1Ctrl = TextEditingController();
  final _line2Ctrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  String _addressType = 'home';
  bool _isDefault = false;
  bool _isSaving = false;

  final List<String> _indianStates = ['Andhra Pradesh','Arunachal Pradesh','Assam','Bihar','Chhattisgarh','Goa','Gujarat','Haryana','Himachal Pradesh','Jharkhand','Karnataka','Kerala','Madhya Pradesh','Maharashtra','Manipur','Meghalaya','Mizoram','Nagaland','Odisha','Punjab','Rajasthan','Sikkim','Tamil Nadu','Telangana','Tripura','Uttar Pradesh','Uttarakhand','West Bengal','Delhi','Jammu & Kashmir','Ladakh','Puducherry'];

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); _line1Ctrl.dispose(); _line2Ctrl.dispose(); _cityCtrl.dispose(); _stateCtrl.dispose(); _pincodeCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final auth = context.read<AuthProvider>();
    final address = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'line1': _line1Ctrl.text.trim(),
      'line2': _line2Ctrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'state': _stateCtrl.text.trim(),
      'pincode': _pincodeCtrl.text.trim(),
      'type': _addressType,
      'isDefault': _isDefault,
    };
    final success = await auth.addAddress(address);
    setState(() => _isSaving = false);
    if (success && mounted) { AppSnackbar.show(context, 'Address added successfully!'); Navigator.pop(context); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Address type selector
            Row(children: ['home', 'work', 'other'].map((type) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => setState(() => _addressType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: _addressType == type ? AppColors.matteBlack : AppColors.bgLightCream, borderRadius: BorderRadius.circular(10), border: Border.all(color: _addressType == type ? AppColors.matteBlack : AppColors.border)),
                  child: Row(children: [
                    Icon(type == 'home' ? Icons.home_outlined : type == 'work' ? Icons.work_outline : Icons.location_on_outlined, size: 16, color: _addressType == type ? Colors.white : AppColors.textCharcoal),
                    const SizedBox(width: 6),
                    Text(type.toUpperCase(), style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: _addressType == type ? Colors.white : AppColors.textCharcoal)),
                  ]),
                ),
              ),
            )).toList()),
            const SizedBox(height: 20),
            CustomTextField(controller: _nameCtrl, label: 'Full Name', prefixIcon: Icons.person_outline, validator: (v) => v == null || v.isEmpty ? 'Enter full name' : null),
            const SizedBox(height: 14),
            CustomTextField(controller: _phoneCtrl, label: 'Phone Number', prefixIcon: Icons.phone_outlined, prefixText: '+91 ', keyboardType: TextInputType.phone, maxLength: 10, validator: (v) => v == null || v.length != 10 ? 'Enter valid phone number' : null),
            const SizedBox(height: 14),
            CustomTextField(controller: _line1Ctrl, label: 'Address Line 1', prefixIcon: Icons.home_outlined, validator: (v) => v == null || v.isEmpty ? 'Enter address' : null),
            const SizedBox(height: 14),
            CustomTextField(controller: _line2Ctrl, label: 'Address Line 2 (Optional)', prefixIcon: Icons.home_outlined),
            const SizedBox(height: 14),
            CustomTextField(controller: _cityCtrl, label: 'City', prefixIcon: Icons.location_city_outlined, validator: (v) => v == null || v.isEmpty ? 'Enter city' : null),
            const SizedBox(height: 14),
            // State dropdown
            DropdownButtonFormField<String>(
              value: _stateCtrl.text.isEmpty ? null : _stateCtrl.text,
              decoration: InputDecoration(prefixIcon: const Icon(Icons.map_outlined, size: 20, color: AppColors.textLight), labelText: 'State', filled: true, fillColor: AppColors.bgLightCream, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border))),
              items: _indianStates.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)))).toList(),
              onChanged: (v) => setState(() => _stateCtrl.text = v ?? ''),
              validator: (v) => v == null || v.isEmpty ? 'Select state' : null,
            ),
            const SizedBox(height: 14),
            CustomTextField(controller: _pincodeCtrl, label: 'PIN Code', prefixIcon: Icons.pin_outlined, keyboardType: TextInputType.number, maxLength: 6, validator: (v) => v == null || v.length != 6 ? 'Enter valid 6-digit PIN' : null),
            const SizedBox(height: 14),
            Row(children: [
              Checkbox(value: _isDefault, onChanged: (v) => setState(() => _isDefault = v ?? false), activeColor: AppColors.softBrown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 8),
              const Text('Set as default address', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textCharcoal)),
            ]),
            const SizedBox(height: 28),
            LoadingButton(onPressed: _save, isLoading: _isSaving, label: 'Save Address'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ==================== REWARD POINTS SCREEN ====================
class RewardPointsScreen extends StatelessWidget {
  const RewardPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final points = user?.rewardPoints ?? 0;
    final rupeeValue = (points * AppConstants.rewardPointValue).toStringAsFixed(0);

    final history = [
      {'action': 'Order Placed', 'points': '+120', 'date': '05 Jan 2024', 'positive': true},
      {'action': 'Review Submitted', 'points': '+50', 'date': '04 Jan 2024', 'positive': true},
      {'action': 'Points Redeemed', 'points': '-200', 'date': '03 Jan 2024', 'positive': false},
      {'action': 'Welcome Bonus', 'points': '+100', 'date': '01 Jan 2024', 'positive': true},
      {'action': 'Referral Bonus', 'points': '+75', 'date': '31 Dec 2023', 'positive': true},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Reward Points'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Points card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.darkChocolate, AppColors.softBrown], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                const Icon(Icons.star_rounded, color: AppColors.softGold, size: 48),
                const SizedBox(height: 12),
                Text('$points', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 52, fontWeight: FontWeight.w700, color: Colors.white)),
                const Text('Reward Points', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Text('Worth ₹$rupeeValue', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            // How to earn
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('How to Earn Points', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _earnRow('🛍️', 'Every Purchase', '10 pts per ₹100 spent'),
                _earnRow('⭐', 'Write a Review', '50 pts per review'),
                _earnRow('👥', 'Refer a Friend', '75 pts per referral'),
                _earnRow('🎂', 'Birthday Bonus', '200 pts on your birthday'),
                _earnRow('🎁', 'Welcome Bonus', '100 pts on signup'),
              ]),
            ),
            const SizedBox(height: 20),
            // Points history
            const Align(alignment: Alignment.centerLeft, child: Text('Points History', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w700))),
            const SizedBox(height: 12),
            ...history.map((h) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: h['positive'] as bool ? AppColors.accentSuccess.withOpacity(0.1) : AppColors.accentError.withOpacity(0.1), shape: BoxShape.circle), child: Icon(h['positive'] as bool ? Icons.add_circle_outline : Icons.remove_circle_outline, color: h['positive'] as bool ? AppColors.accentSuccess : AppColors.accentError, size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(h['action'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textCharcoal)),
                  Text(h['date'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                ])),
                Text(h['points'] as String, style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700, color: h['positive'] as bool ? AppColors.accentSuccess : AppColors.accentError)),
              ]),
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _earnRow(String emoji, String action, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text(action, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textCharcoal))),
        Text(points, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentSuccess)),
      ]),
    );
  }
}

// ==================== COUPONS SCREEN ====================
class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coupons & Offers'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.coupons.length,
        itemBuilder: (_, i) {
          final c = DummyData.coupons[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 8)]),
            child: Column(children: [
              // Header
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.softBrown, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['title'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                    Text(c['description'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textDarkGray)),
                  ])),
                ]),
              ),
              // Code and details
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: AppColors.bgLightCream, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border, style: BorderStyle.solid)),
                      child: Text(c['code'] as String, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.softBrown, letterSpacing: 2)),
                    )),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () { AppSnackbar.show(context, 'Code ${c['code']} copied!'); },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      child: const Text('Copy', style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Min. order: ₹${c['minOrderValue']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                    Text('Max discount: ₹${c['maxDiscount']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                  ]),
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Valid till: ${c['expiryDate']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                    Text('${c['usageLimit']} uses', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                  ]),
                ]),
              ),
            ]),
          );
        },
      ),
    );
  }
}

// ==================== FAQ SCREEN ====================
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, String>> _faqs = [
    {'q': 'What is MOSPL?', 'a': 'MOSPL is a premium leather goods brand by onlinemadras.com, offering handcrafted leather products including bags, wallets, jackets, shoes, belts, and accessories.'},
    {'q': 'Are the leather products genuine?', 'a': 'Yes, absolutely. All MOSPL products use 100% genuine leather sourced ethically. Each product comes with a quality certificate. We use full-grain, top-grain, and vegetable-tanned leather depending on the product.'},
    {'q': 'What is the return policy?', 'a': 'We offer a 7-day hassle-free return policy. If you\'re not satisfied with your purchase, you can return it within 7 days of delivery for a full refund. The item must be unused and in original packaging.'},
    {'q': 'How long does delivery take?', 'a': 'Standard delivery takes 5-7 business days. Express delivery (₹199) takes 1-2 business days. Free shipping is available on orders above ₹999.'},
    {'q': 'How do I track my order?', 'a': 'Go to Profile → My Orders → Track Order. You\'ll see real-time tracking with the delivery partner\'s details and estimated delivery time.'},
    {'q': 'What payment methods are accepted?', 'a': 'We accept UPI (GPay, PhonePe, Paytm), Credit/Debit Cards (Visa, Mastercard, RuPay), Net Banking, and Cash on Delivery for orders up to ₹5,000.'},
    {'q': 'How do Reward Points work?', 'a': 'Earn 10 points for every ₹100 spent. Points are worth ₹0.50 each. Use them to get discounts on future orders. Points expire after 12 months from the date of earning.'},
    {'q': 'Can I exchange a product?', 'a': 'Yes, exchanges are allowed within 15 days of delivery for size or color changes, subject to availability. Contact our support team to initiate an exchange.'},
    {'q': 'How do I care for leather products?', 'a': 'Keep leather products away from direct sunlight and moisture. Apply leather conditioner every 3-6 months. Store in the provided dust bag when not in use. Clean with a slightly damp cloth for minor dirt.'},
    {'q': 'Do you offer gift packaging?', 'a': 'Yes! Select "Gift Packaging" during checkout for ₹49. Your order will arrive in a premium MOSPL gift box with a personalized message card.'},
    {'q': 'Is there a warranty on products?', 'a': 'All MOSPL products come with a 6-month warranty against manufacturing defects. This covers stitching failures, hardware defects, and material flaws under normal use conditions.'},
    {'q': 'How do I contact customer support?', 'a': 'You can reach us via the AI Chat Assistant (24/7), email at support@mospl.com, or call 1800-MOSPL-01 (Mon-Sat, 9AM-6PM IST).'},
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _faqs.length,
        itemBuilder: (_, i) {
          final isExpanded = _expandedIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _expandedIndex = isExpanded ? null : i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isExpanded ? AppColors.softBrown : AppColors.border, width: isExpanded ? 1.5 : 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(_faqs[i]['q']!, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: isExpanded ? FontWeight.w700 : FontWeight.w500, color: AppColors.textCharcoal))),
                    Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: AppColors.softBrown),
                  ]),
                  if (isExpanded) ...[
                    const SizedBox(height: 10),
                    const Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: 10),
                    Text(_faqs[i]['a']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray, height: 1.6)),
                  ],
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================== SUPPORT SCREEN ====================
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _category = 'Order Issue';
  final List<String> _categories = ['Order Issue', 'Payment Problem', 'Product Quality', 'Return/Refund', 'Delivery Delay', 'Account Issue', 'Other'];
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Quick actions
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.5, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            children: [
              _quickAction(Icons.smart_toy_outlined, 'AI Chat', () => Navigator.pushNamed(context, AppRoutes.aiChat)),
              _quickAction(Icons.phone_outlined, 'Call Us', () {}),
              _quickAction(Icons.email_outlined, 'Email', () {}),
              _quickAction(Icons.help_outline_rounded, 'FAQ', () => Navigator.pushNamed(context, AppRoutes.faq)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Raise a Ticket', style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: InputDecoration(labelText: 'Category', filled: true, fillColor: AppColors.bgLightCream, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border))),
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)))).toList(),
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
          const SizedBox(height: 14),
          CustomTextField(controller: _subjectCtrl, label: 'Subject', prefixIcon: Icons.subject_rounded),
          const SizedBox(height: 14),
          TextField(
            controller: _messageCtrl,
            maxLines: 5,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Describe your issue in detail',
              filled: true, fillColor: AppColors.bgLightCream,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.softBrown, width: 2)),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          LoadingButton(
            onPressed: () async {
              setState(() => _isSending = true);
              await Future.delayed(const Duration(seconds: 1));
              setState(() => _isSending = false);
              AppSnackbar.show(context, 'Support ticket submitted! We\'ll respond within 24 hours.');
              Navigator.pop(context);
            },
            isLoading: _isSending,
            label: 'Submit Ticket',
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Average response time: 2-4 hours', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight))),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: AppColors.softBrown, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textCharcoal)),
        ]),
      ),
    );
  }
}

// ==================== PRIVACY & TERMS SCREENS ====================
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalScreen(
    title: 'Privacy Policy',
    lastUpdated: 'January 1, 2024',
    sections: const [
      _LegalSection('Information We Collect', 'We collect information you provide directly to us (name, email, phone, address), information generated when you use our app (purchase history, browsing behavior, search history), and technical data (device ID, IP address, app version).'),
      _LegalSection('How We Use Your Information', 'We use your information to process orders and payments, provide customer support, send order confirmations and shipping updates, personalize your shopping experience with AI recommendations, and improve our products and services.'),
      _LegalSection('Data Security', 'We implement industry-standard security measures including SSL encryption, Firebase security rules, and secure API authentication. We never store payment card details on our servers.'),
      _LegalSection('Data Sharing', 'We do not sell your personal data. We may share data with delivery partners (for shipping), payment processors (for transactions), and analytics services (anonymized data only).'),
      _LegalSection('Your Rights', 'You have the right to access, correct, or delete your personal data at any time through the app Settings → Privacy Controls or by contacting support@mospl.com.'),
      _LegalSection('Cookies & Tracking', 'Our app uses local storage and Firebase Analytics to improve your experience. You can opt out of analytics tracking in Settings → Privacy Controls.'),
      _LegalSection('Children\'s Privacy', 'MOSPL is not intended for users under 13 years of age. We do not knowingly collect data from children under 13.'),
      _LegalSection('Contact Us', 'For privacy concerns, contact our Data Protection Officer at privacy@mospl.onlinemadras.com or write to: onlinemadras.com, Chennai, Tamil Nadu, India.'),
    ],
  );
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalScreen(
    title: 'Terms & Conditions',
    lastUpdated: 'January 1, 2024',
    sections: const [
      _LegalSection('Acceptance of Terms', 'By using the MOSPL app, you agree to be bound by these Terms & Conditions. If you do not agree, please do not use our services.'),
      _LegalSection('Use of Service', 'MOSPL grants you a limited, non-exclusive, non-transferable license to use the app for personal, non-commercial purposes. You may not resell, reproduce, or distribute app content.'),
      _LegalSection('Account Responsibilities', 'You are responsible for maintaining the security of your account credentials. You must notify us immediately of any unauthorized use of your account.'),
      _LegalSection('Product Information', 'We strive to display product images and descriptions accurately. Slight color variations may occur due to display settings. Product measurements are approximate.'),
      _LegalSection('Pricing & Payment', 'All prices are in Indian Rupees (₹) and inclusive of applicable taxes. We reserve the right to change prices without prior notice. Payment must be made in full at the time of order.'),
      _LegalSection('Shipping & Delivery', 'Delivery timelines are estimates and may vary due to unforeseen circumstances. MOSPL is not liable for delays caused by courier partners or force majeure events.'),
      _LegalSection('Returns & Refunds', '7-day return policy applies to unused products in original packaging. Manufacturing defects qualify for full refund. Return shipping is free for defective items.'),
      _LegalSection('Limitation of Liability', 'MOSPL\'s liability is limited to the value of the product ordered. We are not liable for indirect, incidental, or consequential damages arising from product use.'),
      _LegalSection('Governing Law', 'These terms are governed by the laws of Tamil Nadu, India. Disputes shall be subject to the exclusive jurisdiction of courts in Chennai, Tamil Nadu.'),
    ],
  );
}

class _LegalSection {
  final String title;
  final String content;
  const _LegalSection(this.title, this.content);
}

class _LegalScreen extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final List<_LegalSection> sections;

  const _LegalScreen({required this.title, required this.lastUpdated, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Last updated: $lastUpdated', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
          const SizedBox(height: 20),
          ...sections.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.title, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
              const SizedBox(height: 8),
              Text(s.content, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray, height: 1.7)),
            ]),
          )),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.warmBeige, borderRadius: BorderRadius.circular(12)),
            child: const Text('For any questions, contact us at legal@mospl.onlinemadras.com', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.softBrown, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}