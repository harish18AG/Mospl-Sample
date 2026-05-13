// lib/screens/admin/admin_product_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../themes/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/dummy_data.dart';

class AdminAddProductScreen extends StatefulWidget {
  final Map<String, dynamic>? existingProduct;
  const AdminAddProductScreen({super.key, this.existingProduct});
  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _shortDescCtrl = TextEditingController();
  final _longDescCtrl = TextEditingController();
  final _originalPriceCtrl = TextEditingController();
  final _offerPriceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _brandCtrl = TextEditingController(text: 'MOSPL');

  String _selectedCategory = 'cat_bags';
  final List<String> _selectedColors = [];
  final List<String> _selectedSizes = [];
  final List<String> _imageUrls = [];
  bool _isFeatured = false;
  bool _isNewArrival = false;
  bool _isBestSeller = false;
  bool _isTrending = false;
  bool _freeDelivery = true;
  bool _isSaving = false;

  final List<String> _allColors = ['Black', 'Dark Brown', 'Tan', 'Cognac', 'Camel', 'Burgundy', 'Navy', 'Forest Green', 'Grey', 'White', 'Red'];
  final List<String> _allSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '6', '7', '8', '9', '10', '11', '28', '30', '32', '34', '36', '38', '40', '42', 'Standard', 'Small', 'Medium', 'Large', 'Cabin'];

  int get _discountPercent {
    final orig = double.tryParse(_originalPriceCtrl.text) ?? 0;
    final offer = double.tryParse(_offerPriceCtrl.text) ?? 0;
    if (orig == 0) return 0;
    return ((orig - offer) / orig * 100).round();
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      final p = widget.existingProduct!;
      _nameCtrl.text = p['name'] ?? '';
      _shortDescCtrl.text = p['shortDescription'] ?? '';
      _longDescCtrl.text = p['longDescription'] ?? '';
      _originalPriceCtrl.text = p['originalPrice']?.toString() ?? '';
      _offerPriceCtrl.text = p['offerPrice']?.toString() ?? '';
      _stockCtrl.text = p['stockCount']?.toString() ?? '';
      _skuCtrl.text = p['sku'] ?? '';
      _brandCtrl.text = p['brand'] ?? 'MOSPL';
      _selectedCategory = p['categoryId'] ?? 'cat_bags';
      _isFeatured = p['isFeatured'] ?? false;
      _isNewArrival = p['isNewArrival'] ?? false;
      _isBestSeller = p['isBestSeller'] ?? false;
      _isTrending = p['isTrending'] ?? false;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _shortDescCtrl.dispose(); _longDescCtrl.dispose();
    _originalPriceCtrl.dispose(); _offerPriceCtrl.dispose(); _stockCtrl.dispose();
    _skuCtrl.dispose(); _brandCtrl.dispose();
    super.dispose();
  }

  Future<void> _addImageUrl() async {
    final ctrl = TextEditingController();
    await showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Image URL', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700)),
      content: TextField(
        controller: ctrl,
        decoration: InputDecoration(hintText: 'https://images.unsplash.com/...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(fontFamily: 'Poppins'))),
        ElevatedButton(
          onPressed: () {
            if (ctrl.text.isNotEmpty) { setState(() => _imageUrls.add(ctrl.text.trim())); }
            Navigator.pop(context);
          },
          child: const Text('Add', style: TextStyle(fontFamily: 'Poppins')),
        ),
      ],
    ));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageUrls.isEmpty) { AppSnackbar.show(context, 'Add at least one product image', isError: true); return; }
    setState(() => _isSaving = true);

    // In production, call ProductService to save to Firestore
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    setState(() => _isSaving = false);
    if (mounted) {
      AppSnackbar.show(context, widget.existingProduct == null ? 'Product added successfully!' : 'Product updated successfully!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.matteBlack,
        foregroundColor: Colors.white,
        title: Text(widget.existingProduct == null ? 'Add Product' : 'Edit Product', style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Basic Info Section
            _sectionLabel('Basic Information'),
            CustomTextField(controller: _nameCtrl, label: 'Product Name', prefixIcon: Icons.inventory_2_outlined, validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null),
            const SizedBox(height: 14),
            CustomTextField(controller: _shortDescCtrl, label: 'Short Description', prefixIcon: Icons.short_text_rounded, validator: (v) => v == null || v.isEmpty ? 'Enter short description' : null),
            const SizedBox(height: 14),
            TextField(
              controller: _longDescCtrl,
              maxLines: 4,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
              decoration: InputDecoration(labelText: 'Long Description', filled: true, fillColor: AppColors.bgLightCream, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.softBrown, width: 2)), alignLabelWithHint: true),
            ),
            const SizedBox(height: 14),
            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: 'Category', prefixIcon: const Icon(Icons.category_outlined, size: 20, color: AppColors.textLight), filled: true, fillColor: AppColors.bgLightCream, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border))),
              items: DummyData.categories.map((c) => DropdownMenuItem(value: c['id'] as String, child: Text(c['name'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v ?? _selectedCategory),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: CustomTextField(controller: _brandCtrl, label: 'Brand', prefixIcon: Icons.branding_watermark_outlined)),
              const SizedBox(width: 14),
              Expanded(child: CustomTextField(controller: _skuCtrl, label: 'SKU', prefixIcon: Icons.qr_code_2_rounded)),
            ]),

            const SizedBox(height: 24),
            _sectionLabel('Pricing & Stock'),
            Row(children: [
              Expanded(child: CustomTextField(controller: _originalPriceCtrl, label: 'Original Price (₹)', prefixIcon: Icons.currency_rupee_rounded, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), validator: (v) => v == null || v.isEmpty ? 'Enter price' : null)),
              const SizedBox(width: 14),
              Expanded(child: CustomTextField(controller: _offerPriceCtrl, label: 'Offer Price (₹)', prefixIcon: Icons.sell_outlined, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), validator: (v) => v == null || v.isEmpty ? 'Enter offer price' : null)),
            ]),
            if (_originalPriceCtrl.text.isNotEmpty && _offerPriceCtrl.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.accentSuccess.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('Discount: $_discountPercent%', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accentSuccess)),
                ),
              ),
            const SizedBox(height: 14),
            CustomTextField(controller: _stockCtrl, label: 'Stock Quantity', prefixIcon: Icons.warehouse_outlined, keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Enter stock count' : null),

            const SizedBox(height: 24),
            _sectionLabel('Product Images'),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: [
                ..._imageUrls.asMap().entries.map((e) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(e.value, width: 90, height: 90, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 90, height: 90, color: AppColors.bgLightCream, child: const Icon(Icons.broken_image_outlined, color: AppColors.textLight))),
                    ),
                    Positioned(top: 4, right: 4, child: GestureDetector(
                      onTap: () => setState(() => _imageUrls.removeAt(e.key)),
                      child: Container(width: 22, height: 22, decoration: const BoxDecoration(color: AppColors.accentError, shape: BoxShape.circle), child: const Icon(Icons.close, size: 14, color: Colors.white)),
                    )),
                  ],
                )),
                GestureDetector(
                  onTap: _addImageUrl,
                  child: Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(color: AppColors.bgLightCream, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border, style: BorderStyle.solid)),
                    child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.add_photo_alternate_outlined, color: AppColors.softBrown, size: 28),
                      SizedBox(height: 4),
                      Text('Add URL', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.softBrown)),
                    ]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _sectionLabel('Available Colors'),
            Wrap(spacing: 8, runSpacing: 8, children: _allColors.map((color) {
              final selected = _selectedColors.contains(color);
              return GestureDetector(
                onTap: () => setState(() => selected ? _selectedColors.remove(color) : _selectedColors.add(color)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(color: selected ? AppColors.matteBlack : AppColors.bgLightCream, borderRadius: BorderRadius.circular(8), border: Border.all(color: selected ? AppColors.matteBlack : AppColors.border)),
                  child: Text(color, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: selected ? Colors.white : AppColors.textCharcoal)),
                ),
              );
            }).toList()),

            const SizedBox(height: 24),
            _sectionLabel('Available Sizes'),
            Wrap(spacing: 8, runSpacing: 8, children: _allSizes.map((size) {
              final selected = _selectedSizes.contains(size);
              return GestureDetector(
                onTap: () => setState(() => selected ? _selectedSizes.remove(size) : _selectedSizes.add(size)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(color: selected ? AppColors.softBrown : AppColors.bgLightCream, borderRadius: BorderRadius.circular(8), border: Border.all(color: selected ? AppColors.softBrown : AppColors.border)),
                  child: Text(size, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: selected ? Colors.white : AppColors.textCharcoal)),
                ),
              );
            }).toList()),

            const SizedBox(height: 24),
            _sectionLabel('Delivery Settings'),
            Row(children: [
              Switch(value: _freeDelivery, onChanged: (v) => setState(() => _freeDelivery = v), activeColor: AppColors.softBrown),
              const SizedBox(width: 8),
              const Text('Free Delivery', style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
            ]),

            const SizedBox(height: 24),
            _sectionLabel('Product Labels'),
            Wrap(spacing: 10, runSpacing: 10, children: [
              _labelChip('Featured', _isFeatured, (v) => setState(() => _isFeatured = v)),
              _labelChip('New Arrival', _isNewArrival, (v) => setState(() => _isNewArrival = v)),
              _labelChip('Best Seller', _isBestSeller, (v) => setState(() => _isBestSeller = v)),
              _labelChip('Trending', _isTrending, (v) => setState(() => _isTrending = v)),
            ]),

            const SizedBox(height: 32),
            LoadingButton(onPressed: _save, isLoading: _isSaving, label: widget.existingProduct == null ? 'Add Product' : 'Update Product'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textCharcoal)),
    );
  }

  Widget _labelChip(String label, bool isSelected, Function(bool) onTap) {
    return GestureDetector(
      onTap: () => onTap(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softBrown : AppColors.bgLightCream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.softBrown : AppColors.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (isSelected) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.check, size: 14, color: Colors.white)),
          Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textCharcoal)),
        ]),
      ),
    );
  }
}

// Import needed
// ignore: unused_import
