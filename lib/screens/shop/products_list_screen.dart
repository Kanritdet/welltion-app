import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';

// ─── Category display metadata ────────────────────────────────────────────────

class _CatMeta {
  const _CatMeta(this.label, this.description, this.color, this.icon);
  final String label;
  final String description;
  final Color color;
  final IconData icon;
}

const Map<ProductCategory, _CatMeta> _kCatMeta = {
  ProductCategory.healthDevice: _CatMeta(
    'WeLLzen',
    'เครื่องบำบัดเสียงอัจฉริยะ · เชื่อมต่อ Bluetooth · วัด HRV และ SpO₂ Real-time',
    AppColors.primaryMid,
    Icons.speaker_outlined,
  ),
  ProductCategory.singingBowl: _CatMeta(
    'ขันทิเบต',
    'เสียงสั่นสะเทือนลึก · บำบัดความเครียด · โลหะผสม 7 ชนิดจากเนปาล',
    AppColors.sky,
    Icons.circle_outlined,
  ),
  ProductCategory.instrument: _CatMeta(
    'แฮนด์แพน',
    'เสียงโลหะทุ้มกังวาน · 9–12 notes · เหมาะสำหรับ Sound Bath และ Meditation',
    AppColors.primaryDark,
    Icons.album_outlined,
  ),
  ProductCategory.rainStick: _CatMeta(
    'กระบอกฝน',
    'เสียงฝนธรรมชาติอ่อนโยน · ผ่อนคลายจิตใจ · ไม้ธรรมชาติแท้',
    Color(0xFF4BA37A),
    Icons.forest_outlined,
  ),
};

const _kCategoryOrder = [
  ProductCategory.healthDevice,
  ProductCategory.singingBowl,
  ProductCategory.instrument,
  ProductCategory.rainStick,
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key, this.filterCategory});
  final ProductCategory? filterCategory;

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addToCart(ProductModel product) {
    final variants = MockData.variantsByProduct(product.id);
    if (variants.length != 1) {
      context.push('/product/${product.id}');
      return;
    }
    final userId = context.read<AuthProvider>().currentUser?.id ?? 'u1';
    context.read<CartProvider>().addToCart(userId: userId, variantId: variants.first.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่ม ${product.name} ลงตะกร้าแล้ว'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.filterCategory != null
        ? _buildCategoryView()
        : _buildAllView();
  }

  // ─── All Products View ────────────────────────────────────────────────────

  Widget _buildAllView() {
    final all = MockData.products;
    final filtered = _query.isEmpty
        ? all
        : all.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar(context)),
            SliverToBoxAdapter(child: _buildSearchBar()),
            for (final cat in _kCategoryOrder) _buildCategorySliver(cat, filtered),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, size: 21, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'สินค้าทั้งหมด',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ]),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(children: [
          const Icon(Icons.search_outlined, size: 19, color: AppColors.textMuted),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'ค้นหาสินค้า...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _query = '');
              },
              child: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
            ),
        ]),
      ),
    );
  }

  Widget _buildCategorySliver(ProductCategory cat, List<ProductModel> products) {
    final catProducts = products.where((p) => p.category == cat).toList();
    if (catProducts.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    final meta = _kCatMeta[cat]!;
    final preview = catProducts.take(3).toList();
    final gridItems = preview.take(2).toList();
    final featured = preview.length >= 3 ? preview[2] : null;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    width: 4, height: 18,
                    decoration: BoxDecoration(color: meta.color, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 8),
                  Text(meta.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ]),
                GestureDetector(
                  onTap: () => context.push('/products/category/${cat.name}'),
                  child: Row(children: const [
                    Text('ดูทั้งหมด', style: TextStyle(fontSize: 12, color: AppColors.primaryDark)),
                    Icon(Icons.chevron_right, size: 15, color: AppColors.primaryDark),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 2-col grid (up to 2 items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ProductGridCard(
                    product: gridItems[0],
                    onTap: () => context.push('/product/${gridItems[0].id}'),
                    onAddToCart: () => _addToCart(gridItems[0]),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: gridItems.length > 1
                      ? _ProductGridCard(
                          product: gridItems[1],
                          onTap: () => context.push('/product/${gridItems[1].id}'),
                          onAddToCart: () => _addToCart(gridItems[1]),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            // Featured card (3rd item, full width)
            if (featured != null) ...[
              const SizedBox(height: 10),
              _ProductFeaturedCard(
                product: featured,
                onTap: () => context.push('/product/${featured.id}'),
                onAddToCart: () => _addToCart(featured),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Category Filter View ─────────────────────────────────────────────────

  Widget _buildCategoryView() {
    final cat = widget.filterCategory!;
    final meta = _kCatMeta[cat]!;
    final products = MockData.products.where((p) => p.category == cat).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: Column(children: [
                  // Custom app bar
                  Row(children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back, size: 21, color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        meta.label,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune_outlined, size: 21, color: AppColors.primaryDark),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  // Description banner
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bookingCardBg,
                      border: Border.all(color: AppColors.bookingCardBorder),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(13),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE8D88A), Color(0xFFC0A840)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(meta.icon, size: 20, color: const Color(0x992C1E00)),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(meta.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(meta.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.5)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            // Product grid (manual pairs — avoids fixed aspect ratio)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    for (var i = 0; i < products.length; i += 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _ProductGridCard(
                                product: products[i],
                                showSubtitle: true,
                                onTap: () => context.push('/product/${products[i].id}'),
                                onAddToCart: () => _addToCart(products[i]),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: i + 1 < products.length
                                  ? _ProductGridCard(
                                      product: products[i + 1],
                                      showSubtitle: true,
                                      onTap: () => context.push('/product/${products[i + 1].id}'),
                                      onAddToCart: () => _addToCart(products[i + 1]),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Product Grid Card ────────────────────────────────────────────────────────

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    this.showSubtitle = false,
  });

  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final bool showSubtitle;

  Color get _fallbackColor {
    switch (product.category) {
      case ProductCategory.singingBowl:  return const Color(0xFFE8D88A);
      case ProductCategory.instrument:   return const Color(0xFF1A3A5C);
      case ProductCategory.rainStick:    return const Color(0xFFC8DEB8);
      case ProductCategory.healthDevice: return const Color(0xFFC0E4F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with optional badge
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: SizedBox(
                height: 96,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: _fallbackColor,
                        child: const Center(child: Icon(Icons.spa_outlined, size: 30, color: Color(0x330E3D6E))),
                      ),
                    ),
                    if (product.badge != null)
                      Positioned(
                        top: 7, left: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.badge == 'ใหม่' ? AppColors.primaryLight : AppColors.accentGold,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            product.badge!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: product.badge == 'ใหม่' ? AppColors.primaryDark : AppColors.accentText,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              product.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (showSubtitle && product.spec != null) ...[
              const SizedBox(height: 2),
              Text(
                product.spec!,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 5),
            Text(
              '฿${product.basePrice.toInt()}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: onAddToCart,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  border: Border.all(color: AppColors.accentBorder),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text(
                  'เพิ่มลงตะกร้า',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accentText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Product Featured Card (full-width horizontal) ────────────────────────────

class _ProductFeaturedCard extends StatelessWidget {
  const _ProductFeaturedCard({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  Color get _fallbackColor {
    switch (product.category) {
      case ProductCategory.singingBowl:  return const Color(0xFFEDE0A0);
      case ProductCategory.instrument:   return const Color(0xFF14305A);
      case ProductCategory.rainStick:    return const Color(0xFFD4A870);
      case ProductCategory.healthDevice: return const Color(0xFF84C8EE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72, height: 72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: _fallbackColor,
                      child: const Icon(Icons.spa_outlined, size: 24, color: Color(0x330E3D6E)),
                    ),
                  ),
                  if (product.badge != null)
                    Positioned(
                      top: 5, left: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: product.badge == 'ใหม่' ? AppColors.primaryLight : AppColors.accentGold,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          product.badge!,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: product.badge == 'ใหม่' ? AppColors.primaryDark : AppColors.accentText,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                if (product.spec != null) ...[
                  const SizedBox(height: 3),
                  Text(product.spec!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
                const SizedBox(height: 5),
                Text('฿${product.basePrice.toInt()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Add button
          GestureDetector(
            onTap: onAddToCart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                border: Border.all(color: AppColors.accentBorder),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Text('เพิ่ม', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accentText)),
            ),
          ),
        ]),
      ),
    );
  }
}
