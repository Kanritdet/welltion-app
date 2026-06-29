import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';

class OrderErrorScreen extends StatelessWidget {
  const OrderErrorScreen({super.key, this.errorMessage});
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: EdgeInsets.fromLTRB(22, top + 28, 22, 26 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Error icon ──────────────────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_rounded, size: 42, color: AppColors.errorDark),
            ),
            const SizedBox(height: 18),

            // ── Title ────────────────────────────────────────────────────────
            const Text(
              'สั่งซื้อไม่สำเร็จ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 5),
            Text(
              errorMessage ?? 'เกิดข้อผิดพลาดในการชำระเงิน กรุณาลองใหม่อีกครั้ง',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),

            // ── Error detail card ────────────────────────────────────────────
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
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.errorLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.credit_card_off_rounded, size: 18, color: AppColors.errorDark),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'การชำระเงินล้มเหลว',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'ระบบไม่สามารถตัดเงินได้ — คำสั่งซื้อถูกยกเลิก',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
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

                  // ── Suggestions ──────────────────────────────────────────
                  const Text(
                    'สิ่งที่ควรตรวจสอบ',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  const _SuggestionRow(icon: Icons.account_balance_wallet_rounded, text: 'ยอดเงินในบัตรหรือบัญชีเพียงพอ'),
                  const SizedBox(height: 8),
                  const _SuggestionRow(icon: Icons.lock_rounded, text: 'เปิดใช้งานบัตรสำหรับชำระออนไลน์'),
                  const SizedBox(height: 8),
                  const _SuggestionRow(icon: Icons.wifi_rounded, text: 'การเชื่อมต่ออินเทอร์เน็ตเสถียร'),
                ],
              ),
            ),

            const Spacer(),

            // ── CTA: ลองใหม่ ─────────────────────────────────────────────────
            GestureDetector(
              onTap: () => context.go('/checkout'),
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
                    'ลองใหม่อีกครั้ง',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accentText),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Text link: กลับหน้าหลัก ──────────────────────────────────────
            GestureDetector(
              onTap: () => context.go('/home'),
              child: const Text(
                'กลับหน้าหลัก',
                style: TextStyle(fontSize: 13, color: AppColors.primaryDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primaryMid),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
