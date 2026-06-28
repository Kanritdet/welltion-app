import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/venue_model.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context) {
    final venue = MockData.venueById(venueId);
    if (venue == null) {
      return const Scaffold(body: Center(child: Text('ไม่พบสถานที่')));
    }
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroImage(venue: venue),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoHeader(venue: venue),
                        const SizedBox(height: 16),
                        _AboutSection(venue: venue),
                        const SizedBox(height: 16),
                        _FacilitiesSection(venue: venue),
                        const SizedBox(height: 16),
                        _PricingCard(venue: venue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _CtaBar(venueId: venueId),
        ],
      ),
    );
  }
}

// ─── Hero Image (188px) + back button overlay ────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 188,
      child: Stack(
        fit: StackFit.expand,
        children: [
          venue.photos.isNotEmpty
              ? Image.network(
                  venue.photos.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _placeholder(),
                )
              : _placeholder(),
          Positioned(
            top: 14 + MediaQuery.of(context).padding.top,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xF2F8FBFD),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFC0E4F5),
        child: const Center(
          child: Icon(Icons.image_outlined, size: 40, color: Color(0x4D0E3D6E)),
        ),
      );
}

// ─── Name + rating + distance ─────────────────────────────────────────────────

class _InfoHeader extends StatelessWidget {
  const _InfoHeader({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venue.name,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 15, color: AppColors.amber),
            const SizedBox(width: 4),
            Text(
              venue.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${venue.reviewCount} รีวิว)',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primaryDark),
            const SizedBox(width: 3),
            Text(
              '${venue.distanceKm.toStringAsFixed(1)} กม. · ${_shortArea(venue.address)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  // ดึงชื่อย่านจาก address (คำสุดท้ายก่อน กรุงเทพ)
  String _shortArea(String address) {
    final parts = address.split(' ');
    final idx = parts.indexWhere((p) => p.contains('เขต'));
    if (idx >= 1) return parts[idx - 1];
    return parts.isNotEmpty ? parts.last : '';
  }
}

// ─── เกี่ยวกับสถานที่ ──────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    if (venue.description.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เกี่ยวกับสถานที่',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          venue.description,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF555555),
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

// ─── สิ่งอำนวยความสะดวก ────────────────────────────────────────────────────────

class _FacilitiesSection extends StatelessWidget {
  const _FacilitiesSection({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    if (venue.amenities.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'สิ่งอำนวยความสะดวก',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: venue.amenities
              .map((a) => _FacilityChip(label: a))
              .toList(),
        ),
      ],
    );
  }
}

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

// ─── ราคา ──────────────────────────────────────────────────────────────────────

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    final pricing = venue.sessionPricing;
    if (pricing.isEmpty) return const SizedBox.shrink();

    final sortedKeys = pricing.keys.toList()..sort();

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
          const Text(
            'ราคา',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 9),
          ...sortedKeys.map((min) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$min นาที',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '฿${pricing[min]}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─── CTA bottom bar ────────────────────────────────────────────────────────────

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottom),
      color: AppColors.surface,
      child: GestureDetector(
        onTap: () => context.push('/booking/$venueId'),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.accentGold,
            border: Border.all(color: AppColors.accentBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'จองวันเวลา',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.accentText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
