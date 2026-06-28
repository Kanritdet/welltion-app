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

  String _recipientName = MockData.currentUser.name;
  String _phone = '081-234-5678';
  String _addressLine = '88/12 ซ.อารีย์ 4 ถ.พหลโยธิน';
  String _district = 'สามเสนใน เขตพญาไท';
  String _province = 'กรุงเทพฯ';
  String _postalCode = '10400';

  void _showEditAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditAddressSheet(
        recipientName: _recipientName,
        phone: _phone,
        addressLine: _addressLine,
        district: _district,
        province: _province,
        postalCode: _postalCode,
        onSave: (name, phone, addr, dist, prov, postal) {
          setState(() {
            _recipientName = name;
            _phone = phone;
            _addressLine = addr;
            _district = dist;
            _province = prov;
            _postalCode = postal;
          });
        },
      ),
    );
  }

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
                    _AddressCard(
                      recipientName: _recipientName,
                      phone: _phone,
                      addressLine: _addressLine,
                      district: _district,
                      province: _province,
                      postalCode: _postalCode,
                      onEdit: _showEditAddressSheet,
                    ),
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
  const _AddressCard({
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.district,
    required this.province,
    required this.postalCode,
    required this.onEdit,
  });
  final String recipientName;
  final String phone;
  final String addressLine;
  final String district;
  final String province;
  final String postalCode;
  final VoidCallback onEdit;

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
                  '$recipientName · $phone',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  '$addressLine $district $province $postalCode',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onEdit,
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

// ─── Edit Address Sheet ───────────────────────────────────────────────────────

class _EditAddressSheet extends StatefulWidget {
  const _EditAddressSheet({
    required this.recipientName,
    required this.phone,
    required this.addressLine,
    required this.district,
    required this.province,
    required this.postalCode,
    required this.onSave,
  });
  final String recipientName;
  final String phone;
  final String addressLine;
  final String district;
  final String province;
  final String postalCode;
  final void Function(String, String, String, String, String, String) onSave;

  @override
  State<_EditAddressSheet> createState() => _EditAddressSheetState();
}

class _EditAddressSheetState extends State<_EditAddressSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addrCtrl;
  late final TextEditingController _districtCtrl;
  late final TextEditingController _provinceCtrl;
  late final TextEditingController _postalCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.recipientName);
    _phoneCtrl    = TextEditingController(text: widget.phone);
    _addrCtrl     = TextEditingController(text: widget.addressLine);
    _districtCtrl = TextEditingController(text: widget.district);
    _provinceCtrl = TextEditingController(text: widget.province);
    _postalCtrl   = TextEditingController(text: widget.postalCode);
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose(); _addrCtrl.dispose();
    _districtCtrl.dispose(); _provinceCtrl.dispose(); _postalCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryMid)),
      );

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const Text(
              'แก้ไขที่อยู่จัดส่ง',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 14),
            TextField(controller: _nameCtrl, style: const TextStyle(fontSize: 13), decoration: _dec('ชื่อผู้รับ')),
            const SizedBox(height: 10),
            TextField(controller: _phoneCtrl, style: const TextStyle(fontSize: 13), keyboardType: TextInputType.phone, decoration: _dec('เบอร์โทร')),
            const SizedBox(height: 10),
            TextField(controller: _addrCtrl, style: const TextStyle(fontSize: 13), decoration: _dec('ที่อยู่')),
            const SizedBox(height: 10),
            TextField(controller: _districtCtrl, style: const TextStyle(fontSize: 13), decoration: _dec('แขวง / เขต')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _provinceCtrl, style: const TextStyle(fontSize: 13), decoration: _dec('จังหวัด'))),
                const SizedBox(width: 10),
                SizedBox(width: 110, child: TextField(controller: _postalCtrl, style: const TextStyle(fontSize: 13), keyboardType: TextInputType.number, decoration: _dec('รหัสไปรษณีย์'))),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                widget.onSave(
                  _nameCtrl.text.trim(),
                  _phoneCtrl.text.trim(),
                  _addrCtrl.text.trim(),
                  _districtCtrl.text.trim(),
                  _provinceCtrl.text.trim(),
                  _postalCtrl.text.trim(),
                );
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  border: Border.all(color: AppColors.accentBorder),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'บันทึก',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accentText),
                  ),
                ),
              ),
            ),
          ],
        ),
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
