import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/biometric_session_model.dart';
import '../../models/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/charts/weekly_ring_chart.dart';

class MindScreen extends StatelessWidget {
  const MindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final userId = auth.currentUser?.id;
            final sessions = userId == null
                ? <BiometricSessionModel>[]
                : MockData.biometricSessions
                    .where((s) => s.userId == userId)
                    .toList();

            final afterSessions = sessions
                .where((s) => s.phase == BiometricPhase.after)
                .toList()
              ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
            final latest = afterSessions.isEmpty ? null : afterSessions.first;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildWeekCard(sessions),
                  if (latest != null) ...[
                    const SizedBox(height: 12),
                    _ReadinessCard(metrics: latest.metrics),
                    const SizedBox(height: 10),
                    _SleepEnergyCard(metrics: latest.metrics),
                    const SizedBox(height: 10),
                    _StressCard(metrics: latest.metrics),
                    const SizedBox(height: 10),
                    _MetricsGrid(metrics: latest.metrics),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final dd = now.day.toString().padLeft(2, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final yyyy = (now.year + 543).toString();
    final dateLabel = 'ประวัติวันที่ $dd/$mm/$yyyy';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'สุขภาพของคุณ',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateLabel,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.primaryDark,
              size: 21,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCard(List<BiometricSessionModel> sessions) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: WeeklyRingChart(sessions: sessions, weekOf: DateTime.now()),
    );
  }
}

// ── Badge helper ────────────────────────────────────────────────────────────

class _BadgeInfo {
  const _BadgeInfo(this.label, this.textColor, this.bgColor);
  final String label;
  final Color textColor;
  final Color bgColor;
}

_BadgeInfo _readinessBadge(ReadinessLevel level) {
  switch (level) {
    case ReadinessLevel.high:
      return const _BadgeInfo('สูง', Color(0xFF3B6D11), Color(0xFFEAF3DE));
    case ReadinessLevel.medium:
      return const _BadgeInfo('ปานกลาง', Color(0xFF854F0B), Color(0xFFFAEEDA));
    case ReadinessLevel.low:
      return const _BadgeInfo('ต่ำ', Color(0xFFA32D2D), Color(0xFFFCEBEB));
  }
}

_BadgeInfo _sleepBadge(String rating) {
  switch (rating) {
    case 'Good':
      return const _BadgeInfo('สูง', Color(0xFF3B6D11), Color(0xFFEAF3DE));
    case 'Fair':
      return const _BadgeInfo('ปานกลาง', Color(0xFF854F0B), Color(0xFFFAEEDA));
    default:
      return const _BadgeInfo('ต่ำ', Color(0xFFA32D2D), Color(0xFFFCEBEB));
  }
}

_BadgeInfo _stressBadge(String stress) {
  switch (stress) {
    case 'Low':
      return const _BadgeInfo('ต่ำ', Color(0xFF3B6D11), Color(0xFFEAF3DE));
    case 'Moderate':
      return const _BadgeInfo('ปานกลาง', Color(0xFF854F0B), Color(0xFFFAEEDA));
    default:
      return const _BadgeInfo('สูง', Color(0xFFA32D2D), Color(0xFFFCEBEB));
  }
}

// ── Readiness Card ──────────────────────────────────────────────────────────

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.metrics});
  final BiometricMetrics metrics;

  String get _subtitle {
    switch (metrics.readinessLevel) {
      case ReadinessLevel.high:
        return 'ร่างกายพร้อมรับกิจกรรมได้เต็มที่';
      case ReadinessLevel.medium:
        return 'ร่างกายพร้อมในระดับพอใช้';
      case ReadinessLevel.low:
        return 'ร่างกายต้องการการพักผ่อนเพิ่มเติม';
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = _readinessBadge(metrics.readinessLevel);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8E3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D98F)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bolt, size: 21, color: AppColors.accentText),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'ความพร้อม',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 2),
                      decoration: BoxDecoration(
                        color: badge.bgColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge.label,
                        style: TextStyle(
                            fontSize: 11, color: badge.textColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  metrics.readinessScore.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 22, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

// ── Shared list-style card ──────────────────────────────────────────────────

class _MetricListCard extends StatelessWidget {
  const _MetricListCard({
    required this.iconData,
    required this.title,
    required this.badge,
    required this.valueLabel,
    required this.onTap,
  });

  final IconData iconData;
  final String title;
  final _BadgeInfo badge;
  final String valueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, size: 21, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 2),
                        decoration: BoxDecoration(
                          color: badge.bgColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge.label,
                          style: TextStyle(
                              fontSize: 11, color: badge.textColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        valueLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22,
                color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ── Sleep Energy Card ───────────────────────────────────────────────────────

class _SleepEnergyCard extends StatelessWidget {
  const _SleepEnergyCard({required this.metrics});
  final BiometricMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return _MetricListCard(
      iconData: Icons.bedtime_outlined,
      title: 'พลังงานการนอน',
      badge: _sleepBadge(metrics.sleepFuelRating),
      valueLabel: '${metrics.hrv.toInt()} HRV',
      onTap: () {},
    );
  }
}

// ── Stress Card ─────────────────────────────────────────────────────────────

class _StressCard extends StatelessWidget {
  const _StressCard({required this.metrics});
  final BiometricMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return _MetricListCard(
      iconData: Icons.monitor_heart_outlined,
      title: 'ความเครียดสะสม',
      badge: _stressBadge(metrics.priorDayStress),
      valueLabel: '${metrics.priorDayStressHrv.toInt()} ms HRV',
      onTap: () {},
    );
  }
}

// ── Metrics Grid (SpO₂ + หายใจ) ────────────────────────────────────────────

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});
  final BiometricMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GridCard(
            icon: Icons.water_drop_outlined,
            label: 'SpO₂',
            value: '${metrics.spo2Avg.toStringAsFixed(0)}%',
            range: 'ช่วง ${metrics.spo2Range}%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GridCard(
            icon: Icons.air_outlined,
            label: 'หายใจ',
            value: metrics.respirationRateAvg.toStringAsFixed(0),
            valueUnit: '/นาที',
            range: 'ช่วง ${metrics.respirationRange}',
          ),
        ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({
    required this.icon,
    required this.label,
    required this.value,
    this.valueUnit,
    required this.range,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? valueUnit;
  final String range;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                if (valueUnit != null)
                  TextSpan(
                    text: valueUnit,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            range,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
