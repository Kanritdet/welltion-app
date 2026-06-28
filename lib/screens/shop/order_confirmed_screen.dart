import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({
    super.key,
    required this.orderId,
    required this.total,
  });
  final String orderId;
  final double total;

  String get _orderNumber {
    final now = DateTime.now();
    final seq = orderId.replaceAll(RegExp(r'[^0-9]'), '').padLeft(4, '0');
    return '#WL-${now.year}${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}-$seq';
  }

  String get _estimatedDelivery {
    final delivery = DateTime.now().add(const Duration(days: 3));
    final thYear = delivery.year + 543;
    const months = ['', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    final endDate = delivery.add(const Duration(days: 2));
    return '${delivery.day}–${endDate.day} ${months[delivery.month]} $thYear';
  }

  @override
  Widget build(BuildContext context) {
    final sampleItem = MockData.cartItems.isNotEmpty ? MockData.cartItems.first : null;
    final variant = sampleItem != null ? MockData.variantById(sampleItem.variantId) : null;
    final product = variant != null ? MockData.productById(variant.productId) : null;

    final bottom = MediaQuery.of(context).padding.bottom;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: EdgeInsets.fromLTRB(22, top + 28, 22, 26 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Success icon ─────────────────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, size: 42, color: AppColors.successDark),
            ),
            const SizedBox(height: 18),

            // ── Title ────────────────────────────────────────────────────────
            const Text(
              'สั่งซื้อสำเร็จ!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 5),
            const Text(
              'ขอบคุณสำหรับการสั่งซื้อ',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            // ── Order detail card ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('เลขที่คำสั่งซื้อ',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text(
                        _orderNumber,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    child: Divider(height: 1, color: AppColors.border),
                  ),

                  // Shipping address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_rounded, size: 15, color: AppColors.primaryDark),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          '88/12 ซ.อารีย์ 4 ถ.พหลโยธิน กรุงเทพฯ 10400',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    child: Divider(height: 1, color: AppColors.border),
                  ),

                  // Product row
                  if (product != null && variant != null)
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0E4F5),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.network(
                              variant.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.spa_outlined,
                                size: 22,
                                color: Color(0x660E3D6E),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.name} · ${variant.colorName}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${sampleItem!.quantity} ชิ้น · ฿${total.toInt()}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    child: Divider(height: 1, color: AppColors.border),
                  ),

                  // Shipping date
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_rounded, size: 16, color: AppColors.primaryDark),
                      const SizedBox(width: 8),
                      Text.rich(
                        TextSpan(
                          text: 'คาดว่าได้รับ ',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: _estimatedDelivery,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    child: Divider(height: 1, color: AppColors.border),
                  ),

                  // ── Delivery Status Stepper (inside card) ────────────────
                  const _StatusStepper(),
                ],
              ),
            ),

            const Spacer(),

            // ── CTA: กลับหน้าหลัก ────────────────────────────────────────────
            GestureDetector(
              onTap: () => context.go('/home'),
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
                    'กลับหน้าหลัก',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accentText),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Text link: ดูรายละเอียดคำสั่งซื้อ ────────────────────────────
            GestureDetector(
              onTap: () => context.go('/orders', extra: <String, dynamic>{'tab': 'orders'}),
              child: const Text(
                'ดูรายละเอียดคำสั่งซื้อ',
                style: TextStyle(fontSize: 13, color: AppColors.primaryDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Delivery Status Stepper ──────────────────────────────────────────────────

class _StatusStepper extends StatelessWidget {
  const _StatusStepper();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('ยืนยัน\nการชำระ', true,  false),
      ('กำลังแพค\nสินค้า',  false, true),
      ('กำลัง\nจัดส่ง',    false, false),
      ('จัดส่ง\nสำเร็จ',   false, false),
    ];

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final leftDone = steps[i ~/ 2].$2;
          return Expanded(
            child: Container(
              height: 2,
              color: leftDone ? AppColors.successDark : AppColors.border,
            ),
          );
        }
        final (label, isDone, isCurrent) = steps[i ~/ 2];
        return _StepNode(label: label, isDone: isDone, isCurrent: isCurrent);
      }),
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({required this.label, required this.isDone, required this.isCurrent});
  final String label;
  final bool isDone;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final Color nodeColor;
    final Color textColor;
    final Widget nodeChild;

    if (isDone) {
      nodeColor = AppColors.successDark;
      textColor = AppColors.successDark;
      nodeChild = const Icon(Icons.check_rounded, size: 12, color: Colors.white);
    } else if (isCurrent) {
      nodeColor = AppColors.primaryDark;
      textColor = AppColors.primaryDark;
      nodeChild = Container(
        width: 6, height: 6,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      );
    } else {
      nodeColor = AppColors.border;
      textColor = AppColors.textMuted;
      nodeChild = const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(color: nodeColor, shape: BoxShape.circle),
          child: Center(child: nodeChild),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: textColor, height: 1.4),
        ),
      ],
    );
  }
}
