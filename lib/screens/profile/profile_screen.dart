import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.currentUser;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final deviceCount =
            MockData.devices.where((d) => d.ownerUserId == user.id).length;
        final bookingCount = MockData.bookingsByUser(user.id).length;
        final orderCount = MockData.orders.length;

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 28),
                  _buildAvatar(user.name, user.email),
                  const SizedBox(height: 24),
                  _buildStats(deviceCount, bookingCount, orderCount),
                  const SizedBox(height: 20),
                  _buildPartnerBanner(context),
                  const SizedBox(height: 20),
                  _buildSingleCard(
                    icon: Icons.shopping_bag_outlined,
                    label: 'คำสั่งซื้อของฉัน',
                    onTap: () => context.push('/orders'),
                  ),
                  const SizedBox(height: 8),
                  _buildGroupedMenu(context, deviceCount),
                  const SizedBox(height: 20),
                  _buildLogout(context, auth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
            child: const Icon(
              Icons.arrow_back,
              size: 21,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'โปรไฟล์',
          style: GoogleFonts.ibmPlexSansThai(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String name, String email) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xFFC0E4F5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x24142B44),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Color(0x660E3D6E),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 14,
                  color: AppColors.accentText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: GoogleFonts.ibmPlexSansThai(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: GoogleFonts.ibmPlexSansThai(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStats(int deviceCount, int bookingCount, int orderCount) {
    return Row(
      children: [
        _StatCard(value: '$deviceCount', label: 'อุปกรณ์'),
        const SizedBox(width: 12),
        _StatCard(value: '$bookingCount', label: 'การจอง'),
        const SizedBox(width: 12),
        _StatCard(value: '$orderCount', label: 'คำสั่งซื้อ'),
      ],
    );
  }

  Widget _buildPartnerBanner(BuildContext context) {
    const labelStyle = TextStyle(fontSize: 10, color: Color(0xFFA9C7E0));
    return GestureDetector(
      onTap: () => context.push('/partner'),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [Color(0xFF0A2A4A), AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x380E3D6E),
              blurRadius: 26,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0x26F0E4A2),
                    border: Border.all(
                      color: const Color(0x66F0E4A2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    size: 22,
                    color: AppColors.accentGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'คุณเป็นผู้ให้บริการ?',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 11,
                          color: const Color(0xFFA9C7E0),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'สลับไปโหมดพาร์ทเนอร์',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: AppColors.accentGold,
                ),
              ],
            ),
            const SizedBox(height: 11),
            const Divider(
              height: 1,
              color: Color(0x1FFFFFFF),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '32',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Text('การจอง', style: labelStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '฿118K',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentGold,
                        ),
                      ),
                      const Text('รายได้', style: labelStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '4.8',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Text('เรตติ้ง', style: labelStyle),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _MenuRow(icon: icon, label: label),
      ),
    );
  }

  Widget _buildGroupedMenu(BuildContext context, int deviceCount) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _MenuRow(
            icon: Icons.devices_outlined,
            label: 'จัดการอุปกรณ์',
            subtitle: '$deviceCount อุปกรณ์ที่เชื่อมต่อ',
            onTap: () => context.push('/device-settings'),
            showDivider: true,
          ),
          _MenuRow(
            icon: Icons.tune,
            label: 'ตั้งค่า',
            onTap: () {},
            showDivider: true,
          ),
          _MenuRow(
            icon: Icons.notifications_outlined,
            label: 'การแจ้งเตือน',
            onTap: () {},
            showDivider: true,
          ),
          _MenuRow(
            icon: Icons.info_outline,
            label: 'เกี่ยวกับแอป',
            onTap: () {},
            showDivider: true,
          ),
          _MenuRow(
            icon: Icons.description_outlined,
            label: 'เงื่อนไขการให้บริการ',
            onTap: () {},
            showDivider: true,
          ),
          _MenuRow(
            icon: Icons.lock_outline,
            label: 'นโยบายความเป็นส่วนตัว',
            onTap: () {},
            showDivider: true,
          ),
          _MenuRow(
            icon: Icons.help_outline,
            label: 'ช่วยเหลือ & ติดต่อเรา',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context, AuthProvider auth) {
    return GestureDetector(
      onTap: () => auth.logout(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.logout,
              size: 20,
              color: Color(0xFFC0503A),
            ),
            const SizedBox(width: 12),
            Text(
              'ออกจากระบบ',
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFC0503A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.showDivider = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.primaryDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: subtitle != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          label,
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFE3EFF4)),
      ],
    );
  }
}
