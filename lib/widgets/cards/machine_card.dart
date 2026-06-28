import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/machine_model.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({super.key, required this.machine, this.onTap});

  final MachineModel machine;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120E3D6E),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _deviceIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          machine.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _statusBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _iconRow(Icons.store_outlined, machine.venueName),
                  const SizedBox(height: 3),
                  _iconRow(Icons.location_on_outlined, machine.address),
                  const SizedBox(height: 6),
                  Text(
                    machine.priceInfo,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _deviceIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.accentGold,
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Center(
        child: Icon(Icons.speaker_outlined, size: 36, color: AppColors.accentText),
      ),
    );
  }

  Widget _statusBadge() {
    final (label, bg, fg) = switch (machine.status) {
      MachineStatus.available   => ('ว่าง',     const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
      MachineStatus.inUse       => ('กำลังใช้',  const Color(0xFFFFF3E0), const Color(0xFFE65100)),
      MachineStatus.maintenance => ('ซ่อมบำรุง', const Color(0xFFFFEBEE), const Color(0xFFC62828)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  Widget _iconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
