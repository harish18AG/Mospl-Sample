// lib/screens/cart/cart_checkout_screens.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CartProvider>(
          builder: (_, cart, __) => Text('${AppStrings.cartTitle} (${cart.itemCount})'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cart, auth, _) {
          if (cart.items.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: AppStrings.cartEmpty,
              subtitle: AppStrings.cartEmptySubtitle,
              buttonLabel: 'Explore Products',
              onButtonTap: () => Navigator.pushNamed(context, AppRoutes.productListing),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (_, i) => _CartItem(
                    item: cart.items[i],
                    onRemove: () => cart.removeItem(auth.user?.id ?? '', cart.items[i].id),
                    onIncrement: () => cart.updateQuantity(auth.user?.id ?? '', cart.items[i].id, cart.items[i].quantity + 1),
                    onDecrement: () => cart.updateQuantity(auth.user?.id ?? '', cart.items[i].id, cart.items[i].quantity - 1),
                  ),
                ),
              ),
              _CartSummary(cart: cart, auth: auth),
            ],
          );
        },
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItem({required this.item, required this.onRemove, required this.onIncrement, required this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(color: AppColors.accentError, borderRadius: BorderRadius.circular(14)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80, height: 80,
                child: Image.network(item.productImage, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.bgLightCream)),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  if (item.selectedColor != null || item.selectedSize != null)
                    Text(
                      [if (item.selectedColor != null) item.selectedColor!, if (item.selectedSize != null) 'Size: ${item.selectedSize}'].join(' · '),
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.formattedTotal, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                      // Quantity controls
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(onTap: onDecrement, child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.remove, size: 16, color: AppColors.textCharcoal))),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('${item.quantity}', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700))),
                            InkWell(onTap: onIncrement, child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.add, size: 16, color: AppColors.textCharcoal))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartProvider cart;
  final AuthProvider auth;

  const _CartSummary({required this.cart, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Column(
        children: [
          // Coupon input
          _CouponInput(cart: cart),
          const SizedBox(height: 16),
          // Summary rows
          _summaryRow('Subtotal', cart.formattedSubtotal),
          const SizedBox(height: 6),
          _summaryRow('Delivery', cart.deliveryCharge == 0 ? 'FREE' : '₹${cart.deliveryCharge.toStringAsFixed(0)}',
              color: cart.deliveryCharge == 0 ? AppColors.accentSuccess : null),
          if (cart.couponDiscount > 0) ...[
            const SizedBox(height: 6),
            _summaryRow('Coupon Discount', '-₹${cart.couponDiscount.toStringAsFixed(0)}', color: AppColors.accentSuccess),
          ],
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
              Text(cart.formattedTotal, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
              child: Text(AppStrings.proceedToCheckout, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray)),
        Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: color ?? AppColors.textCharcoal)),
      ],
    );
  }
}

class _CouponInput extends StatefulWidget {
  final CartProvider cart;
  const _CouponInput({required this.cart});
  @override
  State<_CouponInput> createState() => _CouponInputState();
}

class _CouponInputState extends State<_CouponInput> {
  final _ctrl = TextEditingController();
  bool _isApplied = false;

  void _applyCoupon() {
    // Find coupon from dummy data
    final couponData = DummyData.coupons.where((c) => c['code'] == _ctrl.text.trim().toUpperCase()).firstOrNull;
    if (couponData == null) {
      AppSnackbar.show(context, 'Invalid coupon code', isError: true);
      return;
    }
    // Create CouponModel from dummy data
    final coupon = CouponModel(
      id: couponData['id'],
      code: couponData['code'],
      title: couponData['title'],
      description: couponData['description'],
      discountType: couponData['discountType'],
      discountValue: couponData['discountValue'].toDouble(),
      minOrderValue: couponData['minOrderValue'].toDouble(),
      maxDiscount: couponData['maxDiscount'].toDouble(),
      usageLimit: couponData['usageLimit'],
      usedCount: couponData['usedCount'],
      expiryDate: DateTime.parse(couponData['expiryDate']),
      isActive: couponData['isActive'],
      applicableCategories: List<String>.from(couponData['applicableCategories']),
    );

    if (!coupon.isValid) {
      AppSnackbar.show(context, 'Coupon has expired or reached usage limit', isError: true);
      return;
    }
    if (widget.cart.subtotal < coupon.minOrderValue) {
      AppSnackbar.show(context, 'Add ₹${(coupon.minOrderValue - widget.cart.subtotal).toStringAsFixed(0)} more to use this coupon', isError: true);
      return;
    }
    widget.cart.applyCoupon(coupon);
    setState(() => _isApplied = true);
    AppSnackbar.show(context, 'Coupon applied! You saved ₹${coupon.calculateDiscount(widget.cart.subtotal).toStringAsFixed(0)}');
  }

  @override
  Widget build(BuildContext context) {
    if (_isApplied && widget.cart.appliedCoupon != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: AppColors.accentSuccess.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.accentSuccess.withOpacity(0.3))),
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined, color: AppColors.accentSuccess, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('${widget.cart.appliedCoupon} applied', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accentSuccess))),
            GestureDetector(
              onTap: () { widget.cart.removeCoupon(); setState(() => _isApplied = false); _ctrl.clear(); },
              child: const Icon(Icons.close, size: 18, color: AppColors.accentError),
            ),
          ],
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter coupon code',
              hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textLight),
              prefixIcon: const Icon(Icons.local_offer_outlined, size: 18, color: AppColors.textLight),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.softBrown, width: 2)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _applyCoupon,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

// ==================== CHECKOUT SCREEN ====================
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;
  Map<String, dynamic>? _selectedAddress;
  String _paymentMethod = 'upi';
  String _deliveryType = 'standard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // Step indicator
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: [
                _buildAddressStep(),
                _buildDeliveryStep(),
                _buildPaymentStep(),
                _buildReviewStep(),
              ][_step],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Address', 'Delivery', 'Payment', 'Review'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == _step;
          final isDone = i < _step;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: isDone ? AppColors.accentSuccess : (isActive ? AppColors.softBrown : AppColors.bgLightCream),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text('${i + 1}', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: isActive ? Colors.white : AppColors.textLight)),
                  ),
                ),
                const SizedBox(width: 4),
                Text(steps[i], style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: isActive ? FontWeight.w700 : FontWeight.w400, color: isActive ? AppColors.textCharcoal : AppColors.textLight)),
                if (i < steps.length - 1) const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddressStep() {
    final auth = context.read<AuthProvider>();
    final addresses = auth.user?.addresses ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Delivery Address', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (addresses.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.bgLightCream, borderRadius: BorderRadius.circular(12)),
            child: const Text('No saved addresses. Add a new address below.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray)),
          ),
        ...addresses.map((addr) => _AddressTile(
          address: addr,
          isSelected: _selectedAddress == addr,
          onTap: () => setState(() => _selectedAddress = addr),
        )),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.addAddress),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add New Address'),
        ),
      ],
    );
  }

  Widget _buildDeliveryStep() {
    final cart = context.read<CartProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Delivery Option', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _DeliveryOption(
          icon: Icons.local_shipping_outlined,
          title: 'Standard Delivery',
          subtitle: 'Delivered in 5-7 business days',
          price: cart.subtotal >= AppConstants.freeShippingThreshold ? 'FREE' : '₹99',
          isSelected: _deliveryType == 'standard',
          onTap: () => setState(() => _deliveryType = 'standard'),
        ),
        const SizedBox(height: 12),
        _DeliveryOption(
          icon: Icons.flash_on_rounded,
          title: 'Express Delivery',
          subtitle: 'Delivered in 1-2 business days',
          price: '₹199',
          isSelected: _deliveryType == 'express',
          onTap: () => setState(() => _deliveryType = 'express'),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    final methods = [
      {'id': 'upi', 'icon': Icons.phone_android_rounded, 'title': 'UPI Payment', 'sub': 'Pay via UPI apps'},
      {'id': 'card', 'icon': Icons.credit_card_rounded, 'title': 'Credit/Debit Card', 'sub': 'All major cards accepted'},
      {'id': 'netbanking', 'icon': Icons.account_balance_rounded, 'title': 'Net Banking', 'sub': 'All major banks'},
      {'id': 'cod', 'icon': Icons.money_rounded, 'title': 'Cash on Delivery', 'sub': 'Pay when delivered'},
      {'id': 'wallet', 'icon': Icons.wallet_rounded, 'title': 'MOSPL Wallet', 'sub': 'Balance: ₹0'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...methods.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => _paymentMethod = m['id'] as String),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _paymentMethod == m['id'] ? AppColors.softBrown : AppColors.border, width: _paymentMethod == m['id'] ? 2 : 1),
              ),
              child: Row(
                children: [
                  Icon(m['icon'] as IconData, color: _paymentMethod == m['id'] ? AppColors.softBrown : AppColors.textLight, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['title'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                        Text(m['sub'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  Radio<String>(value: m['id'] as String, groupValue: _paymentMethod, onChanged: (v) => setState(() => _paymentMethod = v!), activeColor: AppColors.softBrown),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildReviewStep() {
    final cart = context.watch<CartProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Review', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        // Items
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(
            children: [
              ...cart.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(width: 50, height: 50, child: Image.network(item.productImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.bgLightCream)))),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.productName, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('Qty: ${item.quantity}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                    ])),
                    Text(item.formattedTotal, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Summary
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(
            children: [
              _reviewRow('Subtotal', cart.formattedSubtotal),
              _reviewRow('Delivery', cart.deliveryCharge == 0 ? 'FREE' : '₹${cart.deliveryCharge.toStringAsFixed(0)}'),
              if (cart.couponDiscount > 0) _reviewRow('Discount', '-₹${cart.couponDiscount.toStringAsFixed(0)}', color: AppColors.accentSuccess),
              const Divider(),
              _reviewRow('Total', cart.formattedTotal, isBold: true),
              _reviewRow('Payment', _paymentMethod.toUpperCase()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.textDarkGray, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
          Text(value, style: TextStyle(fontFamily: isBold ? 'Montserrat' : 'Poppins', fontSize: isBold ? 16 : 14, fontWeight: FontWeight.w700, color: color ?? AppColors.textCharcoal)),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: _step < 3 ? () => setState(() => _step++) : _placeOrder,
            child: Text(_step < 3 ? 'Continue' : 'Place Order', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final orders = context.read<OrderProvider>();

    if (_selectedAddress == null) {
      AppSnackbar.show(context, 'Please select a delivery address', isError: true);
      setState(() => _step = 0);
      return;
    }

    final order = await orders.placeOrder(
      userId: auth.user!.id,
      userName: auth.user!.name,
      cartItems: cart.items,
      shippingAddress: _selectedAddress!,
      paymentMethod: _paymentMethod,
      subtotal: cart.subtotal,
      deliveryCharge: _deliveryType == 'express' ? 199 : cart.deliveryCharge,
      discount: cart.couponDiscount,
      total: cart.total,
      couponCode: cart.appliedCoupon,
    );

    if (order != null && mounted) {
      await cart.clearCart(auth.user!.id);
      Navigator.pushReplacementNamed(context, AppRoutes.orderConfirmation, arguments: order);
    }
  }
}

class _AddressTile extends StatelessWidget {
  final Map<String, dynamic> address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTile({required this.address, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.softBrown : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(address['type'] == 'home' ? Icons.home_outlined : Icons.work_outline, color: AppColors.softBrown),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${address['name']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('${address['line1']}, ${address['city']}, ${address['state']} - ${address['pincode']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray)),
                  Text('${address['phone']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.softBrown, size: 22),
          ],
        ),
      ),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryOption({required this.icon, required this.title, required this.subtitle, required this.price, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.softBrown : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.softBrown, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
                  Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            Text(price, style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w700, color: price == 'FREE' ? AppColors.accentSuccess : AppColors.textCharcoal)),
            Radio<bool>(value: true, groupValue: isSelected, onChanged: (_) => onTap(), activeColor: AppColors.softBrown),
          ],
        ),
      ),
    );
  }
}

// ==================== ORDER CONFIRMATION ====================
class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;
  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success animation
                Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(color: AppColors.accentSuccess.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, size: 70, color: AppColors.accentSuccess),
                ),
                const SizedBox(height: 24),
                const Text('Order Placed!', style: TextStyle(fontFamily: 'Montserrat', fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
                const SizedBox(height: 8),
                Text(AppStrings.orderSuccess, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 28),
                // Order info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _infoRow('Order ID', order.id),
                      const SizedBox(height: 8),
                      _infoRow('Total Amount', '₹${order.total.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      _infoRow('Payment', order.paymentMethod.toUpperCase()),
                      const SizedBox(height: 8),
                      _infoRow('Est. Delivery', _formatDate(order.estimatedDelivery)),
                      const SizedBox(height: 8),
                      _infoRow('Tracking ID', order.trackingId ?? 'N/A'),
                      const SizedBox(height: 8),
                      _infoRow('Reward Points', '+${order.rewardPointsEarned} pts', color: AppColors.softGold),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false),
                    child: const Text('Continue Shopping'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.orderHistory),
                    child: const Text('Track My Order'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textDarkGray)),
        Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: color ?? AppColors.textCharcoal)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}