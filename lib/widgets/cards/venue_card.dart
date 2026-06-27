import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/venue_model.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    super.key,
    required this.venue,
    this.onTap,
  });

  final VenueModel venue;
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
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: SizedBox(
                width: 80,
                height: 80,
                child: venue.photos.isNotEmpty
                    ? Image.network(
                        venue.photos.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _iconRow(Icons.location_on_outlined, venue.address),
                  const SizedBox(height: 3),
                  _iconRow(Icons.schedule_outlined, venue.openingHours),
                  const SizedBox(height: 6),
                  Text(
                    venue.priceInfo,
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

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.primaryLight,
      child: const Center(
        child: Icon(Icons.store_outlined, size: 28, color: AppColors.primaryMid),
      ),
    );
  }
}
