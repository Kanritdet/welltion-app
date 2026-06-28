import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/product_model.dart';
import '../../models/product_variant_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductVariantModel _selectedVariant;

  @override
  void initState() {
    super.initState();
    final variants = MockData.variantsByProduct(widget.productId);
    _selectedVariant = variants.isNotEmpty ? variants.first : const ProductVariantModel(
      id: '', productId: '', materialName: '', colorName: '', image: '', sku: '',
    );
  }

  double get _price {
    final product = MockData.productById(widget.productId);
    if (product == null) return 0;
    return product.basePrice + (_selectedVariant.priceAdjust ?? 0);
  }

  Future<void> _addToCart() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    await context.read<CartProvider>().addToCart(
      userId: user.id,
      variantId: _selectedVariant.id,
      quantity: 1,
    );
    if (mounted) context.push('/cart');
  }

  void _connect() => context.push('/connect', extra: {'mode': 'ownDevice'});

  @override
  Widget build(BuildContext context) {
    final product = MockData.productById(widget.productId);
    if (product == null) {
      return const Scaffold(body: Center(child: Text('ไม่พบสินค้า')));
    }
    final variants = MockData.variantsByProduct(widget.productId);
    final cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header row ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavBtn(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => context.pop(),
                        ),
                        _CartBtn(count: cartCount, onTap: () => context.push('/cart')),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Product Image ────────────────────────────────────────
                    _ProductImage(
                      image: _selectedVariant.image.isNotEmpty
                          ? _selectedVariant.image
                          : product.thumbnail,
                      variantCount: variants.length,
                      selectedIndex: variants.indexOf(_selectedVariant),
                    ),
                    const SizedBox(height: 16),

                    // ── Name + Price ─────────────────────────────────────────
                    _ProductInfo(product: product, price: _price),
                    const SizedBox(height: 16),

                    // ── Variant Picker ───────────────────────────────────────
                    if (variants.length > 1) ...[
                      _VariantPicker(
                        variants: variants,
                        selected: _selectedVariant,
                        onSelect: (v) => setState(() => _selectedVariant = v),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Description ──────────────────────────────────────────
                    _DescriptionSection(product: product),
                  ],
                ),
              ),
            ),
            _CtaBar(onAddToCart: _addToCart, onConnect: _connect),
          ],
        ),
      ),
    );
  }
}

// ─── Nav Button (back / cart) ─────────────────────────────────────────────────

class _NavBtn extends StatelessWidget {
  const _NavBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 21, color: AppColors.primaryDark),
      ),
    );
  }
}

class _CartBtn extends StatelessWidget {
  const _CartBtn({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_cart_outlined, size: 21, color: AppColors.primaryDark),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentText,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Product Image ─────────────────────────────────────────────────────────────

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.image,
    required this.variantCount,
    required this.selectedIndex,
  });
  final String image;
  final int variantCount;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFC0E4F5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          image.isNotEmpty
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _placeholder(),
                )
              : _placeholder(),
          if (variantCount > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(variantCount, (i) {
                  final isActive = i == selectedIndex;
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.accentGold
                          : const Color(0x4D0E3D6E),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() => const Center(
        child: Icon(Icons.spa_outlined, size: 40, color: Color(0x4D0E3D6E)),
      );
}

// ─── Product Info (category tag + name + price) ───────────────────────────────

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product, required this.price});
  final ProductModel product;
  final double price;

  static String _categoryLabel(ProductCategory c) {
    switch (c) {
      case ProductCategory.singingBowl: return 'ขันทิเบต';
      case ProductCategory.instrument: return 'แฮนด์แพน';
      case ProductCategory.healthDevice: return 'เครื่องสุขภาพ';
      case ProductCategory.rainStick: return 'กระบอกฝน';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            _categoryLabel(product.category),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.warningDark,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '฿${price.toInt()}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Variant Picker ───────────────────────────────────────────────────────────

class _VariantPicker extends StatelessWidget {
  const _VariantPicker({
    required this.variants,
    required this.selected,
    required this.onSelect,
  });
  final List<ProductVariantModel> variants;
  final ProductVariantModel selected;
  final ValueChanged<ProductVariantModel> onSelect;

  static Color? _swatchFor(String colorName) {
    const map = <String, Color>{
      'Arctic Silver': Color(0xFFBDCDD8),
      'Space Gray':    Color(0xFF5F6B78),
      'Frosted White': Color(0xFFEEEEEE),
      'Bronze':        Color(0xFF7C5224),
      'Gold':          Color(0xFFD4AF37),
      'Black':         Color(0xFF2A2A2A),
    };
    return map[colorName];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลือกวัสดุ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: variants.map((v) {
            final isActive = v.id == selected.id;
            final swatch = _swatchFor(v.colorName);
            return GestureDetector(
              onTap: () => onSelect(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accentGold : Colors.white,
                  border: Border.all(
                    color: isActive ? AppColors.accentBorder : AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (swatch != null) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: swatch,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12, width: 0.5),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      v.colorName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                        color: isActive ? AppColors.accentText : const Color(0xFF444444),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Description ──────────────────────────────────────────────────────────────

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.product});
  final ProductModel product;

  static const _features = <String, List<Map<String, dynamic>>>{
    'p1': [
      {'icon': Icons.graphic_eq_rounded, 'text': 'เสียงบำบัด 7 ความถี่ปรับอัตโนมัติ'},
      {'icon': Icons.bluetooth_rounded, 'text': 'เชื่อมต่อไร้สายกับแอป weLLtion'},
      {'icon': Icons.verified_user_rounded, 'text': 'รับประกัน 2 ปี'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final features = _features[product.id];
    if (features != null) {
      return Column(
        children: features
            .map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Icon(f['icon'] as IconData, size: 18, color: AppColors.primaryDark),
                      const SizedBox(width: 9),
                      Text(
                        f['text'] as String,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
    }
    return Text(
      product.description,
      style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.7),
    );
  }
}

// ─── Dashed Border Painter ────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.sky
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dash = 6.0;
    const gap = 4.0;

    final rect = Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10.0));
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final end = math.min(d + dash, metric.length);
        canvas.drawPath(metric.extractPath(d, end), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter _) => false;
}

// ─── CTA Bottom Bar (2 buttons) ───────────────────────────────────────────────

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.onAddToCart, required this.onConnect});
  final VoidCallback onAddToCart;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onAddToCart,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  border: Border.all(color: AppColors.accentBorder),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart_rounded, size: 19, color: AppColors.accentText),
                    SizedBox(width: 7),
                    Text(
                      'เพิ่มลงตะกร้า',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onConnect,
              child: CustomPaint(
                painter: _DashedBorderPainter(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner_outlined, size: 19, color: AppColors.primaryDark),
                      SizedBox(width: 7),
                      Text(
                        'เชื่อมต่อ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
