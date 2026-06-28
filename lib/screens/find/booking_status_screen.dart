import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/booking_model.dart';

class BookingStatusScreen extends StatefulWidget {
  const BookingStatusScreen({
    super.key,
    required this.booking,
    required this.venueName,
  });

  final BookingModel booking;
  final String venueName;

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  late BookingStatus _status;

  @override
  void initState() {
    super.initState();
    _status = widget.booking.status;
  }

  void _simulateConfirm() => setState(() => _status = BookingStatus.confirmed);
  void _simulateReject() => setState(() => _status = BookingStatus.cancelled);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _StatusHero(status: _status),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusTitle(
                    status: _status,
                    price: widget.booking.price.toInt(),
                  ),
                  const SizedBox(height: 16),
                  _BookingStepper(status: _status),
                  const SizedBox(height: 12),
                  Text(
                    'เลขที่การจอง ${widget.booking.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Divider(height: 24, color: Color(0xFFEAF3F8)),
                  _BookingDetailCard(
                    booking: widget.booking,
                    venueName: widget.venueName,
                    isRejected: _status == BookingStatus.cancelled,
                  ),
                  if (_status == BookingStatus.confirmed) ...[
                    const SizedBox(height: 16),
                    const _QRPlaceholder(),
                  ],
                  if (_status == BookingStatus.pending) ...[
                    const Divider(height: 32, color: Color(0xFFEAF3F8)),
                    _DemoPartnerBar(
                      onConfirm: _simulateConfirm,
                      onReject: _simulateReject,
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _StatusCtaBar(status: _status, booking: widget.booking),
        ],
      ),
    );
  }
}

// ─── Status Hero (gradient header) ───────────────────────────────────────────

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.status});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (gradStart, gradEnd, icon, iconColor) = switch (status) {
      BookingStatus.pending => (
        const Color(0xFFDDEFF8),
        const Color(0xFFEAF5FB),
        Icons.hourglass_top,
        AppColors.amber,
      ),
      BookingStatus.confirmed => (
        const Color(0xFFE2F0DE),
        const Color(0xFFEFF6EA),
        Icons.check_circle,
        AppColors.successDark,
      ),
      _ => (
        const Color(0xFFF6E4E2),
        const Color(0xFFFBEFEE),
        Icons.cancel,
        AppColors.errorDark,
      ),
    };

    final top = MediaQuery.of(context).padding.top;
    final heroH = 142.0;

    return Container(
      height: heroH + top,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradStart, gradEnd],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: top + 14,
            left: 14,
            child: GestureDetector(
              onTap: () => context.go('/find'),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E3D6E).withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          Positioned(
            top: top + (heroH - 58) / 2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E3D6E).withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 30, color: iconColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status Title ─────────────────────────────────────────────────────────────

class _StatusTitle extends StatelessWidget {
  const _StatusTitle({required this.status, required this.price});
  final BookingStatus status;
  final int price;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = switch (status) {
      BookingStatus.pending => (
        'รอ Partner ยืนยันการจอง',
        'โดยปกติใช้เวลาไม่เกิน 15 นาที',
      ),
      BookingStatus.confirmed => (
        'ยืนยันการจองแล้ว',
        'แสดง QR นี้ที่เครื่องเพื่อเริ่มใช้บริการ',
      ),
      _ => (
        'การจองถูกปฏิเสธ',
        'คืนเงิน ฿$price เข้าวอลเล็ตเรียบร้อยแล้ว',
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─── Booking Stepper ──────────────────────────────────────────────────────────

enum _StepState { done, active, confirmed, rejected, inactive }

class _BookingStepper extends StatelessWidget {
  const _BookingStepper({required this.status});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final isPending = status == BookingStatus.pending;
    final isConfirmed = status == BookingStatus.confirmed;
    final isRejected = status == BookingStatus.cancelled;

    return Row(
      children: [
        _Step(
          icon: Icons.check,
          label: 'จองแล้ว',
          state: _StepState.done,
        ),
        _Connector(active: true),
        _Step(
          icon: isPending ? Icons.hourglass_top : Icons.check,
          label: 'รอยืนยัน',
          state: isPending ? _StepState.active : _StepState.done,
        ),
        _Connector(active: !isPending),
        _Step(
          icon: isConfirmed
              ? Icons.verified
              : isRejected
              ? Icons.close
              : Icons.verified,
          label: isRejected ? 'ปฏิเสธ' : 'ยืนยัน',
          state: isConfirmed
              ? _StepState.confirmed
              : isRejected
              ? _StepState.rejected
              : _StepState.inactive,
        ),
        _Connector(active: false),
        const _Step(
          icon: Icons.self_improvement,
          label: 'ใช้บริการ',
          state: _StepState.inactive,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.icon,
    required this.label,
    required this.state,
  });
  final IconData icon;
  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, textColor, border) = switch (state) {
      _StepState.done => (
        AppColors.primaryDark,
        Colors.white,
        AppColors.primaryDark,
        null as Color?,
      ),
      _StepState.active => (
        AppColors.accentGold,
        AppColors.amber,
        AppColors.amber,
        AppColors.accentBorder,
      ),
      _StepState.confirmed => (
        AppColors.successDark,
        Colors.white,
        AppColors.successDark,
        null as Color?,
      ),
      _StepState.rejected => (
        const Color(0xFFFBE9E7),
        AppColors.errorDark,
        AppColors.errorDark,
        const Color(0xFFEAC9C5),
      ),
      _StepState.inactive => (
        AppColors.primaryLight,
        AppColors.textMuted,
        AppColors.textMuted,
        null as Color?,
      ),
    };

    return SizedBox(
      width: 58,
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: border != null ? Border.all(color: border) : null,
            ),
            child: Icon(icon, size: 21, color: fg),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: state == _StepState.inactive
                  ? FontWeight.normal
                  : FontWeight.w600,
              color: textColor,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 19),
        color: active ? AppColors.primaryDark : const Color(0xFFDCEAF2),
      ),
    );
  }
}

// ─── Booking Detail Card ──────────────────────────────────────────────────────

class _BookingDetailCard extends StatelessWidget {
  const _BookingDetailCard({
    required this.booking,
    required this.venueName,
    this.isRejected = false,
  });
  final BookingModel booking;
  final String venueName;
  final bool isRejected;

  String _endTime() {
    final parts = booking.startTime.split(':');
    final totalMin =
        int.parse(parts[0]) * 60 + int.parse(parts[1]) + booking.durationMinutes;
    return '${(totalMin ~/ 60).toString().padLeft(2, '0')}:${(totalMin % 60).toString().padLeft(2, '0')}';
  }

  String _fmtDate() {
    const days = [
      '',
      'จันทร์',
      'อังคาร',
      'พุธ',
      'พฤหัส',
      'ศุกร์',
      'เสาร์',
      'อาทิตย์',
    ];
    const months = [
      '',
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
    final d = booking.date;
    return '${days[d.weekday]} ${d.day} ${months[d.month]}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailRow(
          icon: Icons.storefront_outlined,
          label: 'สถานที่',
          value: venueName,
          strikethrough: isRejected,
        ),
        const SizedBox(height: 10),
        _DetailRow(
          icon: Icons.calendar_today_outlined,
          label: 'วันที่',
          value: '${_fmtDate()} · ${booking.startTime} – ${_endTime()}',
          strikethrough: isRejected,
        ),
        const SizedBox(height: 10),
        _DetailRow(
          icon: Icons.timer_outlined,
          label: 'ระยะเวลา',
          value: '${booking.durationMinutes} นาที',
          strikethrough: isRejected,
        ),
        const SizedBox(height: 10),
        _DetailRow(
          icon: Icons.payments_outlined,
          label: 'ราคา',
          value: '฿${booking.price.toInt()}',
          strikethrough: isRejected,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.strikethrough = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool strikethrough;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: AppColors.primaryDark),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: strikethrough ? AppColors.textMuted : AppColors.textPrimary,
              decoration:
                  strikethrough ? TextDecoration.lineThrough : TextDecoration.none,
              decorationColor: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── QR Placeholder (confirmed) ───────────────────────────────────────────────

class _QRPlaceholder extends StatelessWidget {
  const _QRPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Icon(Icons.qr_code_2, size: 120, color: AppColors.primaryDark),
      ),
    );
  }
}

// ─── Demo Partner Buttons (pending only) ─────────────────────────────────────

class _DemoPartnerBar extends StatelessWidget {
  const _DemoPartnerBar({required this.onConfirm, required this.onReject});
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'จำลอง Partner (Demo)',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onConfirm,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.successDark.withValues(alpha: 0.35),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Partner ยืนยัน',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.successDark,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: onReject,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.errorDark.withValues(alpha: 0.35),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Partner ปฏิเสธ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.errorDark,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Status CTA Bar ───────────────────────────────────────────────────────────

class _StatusCtaBar extends StatelessWidget {
  const _StatusCtaBar({required this.status, required this.booking});
  final BookingStatus status;
  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    Widget child;
    switch (status) {
      case BookingStatus.pending:
        child = GestureDetector(
          onTap: () => context.go('/find'),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEAD3D1)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 13),
            alignment: Alignment.center,
            child: const Text(
              'ยกเลิกการจอง',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.errorDark,
              ),
            ),
          ),
        );
      case BookingStatus.confirmed:
        child = GestureDetector(
          onTap: () {},
          child: _goldButton('ดูใบจอง'),
        );
      default:
        child = GestureDetector(
          onTap: () => context.go('/find'),
          child: _goldButton('ค้นหาเครื่องที่อื่น'),
        );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottom),
      child: child,
    );
  }

  Widget _goldButton(String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentGold,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentBorder),
      ),
      padding: const EdgeInsets.symmetric(vertical: 13),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.accentText,
        ),
      ),
    );
  }
}
