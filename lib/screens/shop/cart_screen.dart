import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/cart_item_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';

const double _shippingFee = 150;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) context.read<CartProvider>().loadCart(user.id);
    });
  }

  void _showDeleteConfirmSheet(BuildContext ctx, CartItemModel item) {
    final variant = MockData.variantById(item.variantId);
    final product = variant != null ? MockData.productById(variant.productId) : null;
    if (product == null) return;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _DeleteConfirmSheet(
        productName: product.name,
        thumbnail: variant!.image,
        onConfirm: () {
          Navigator.pop(sheetCtx);
          final user = ctx.read<AuthProvider>().currentUser;
          if (user != null) {
            ctx.read<CartProvider>().removeItem(cartItemId: item.id, userId: user.id);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, size: 21, color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'ตะกร้า',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Content ──────────────────────────────────────────────────
                if (cart.items.isEmpty)
                  const Expanded(child: _EmptyCart())
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Column(
                        children: [
                          // Cart items
                          ...cart.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CartItemCard(
                                  item: item,
                                  onUpdateQty: (newQty) {
                                    final user = context.read<AuthProvider>().currentUser;
                                    if (user == null) return;
                                    if (newQty <= 0) {
                                      context.read<CartProvider>().removeItem(
                                            cartItemId: item.id,
                                            userId: user.id,
                                          );
                                    } else {
                                      context.read<CartProvider>().updateQuantity(
                                            cartItemId: item.id,
                                            quantity: newQty,
                                          );
                                    }
                                  },
                                  onRemove: () => _showDeleteConfirmSheet(context, item),
                                ),
                              )),
                          const SizedBox(height: 4),

                          // Summary card
                          _SummaryCard(subtotal: cart.subtotal),
                        ],
                      ),
                    ),
                  ),

                // ── CTA ───────────────────────────────────────────────────────
                if (cart.items.isNotEmpty) _CtaBar(onTap: () => context.push('/checkout')),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.shopping_cart_outlined, size: 30, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 14),
          const Text(
            'ตะกร้าของคุณว่างเปล่า',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Item Card ───────────────────────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.onUpdateQty,
    required this.onRemove,
  });
  final CartItemModel item;
  final ValueChanged<int> onUpdateQty;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final variant = MockData.variantById(item.variantId);
    final product = variant != null ? MockData.productById(variant.productId) : null;
    if (variant == null || product == null) return const SizedBox.shrink();

    final price = (product.basePrice + (variant.priceAdjust ?? 0)) * item.quantity;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: SizedBox(
              width: 66,
              height: 66,
              child: Image.network(
                variant.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFFC0E4F5),
                  child: const Center(
                    child: Icon(Icons.spa_outlined, size: 22, color: Color(0x660E3D6E)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(Icons.delete_outline_rounded, size: 19, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  variant.colorName,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Qty pill stepper
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => onUpdateQty(item.quantity - 1),
                            child: const Icon(Icons.remove_rounded, size: 17, color: AppColors.primaryDark),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => onUpdateQty(item.quantity + 1),
                            child: const Icon(Icons.add_rounded, size: 17, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '฿${price.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.subtotal});
  final double subtotal;

  @override
  Widget build(BuildContext context) {
    final total = subtotal + _shippingFee;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _Row(label: 'ราคาสินค้า', value: '฿${subtotal.toInt()}'),
          const SizedBox(height: 10),
          _Row(label: 'ค่าจัดส่ง', value: '฿${_shippingFee.toInt()}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ยอดสุทธิ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
              Text(
                '฿${total.toInt()}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}

// ─── Delete Confirm Sheet ─────────────────────────────────────────────────────

class _DeleteConfirmSheet extends StatelessWidget {
  const _DeleteConfirmSheet({
    required this.productName,
    required this.thumbnail,
    required this.onConfirm,
  });
  final String productName;
  final String thumbnail;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.delete_outline_rounded, size: 28, color: AppColors.errorDark),
          ),
          const SizedBox(height: 14),
          const Text(
            'ลบสินค้าออกจากตะกร้า?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            productName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'ย้อนกลับ',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      border: Border.all(color: const Color(0xFFEAC9C5)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'ลบสินค้า',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.errorDark),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── CTA Bar ──────────────────────────────────────────────────────────────────

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.accentGold,
            border: Border.all(color: AppColors.accentBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'ไปชำระเงิน',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accentText),
            ),
          ),
        ),
      ),
    );
  }
}
