import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/notification_model.dart';

enum _ScheduleStatus { pending, confirmed }

class PartnerDashboardScreen extends StatefulWidget {
  const PartnerDashboardScreen({super.key});

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'n1',
      type: NotifType.booking,
      title: 'การจองใหม่ รอยืนยัน',
      body: 'สมศรี ดีมาก จองและรอยืนยัน WeLLzen #2',
      timestamp: 'เมื่อกี้ · 5 นาที',
    ),
    NotificationModel(
      id: 'n2',
      type: NotifType.payment,
      title: 'ชำระเงินสำเร็จ',
      body: 'วีระ สุขสันต์ · WeLLzen session ฿100',
      timestamp: 'วันนี้ · 13:00',
    ),
    NotificationModel(
      id: 'n3',
      type: NotifType.cancellation,
      title: 'ลูกค้ายกเลิกการจอง',
      body: 'ธนา ก้องเกียรติ ยกเลิก WeLLzen #3',
      timestamp: 'วันนี้ · 11:30',
    ),
    NotificationModel(
      id: 'n4',
      type: NotifType.booking,
      title: 'การจองสำเร็จ',
      body: 'นิดา สุขใจ จองและยืนยัน WeLLzen #2 แล้ว',
      timestamp: 'เมื่อวาน · 16:00',
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _showNotificationPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => _NotificationPanel(
          notifications: _notifications,
          onMarkAllRead: () {
            setSheetState(() {
              for (final n in _notifications) {
                n.isRead = true;
              }
            });
            setState(() {});
          },
        ),
      ),
    );
  }

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
    final unread = _unreadCount;
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
        GestureDetector(
          onTap: _showNotificationPanel,
          child: Stack(
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.notifications, size: 20, color: AppColors.primaryDark),
              ),
              if (unread > 0)
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    width: 9, height: 9,
                    decoration: const BoxDecoration(color: Color(0xFFE05A45), shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
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
    final accentColor = status == _ScheduleStatus.pending ? AppColors.accentGold : AppColors.successDark;
    final (badgeLabel, badgeTextColor, badgeBg) = status == _ScheduleStatus.pending
        ? ('รอยืนยัน', AppColors.accentText, AppColors.accentGold)
        : ('ยืนยันแล้ว', AppColors.successDark, AppColors.successLight);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(time, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const Text('วันนี้', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 1, color: AppColors.border),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(detail, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(999)),
                      child: Text(badgeLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: badgeTextColor)),
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

// ─── Notification Panel ───────────────────────────────────────────────────────

class _NotificationPanel extends StatelessWidget {
  const _NotificationPanel({
    required this.notifications,
    required this.onMarkAllRead,
  });
  final List<NotificationModel> notifications;
  final VoidCallback onMarkAllRead;

  static const _kUnreadBg = Color(0xFFEEF6FC);
  static const _kDivider  = Color(0xFFEAF3F8);
  static const _kDot      = Color(0xFFE05A45);

  (Color bg, Color iconBg, Color iconFg) _colors(NotifType type) {
    switch (type) {
      case NotifType.booking:
        return (AppColors.primaryDark, AppColors.primaryDark, AppColors.accentGold);
      case NotifType.payment:
        return (AppColors.successLight, AppColors.successLight, AppColors.successDark);
      case NotifType.cancellation:
        return (AppColors.errorLight, AppColors.errorLight, AppColors.errorDark);
      case NotifType.system:
        return (AppColors.primaryLight, AppColors.primaryLight, AppColors.sky);
    }
  }

  IconData _icon(NotifType type) {
    switch (type) {
      case NotifType.booking:   return Icons.event_available;
      case NotifType.payment:   return Icons.payments;
      case NotifType.cancellation: return Icons.event_busy;
      case NotifType.system:    return Icons.event_available;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final unread = notifications.where((n) => !n.isRead).length;
    final isEmpty = unread == 0 && notifications.every((n) => n.isRead);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 14, 14),
            child: Row(
              children: [
                const Text(
                  'การแจ้งเตือน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 10),
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(999)),
                    child: Text(
                      '$unread ใหม่',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.errorDark),
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.close, size: 19, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: _kDivider),

          // Notification list
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 340),
            child: isEmpty
                ? _EmptyNotif()
                : SingleChildScrollView(
                    child: Column(
                      children: notifications.map((n) {
                        final (_, iconBg, iconFg) = _colors(n.type);
                        return Column(
                          children: [
                            Container(
                              color: n.isRead ? AppColors.surface : _kUnreadBg,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                                    child: Icon(_icon(n.type), size: 20, color: iconFg),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                n.title,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: n.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            if (!n.isRead) ...[
                                              const SizedBox(width: 7),
                                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: _kDot, shape: BoxShape.circle)),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          n.body,
                                          style: TextStyle(fontSize: 12, color: n.isRead ? AppColors.textMuted : const Color(0xFF444444), height: 1.5),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          n.timestamp,
                                          style: TextStyle(fontSize: 11, color: n.isRead ? const Color(0xFFC8D8E0) : AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: _kDivider),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),

          // Clear button
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: GestureDetector(
              onTap: isEmpty ? null : onMarkAllRead,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isEmpty ? const Color(0xFFF5F7F8) : Colors.white,
                  border: Border.all(color: isEmpty ? const Color(0xFFE0E8EC) : const Color(0xFFEAC9C5)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: isEmpty ? 18 : 22,
                      color: isEmpty ? const Color(0xFFC8D8E0) : AppColors.errorDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'เคลียแจ้งเตือน',
                      style: TextStyle(
                        fontSize: isEmpty ? 14 : 15,
                        fontWeight: FontWeight.w700,
                        color: isEmpty ? const Color(0xFFC8D8E0) : AppColors.errorDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.notifications_off, size: 34, color: AppColors.border),
          ),
          const SizedBox(height: 14),
          const Text(
            'ไม่มีการแจ้งเตือน',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF444444)),
          ),
          const SizedBox(height: 6),
          const SizedBox(
            width: 220,
            child: Text(
              'เคลียแจ้งเตือนทั้งหมดแล้ว · จะแจ้งเตือนเมื่อมีการจองใหม่',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
