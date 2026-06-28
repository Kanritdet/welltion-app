import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';

const double _shippingFee = 150;

enum _PaymentMethod { creditCard, bankTransfer }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  _PaymentMethod _payment = _PaymentMethod.creditCard;
  bool _isLoading = false;

  Future<void> _placeOrder() async {
    setState(() => _isLoading = true);
    final user = context.read<AuthProvider>().currentUser;
    final cart = context.read<CartProvider>();
    if (user == null) { setState(() => _isLoading = false); return; }

    try {
      final order = await ApiService().checkout(
        userId: user.id,
        items: cart.items.toList(),
        shippingAddress: MockData.currentUser.name,
      );
      cart.clear();
      if (mounted) {
        context.go('/order-confirmed', extra: {'orderId': order.id, 'total': order.total});
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final user = MockData.currentUser;
    final total = cart.subtotal + _shippingFee;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ────────────────────────────────────────────────
                    Row(
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
                          'ชำระเงิน',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Address Section ───────────────────────────────────────
                    const _SectionLabel('ที่อยู่จัดส่ง'),
                    const SizedBox(height: 10),
                    _AddressCard(user: user),
                    const SizedBox(height: 16),

                    // ── Payment Section ───────────────────────────────────────
                    const _SectionLabel('วิธีชำระเงิน'),
                    const SizedBox(height: 10),
                    _PaymentOption(
                      method: _PaymentMethod.creditCard,
                      label: 'บัตรเครดิต / เดบิต',
                      icon: Icons.credit_card_rounded,
                      selected: _payment,
                      onSelect: (m) => setState(() => _payment = m),
                    ),
                    const SizedBox(height: 9),
                    _PaymentOption(
                      method: _PaymentMethod.bankTransfer,
                      label: 'โอนผ่านธนาคาร',
                      icon: Icons.account_balance_rounded,
                      selected: _payment,
                      onSelect: (m) => setState(() => _payment = m),
                    ),
                    const SizedBox(height: 16),

                    // ── Summary Card ──────────────────────────────────────────
                    _SummaryCard(cart: cart, total: total),
                  ],
                ),
              ),
            ),
            _CtaBar(isLoading: _isLoading, onTap: _placeOrder),
          ],
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
    );
  }
}

// ─── Address Card ─────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_rounded, size: 21, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name as String,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                const Text(
                  '88/12 ซ.อารีย์ 4 ถ.พหลโยธิน กรุงเทพฯ 10400',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'แก้ไข',
              style: TextStyle(fontSize: 12, color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Payment Option ───────────────────────────────────────────────────────────

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.method,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelect,
  });
  final _PaymentMethod method;
  final String label;
  final IconData icon;
  final _PaymentMethod selected;
  final ValueChanged<_PaymentMethod> onSelect;

  @override
  Widget build(BuildContext context) {
    final isActive = selected == method;
    return GestureDetector(
      onTap: () => onSelect(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isActive ? AppColors.primaryDark : AppColors.border,
            width: isActive ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 21, color: AppColors.primaryDark),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              ),
            ),
            Icon(
              isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 20,
              color: isActive ? AppColors.primaryDark : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.cart, required this.total});
  final CartProvider cart;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _Row(label: 'ราคาสินค้า', value: '฿${cart.subtotal.toInt()}'),
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

// ─── CTA Bar ──────────────────────────────────────────────────────────────────

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.isLoading, required this.onTap});
  final bool isLoading;
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
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: isLoading ? AppColors.textMuted : AppColors.accentGold,
            border: Border.all(color: isLoading ? AppColors.textMuted : AppColors.accentBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text(
                    'ยืนยันคำสั่งซื้อ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accentText),
                  ),
          ),
        ),
      ),
    );
  }
}
