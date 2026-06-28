import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/device_model.dart';
import '../../models/mock_data.dart';
import '../../providers/auth_provider.dart';

class DeviceSettingsScreen extends StatelessWidget {
  const DeviceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final userId = auth.currentUser?.id ?? 'u1';
        final devices = MockData.devices
            .where((d) => d.ownerUserId == userId)
            .toList();

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          child: const Icon(
                            Icons.arrow_back,
                            size: 21,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'อุปกรณ์ของฉัน',
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${devices.length} เครื่อง',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    children: [
                      ...devices.map(
                        (d) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _DeviceCard(
                            device: d,
                            onTap: () =>
                                context.push('/device-settings/${d.id}'),
                          ),
                        ),
                      ),
                      _AddDeviceButton(onTap: () => context.push('/connect')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Device Card ────────────────────────────────────────────────────────────

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device, this.onTap});
  final DeviceModel device;
  final VoidCallback? onTap;

  Color get _batteryColor {
    if (device.batteryPercent < 20) return AppColors.errorDark;
    if (device.isOnline) return AppColors.successDark;
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = device.isOnline;
    final battery = device.batteryPercent;
    final isLowBat = battery < 20;
    final displayName = device.customName.isNotEmpty
        ? device.customName
        : device.modelName;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isOnline
                    ? AppColors.primaryLight
                    : const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.spa,
                size: 26,
                color: isOnline ? AppColors.primaryDark : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 3),
                  Text(
                    '${device.modelName} · ${device.serialNumber}',
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isOnline
                              ? AppColors.successDark
                              : AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isOnline ? 'ออนไลน์' : 'ออฟไลน์',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: isOnline
                              ? AppColors.successDark
                              : AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.battery_5_bar,
                        size: 15,
                        color: isLowBat
                            ? AppColors.errorDark
                            : AppColors.primaryDark,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$battery%',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isLowBat
                              ? AppColors.errorDark
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Battery bar — ใช้ LinearProgressIndicator เพราะ FractionallySizedBox
                  // crash ใน Column(crossAxisAlignment: .start) บน Flutter บางเวอร์ชัน
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (battery / 100).clamp(0.0, 1.0),
                      minHeight: 4,
                      backgroundColor: AppColors.primaryLight,
                      valueColor: AlwaysStoppedAnimation<Color>(_batteryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add Device Button ───────────────────────────────────────────────────────

class _AddDeviceButton extends StatelessWidget {
  const _AddDeviceButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 18, color: AppColors.primaryDark),
            const SizedBox(width: 6),
            Text(
              'เพิ่มอุปกรณ์',
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
