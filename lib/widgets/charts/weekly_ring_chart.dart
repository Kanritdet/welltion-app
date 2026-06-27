import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/biometric_session_model.dart';

class WeeklyRingChart extends StatelessWidget {
  const WeeklyRingChart({
    super.key,
    required this.sessions,
    required this.weekOf,
  });

  final List<BiometricSessionModel> sessions;
  final DateTime weekOf;

  DateTime _weekStart() {
    return weekOf.subtract(Duration(days: weekOf.weekday - 1));
  }

  // คืน readinessScore ของ "after" session ล่าสุดในวันนั้น หรือ null
  double? _scoreForDay(DateTime day) {
    final daySessions = sessions
        .where((s) =>
            s.recordedAt.year == day.year &&
            s.recordedAt.month == day.month &&
            s.recordedAt.day == day.day &&
            s.phase == BiometricPhase.after)
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return daySessions.isEmpty ? null : daySessions.first.metrics.readinessScore;
  }

  @override
  Widget build(BuildContext context) {
    final start = _weekStart();
    const labels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    final today = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final day = start.add(Duration(days: i));
        final score = _scoreForDay(day);
        final isToday = day.year == today.year &&
            day.month == today.month &&
            day.day == today.day;
        return _DayRing(
          label: labels[i],
          score: score,
          isToday: isToday,
        );
      }),
    );
  }
}

class _DayRing extends StatelessWidget {
  const _DayRing({
    required this.label,
    required this.score,
    required this.isToday,
  });

  final String label;
  final double? score;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final ringSize = isToday ? 46.0 : 34.0;
    final scorePercent = score != null ? (score! / 3.0 * 100).round() : null;

    return Column(
      children: [
        Text(
          isToday ? 'วันนี้' : label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isToday ? FontWeight.w500 : FontWeight.w400,
            color: isToday ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: ringSize,
          height: ringSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(ringSize, ringSize),
                painter: _RingPainter(score: score, isToday: isToday),
              ),
              if (isToday && scorePercent != null)
                Text(
                  '$scorePercent%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.score, required this.isToday});

  final double? score;
  final bool isToday;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = isToday ? 4.5 : 4.0;
    final radius = size.width / 2 - strokeWidth / 2;

    final bgPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    if (score != null) {
      final fraction = (score! / 3.0).clamp(0.0, 1.0);
      final fgPaint = Paint()
        ..color = isToday ? AppColors.primaryDark : AppColors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * fraction,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.score != score || old.isToday != isToday;
}
