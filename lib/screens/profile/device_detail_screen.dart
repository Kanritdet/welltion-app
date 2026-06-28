import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../models/device_model.dart';
import '../../models/mock_data.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late String _customName;

  DeviceModel get _device =>
      MockData.devices.firstWhere((d) => d.id == widget.deviceId);

  @override
  void initState() {
    super.initState();
    _customName = _device.customName;
  }

  String _formatDate(DateTime dt) {
    const months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year + 543}';
  }

  void _showEditNameSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _EditNameSheet(
        currentName: _customName,
        onSave: (name) {
          Navigator.pop(sheetCtx);
          setState(() => _customName = name);
        },
      ),
    );
  }

  void _showDisconnectSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _DisconnectSheet(
        device: _device,
        customName: _customName,
        onConfirm: () {
          Navigator.pop(sheetCtx);
          context.pop();
          // TODO: call DeviceProvider or ApiService to remove device
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final device = _device;
    final isOnline = device.isOnline;
    final battery = device.batteryPercent;
    final isLowBat = battery < 20;
    final displayName = _customName.isNotEmpty ? _customName : device.modelName;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar ──────────────────────────────────────────────────
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
                      child: const Icon(
                        Icons.arrow_back,
                        size: 21,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'รายละเอียดอุปกรณ์',
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Hero card ─────────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFDDEFF8), AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F0E3D6E),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.spa,
                        size: 36,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            device.modelName,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              color: AppColors.primaryMid,
                            ),
                          ),
                          Text(
                            'S/N: ${device.serialNumber}',
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Status cards ──────────────────────────────────────────────
              Row(
                children: [
                  // Connection
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'การเชื่อมต่อ',
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: isOnline
                                      ? AppColors.successDark
                                      : AppColors.textMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isOnline ? 'ออนไลน์' : 'ออฟไลน์',
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isOnline
                                      ? AppColors.successDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isOnline
                                ? 'ใช้งานล่าสุด: เมื่อกี้'
                                : 'ใช้งานล่าสุด: ${_formatDate(device.lastUsedAt ?? device.connectedAt)}',
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Battery
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'แบตเตอรี่',
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.battery_5_bar,
                                size: 18,
                                color: isLowBat
                                    ? AppColors.errorDark
                                    : AppColors.primaryDark,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$battery%',
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: (battery / 100).clamp(0.0, 1.0),
                              minHeight: 4,
                              backgroundColor: AppColors.primaryLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isLowBat
                                    ? AppColors.errorDark
                                    : AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Info card ─────────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    // Custom name (editable)
                    _InfoRow(
                      label: 'ชื่อที่ตั้งเอง',
                      onTap: _showEditNameSheet,
                      showDivider: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.primaryDark,
                          ),
                        ],
                      ),
                    ),
                    _InfoRow(
                      label: 'รุ่น',
                      value: device.modelName,
                      showDivider: true,
                    ),
                    _InfoRow(
                      label: 'Serial Number',
                      value: device.serialNumber,
                      isMonospace: true,
                      showDivider: true,
                    ),
                    _InfoRow(
                      label: 'Firmware',
                      value: device.firmwareVersion,
                      showDivider: true,
                    ),
                    _InfoRow(
                      label: 'เชื่อมต่อครั้งแรก',
                      value: _formatDate(device.connectedAt),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Disconnect button ─────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: _showDisconnectSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: const Color(0xFFEAC9C5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.link_off,
                          size: 18,
                          color: AppColors.errorDark,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ยกเลิกการเชื่อมต่ออุปกรณ์',
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.errorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info Row ────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    this.value,
    this.trailing,
    this.isMonospace = false,
    this.showDivider = false,
    this.onTap,
  });

  final String label;
  final String? value;
  final Widget? trailing;
  final bool isMonospace;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing ??
                    Text(
                      value ?? '',
                      style: isMonospace
                          ? const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              fontFamily: 'monospace',
                            )
                          : GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                    ),
              ],
            ),
          ),
          if (showDivider) const Divider(height: 1, color: Color(0xFFEAF3F8)),
        ],
      ),
    );
  }
}

// ─── Bottom Sheet C: Edit Name ───────────────────────────────────────────────

class _EditNameSheet extends StatefulWidget {
  const _EditNameSheet({required this.currentName, required this.onSave});
  final String currentName;
  final ValueChanged<String> onSave;

  @override
  State<_EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<_EditNameSheet> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFA8D4E8),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'แก้ไขชื่ออุปกรณ์',
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 22,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ชื่อนี้จะแสดงเฉพาะของคุณเท่านั้น',
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            // Field label
            Text(
              'ชื่ออุปกรณ์',
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            // Input
            TextField(
              controller: _ctrl,
              autofocus: true,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryDark,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Save
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final name = _ctrl.text.trim();
                  widget.onSave(name.isNotEmpty ? name : widget.currentName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'บันทึก',
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

// ─── Bottom Sheet D: Confirm Disconnect ─────────────────────────────────────

class _DisconnectSheet extends StatelessWidget {
  const _DisconnectSheet({
    required this.device,
    required this.customName,
    required this.onConfirm,
  });

  final DeviceModel device;
  final String customName;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final name = customName.isNotEmpty ? customName : device.modelName;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFA8D4E8),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            'ยกเลิกการเชื่อมต่ออุปกรณ์?',
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'สามารถเชื่อมต่อใหม่ได้ทุกเมื่อผ่าน QR Code',
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          // Device summary (red theme)
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEAC9C5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.spa,
                    size: 24,
                    color: AppColors.errorDark,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${device.modelName} · ${device.serialNumber}',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Warning
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.bookingCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.bookingCardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 17,
                  color: AppColors.warningDark,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'ข้อมูลการใช้งานและชื่ออุปกรณ์จะถูกลบออกจากที่นี้',
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 12,
                      color: AppColors.warningDark,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'ย้อนกลับ',
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF444444),
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
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAC9C5)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'ยกเลิกการเชื่อมต่อ',
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.errorDark,
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
