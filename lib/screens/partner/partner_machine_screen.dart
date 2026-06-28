import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';

// ── Partner machine data ──────────────────────────────────────

enum _MachineStatus { activeOnline, availableOnline, offline }

class _Machine {
  final String id;
  final String name;
  final String serial;
  final _MachineStatus status;
  const _Machine(this.id, this.name, this.serial, this.status);
}

const List<_Machine> _mockMachines = [
  _Machine('pm1', 'WeLLzen Classic #1', 'ZFS-001', _MachineStatus.activeOnline),
  _Machine('pm2', 'WeLLzen Classic #2', 'ZFS-002', _MachineStatus.availableOnline),
  _Machine('pm3', 'WeLLzen Classic #3', 'ZFS-003', _MachineStatus.offline),
];

// ── Screen ────────────────────────────────────────────────────

class PartnerMachineScreen extends StatelessWidget {
  const PartnerMachineScreen({super.key});

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
              _PartnerMachineHeader(),
              const SizedBox(height: 14),
              for (final machine in _mockMachines) ...[
                _PartnerMachineCard(
                  machine: machine,
                  onDetailTap: () => context.push('/partner/machines/${machine.id}'),
                ),
                const SizedBox(height: 14),
              ],
              _AddMachineButton(
                onTap: () => context.push('/connect', extra: {'mode': 'ownDevice'}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────

class _PartnerMachineHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            child: const Icon(Icons.arrow_back, size: 21, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'จัดการเครื่อง',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Machine Card ──────────────────────────────────────────────

class _PartnerMachineCard extends StatelessWidget {
  const _PartnerMachineCard({required this.machine, this.onDetailTap});

  final _Machine machine;
  final VoidCallback? onDetailTap;

  @override
  Widget build(BuildContext context) {
    final (dotColor, statusText, statusTextColor) = switch (machine.status) {
      _MachineStatus.activeOnline    => (AppColors.successDark, 'ออนไลน์ · กำลังใช้งาน', AppColors.successDark),
      _MachineStatus.availableOnline => (AppColors.successDark, 'ออนไลน์ · ว่าง', AppColors.textSecondary),
      _MachineStatus.offline         => (const Color(0xFFC0503A), 'ออฟไลน์ · ตรวจสอบ', const Color(0xFFC0503A)),
    };

    final (btnBg, btnColor, btnLabel) = switch (machine.status) {
      _MachineStatus.offline => (AppColors.warningLight, AppColors.warningDark, 'ตรวจสอบ'),
      _                      => (AppColors.primaryLight, AppColors.primaryDark, 'รายละเอียด'),
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.spa, size: 24, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  machine.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  machine.serial,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(statusText, style: TextStyle(fontSize: 11, color: statusTextColor)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDetailTap,
            child: Container(
              decoration: BoxDecoration(
                color: btnBg,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Text(
                btnLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: btnColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add Machine Button ─────────────────────────────────────────

class _AddMachineButton extends StatelessWidget {
  const _AddMachineButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          border: Border.all(color: AppColors.sky),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, size: 19, color: AppColors.primaryDark),
            SizedBox(width: 7),
            Text(
              'เพิ่มเครื่องใหม่',
              style: TextStyle(
                fontSize: 13,
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
