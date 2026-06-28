import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildSwitchUserBanner(context),
              const SizedBox(height: 16),
              _buildRevenueCard(),
              const SizedBox(height: 14),
              _buildStatRow(),
              const SizedBox(height: 18),
              const Text('เมนูลัด', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              _buildShortcutRow(context),
              const SizedBox(height: 18),
              const Text('ตารางงานวันนี้', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              _buildScheduleItem('14:00', 'สมศรี ดีมาก', '45 นาที · WeLLzen #2', _ScheduleStatus.pending),
              const SizedBox(height: 10),
              _buildScheduleItem('16:00', 'วีระ สุขสันต์', '60 นาที · WeLLzen #1', _ScheduleStatus.confirmed),
              const SizedBox(height: 10),
              _buildScheduleItem('18:30', 'ธนา ก้องเกียรติ', '30 นาที · WeLLzen #3', _ScheduleStatus.confirmed),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.accentGold,
            border: Border.all(color: AppColors.accentBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.storefront, size: 20, color: AppColors.accentText),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('พาร์ทเนอร์', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, letterSpacing: 0.5)),
              Text('Mindful Haven อารีย์', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.notifications, size: 20, color: AppColors.primaryDark),
            ),
            Positioned(
              top: 9, right: 9,
              child: Container(
                width: 7, height: 7,
                decoration: const BoxDecoration(color: AppColors.accentGold, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchUserBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: const Row(
          children: [
            Icon(Icons.arrow_back, size: 18, color: AppColors.primaryDark),
            SizedBox(width: 9),
            Text('สลับกลับโหมดผู้ใช้', style: TextStyle(fontSize: 13, color: AppColors.primaryDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payments, size: 16, color: AppColors.accentGold),
              SizedBox(width: 6),
              Text('ยอดรายได้เดือนนี้', style: TextStyle(fontSize: 12, color: Color(0xFFA9C7E0))),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('฿127,500', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.accentGold)),
              SizedBox(width: 6),
              Text('บาท', style: TextStyle(fontSize: 13, color: Color(0xFFA9C7E0))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet, size: 17, color: AppColors.accentText),
                      SizedBox(width: 7),
                      Text('ถอนเงิน', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accentText)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long, size: 18, color: AppColors.accentGold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('รอยืนยัน', '3', 'รายการ', showBadge: true)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('ยืนยันแล้ว', '12', 'งาน', isConfirmed: true)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit, {bool showBadge = false, bool isConfirmed = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isConfirmed)
                const Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Color(0xFF3B6D11)),
                    SizedBox(width: 6),
                    Text('ยืนยันแล้ว', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                )
              else
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              if (showBadge)
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  height: 20,
                  decoration: BoxDecoration(color: AppColors.accentGold, borderRadius: BorderRadius.circular(999)),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accentText)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(unit, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildShortcutRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildShortcutCard(context, Icons.event_available, 'จัดการจอง', 'รอยืนยัน 3', '/partner/bookings')),
        const SizedBox(width: 10),
        Expanded(child: _buildShortcutCard(context, Icons.spa, 'จัดการเครื่อง', 'WeLLzen 3 ตัว', '/partner/machines')),
        const SizedBox(width: 10),
        Expanded(child: _buildShortcutCard(context, Icons.bar_chart, 'รายงาน', 'เดือนนี้', null)),
      ],
    );
  }

  Widget _buildShortcutCard(BuildContext context, IconData icon, String label, String sub, String? route) {
    return GestureDetector(
      onTap: route != null ? () => context.push(route) : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        child: Column(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 21, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String time, String name, String detail, _ScheduleStatus status) {
    final borderColor = status == _ScheduleStatus.pending ? AppColors.accentGold : const Color(0xFF3B6D11);
    final badgeConfig = status == _ScheduleStatus.pending
        ? ('รอยืนยัน', AppColors.accentText, AppColors.accentGold)
        : ('ยืนยันแล้ว', const Color(0xFF3B6D11), const Color(0xFFEAF3DE));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
          left: BorderSide(color: borderColor, width: 3),
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 52,
            padding: const EdgeInsets.only(right: 11),
            decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.border))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(time, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const Text('วันนี้', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(detail, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: badgeConfig.$3, borderRadius: BorderRadius.circular(999)),
            child: Text(badgeConfig.$1, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: badgeConfig.$2)),
          ),
        ],
      ),
    );
  }
}

enum _ScheduleStatus { pending, confirmed }
