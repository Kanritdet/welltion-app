import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/booking_model.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.booking,
    required this.venueName,
    this.onTap,
  });

  final BookingModel booking;
  final String venueName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bookingCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.bookingCardBorder),
        ),
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.storefront_outlined,
                color: AppColors.accentText,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venueName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _formatBookingTime(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _StatusBadge(status: booking.status),
          ],
        ),
      ),
    );
  }

  String _formatBookingTime() {
    const days = ['', 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัส', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
    const months = [
      '', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
    ];
    final dayName = days[booking.date.weekday];
    final dateStr = '${booking.date.day} ${months[booking.date.month]}';

    final parts = booking.startTime.split(':');
    final startMin = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final endMin = startMin + booking.durationMinutes;
    final endTime =
        '${(endMin ~/ 60).toString().padLeft(2, '0')}:${(endMin % 60).toString().padLeft(2, '0')}';

    return '$dayName $dateStr · ${booking.startTime} – $endTime';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      BookingStatus.confirmed => ('กำลังจะมาถึง', AppColors.upcomingBg, AppColors.upcomingText),
      BookingStatus.pending   => ('รอยืนยัน',     const Color(0xFFFFF8E1), const Color(0xFFF57F17)),
      BookingStatus.cancelled => ('ยกเลิก',        AppColors.errorLight,   AppColors.errorDark),
      BookingStatus.completed => ('เสร็จสิ้น',     AppColors.primaryLight,  AppColors.primaryMid),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}
