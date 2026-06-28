import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/healer_model.dart';
import '../../models/mock_data.dart';

class HealerProfileScreen extends StatelessWidget {
  const HealerProfileScreen({super.key, required this.healerId});
  final String healerId;

  @override
  Widget build(BuildContext context) {
    final healer = MockData.healerById(healerId);
    if (healer == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              _BackBar(title: 'Healer Profile'),
              const Expanded(child: Center(child: Text('ไม่พบข้อมูล'))),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BackBar(title: 'โปรไฟล์ Healer'),
              const SizedBox(height: 22),
              _ProfileHeader(healer: healer),
              const SizedBox(height: 20),
              _AboutSection(bio: healer.bio),
              const SizedBox(height: 16),
              _SpecialtiesRow(specialties: healer.specialties),
              if (healer.services.isNotEmpty) ...[
                const SizedBox(height: 20),
                _ServicesSection(services: healer.services),
              ],
              const SizedBox(height: 20),
              _InfoBanner(),
              const SizedBox(height: 20),
              _ContactButtons(healer: healer),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Back Bar ─────────────────────────────────────────────────────────────────

class _BackBar extends StatelessWidget {
  const _BackBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
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
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

// ─── Profile Header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.healer});
  final HealerModel healer;

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(42),
          child: SizedBox(
            width: 84,
            height: 84,
            child: Image.network(
              healer.photo,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.primaryLight,
                child: const Center(
                  child: Icon(Icons.person_outline, size: 36, color: AppColors.primaryDark),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                healer.name,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                healer.specialties.first,
                style: const TextStyle(fontSize: 13, color: AppColors.primaryMid),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Stat(value: healer.rating.toStringAsFixed(1), label: 'คะแนน'),
                  const SizedBox(width: 16),
                  _Stat(value: '${healer.yearsExp} ปี', label: 'ประสบการณ์'),
                  const SizedBox(width: 16),
                  _Stat(value: _fmt(healer.followerCount), label: 'ผู้ติดตาม'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── About Section ────────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.bio});
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('เกี่ยวกับ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text(bio, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.65)),
      ],
    );
  }
}

// ─── Specialties Row ──────────────────────────────────────────────────────────

class _SpecialtiesRow extends StatelessWidget {
  const _SpecialtiesRow({required this.specialties});
  final List<String> specialties;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: specialties.map((s) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accentGold,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.accentBorder),
        ),
        child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.accentText, fontWeight: FontWeight.w500)),
      )).toList(),
    );
  }
}

// ─── Services Section ─────────────────────────────────────────────────────────

class _ServicesSection extends StatelessWidget {
  const _ServicesSection({required this.services});
  final List<HealerService> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('บริการ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: services.asMap().entries.map((e) {
              final isLast = e.key == services.length - 1;
              final svc = e.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(svc.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                              const SizedBox(height: 3),
                              Text('${svc.durationMin} นาที', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Text(
                          '฿${svc.price.toInt()}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) const Divider(height: 1, color: Color(0xFFEAF3F8)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── Info Banner ──────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8E3),
        border: Border.all(color: const Color(0xFFE8D98F)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 17, color: AppColors.amber),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'ติดต่อ Healer ได้โดยตรง — weLLtion ยังไม่มีระบบจองผ่าน Healer',
              style: TextStyle(fontSize: 12, color: AppColors.amber, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contact Buttons ──────────────────────────────────────────────────────────

class _ContactButtons extends StatelessWidget {
  const _ContactButtons({required this.healer});
  final HealerModel healer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ติดต่อ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 10),
        Row(
          children: [
            if (healer.line != null)
              Expanded(child: _ContactBtn(label: 'LINE', icon: Icons.chat_bubble_outline, onTap: () {})),
            if (healer.line != null && healer.phone != null) const SizedBox(width: 10),
            if (healer.phone != null)
              Expanded(child: _ContactBtn(label: 'โทรศัพท์', icon: Icons.phone_outlined, onTap: () {})),
            if (healer.phone != null && healer.instagram != null) const SizedBox(width: 10),
            if (healer.instagram != null)
              Expanded(child: _ContactBtn(label: 'Instagram', icon: Icons.photo_camera_outlined, onTap: () {})),
          ],
        ),
      ],
    );
  }
}

class _ContactBtn extends StatelessWidget {
  const _ContactBtn({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryDark),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
