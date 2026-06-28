import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/booking_model.dart';
import '../../models/mock_data.dart';
import '../../models/venue_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.venueId});
  final String venueId;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  int _selectedDuration = 45;

  VenueModel? get _venue => MockData.venueById(widget.venueId);
  int get _price => _venue?.sessionPricing[_selectedDuration] ?? 0;
  bool get _canConfirm => _selectedDate != null && _selectedTime != null;

  void _showCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CalendarSheet(
        initialDate: _selectedDate ?? DateTime.now(),
        onConfirm: (date) => setState(() => _selectedDate = date),
      ),
    );
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TimeSheet(
        selectedDate: _selectedDate,
        initialTime: _selectedTime,
        onConfirm: (time) => setState(() => _selectedTime = time),
      ),
    );
  }

  void _confirmBooking() {
    final venue = _venue;
    if (venue == null || !_canConfirm) return;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    final booking = BookingModel(
      id: 'WL-${ts.substring(ts.length - 7)}',
      userId: 'u1',
      venueId: venue.id,
      date: _selectedDate!,
      startTime: _selectedTime!,
      durationMinutes: _selectedDuration,
      rentalType: BookingRentalType.session,
      price: _price.toDouble(),
      status: BookingStatus.pending,
    );
    context.push('/booking-status', extra: {
      'booking': booking,
      'venueName': venue.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    final venue = _venue;
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
                  _BookingHeader(onBack: () => context.pop()),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'แบบเช่า',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _VenueMiniCard(venue: venue),
                        const SizedBox(height: 16),
                        const _SectionLabel('เลือกวันที่'),
                        const SizedBox(height: 8),
                        _PickerRow(
                          icon: Icons.calendar_today_outlined,
                          text: _selectedDate != null
                              ? _fmtDate(_selectedDate!)
                              : 'เลือกวันที่',
                          isEmpty: _selectedDate == null,
                          onTap: _showCalendar,
                        ),
                        const SizedBox(height: 12),
                        const _SectionLabel('เลือกเวลา'),
                        const SizedBox(height: 8),
                        _PickerRow(
                          icon: Icons.schedule_outlined,
                          text: _selectedTime ?? 'เลือกเวลา',
                          isEmpty: _selectedTime == null,
                          onTap: _showTimePicker,
                        ),
                        const SizedBox(height: 12),
                        const _SectionLabel('ระยะเวลา'),
                        const SizedBox(height: 8),
                        _DurationChips(
                          selected: _selectedDuration,
                          onChanged: (d) => setState(() => _selectedDuration = d),
                        ),
                        const SizedBox(height: 16),
                        _TotalPriceCard(price: _price),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _CtaBar(enabled: _canConfirm, onTap: _confirmBooking),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) {
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
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];
    return '${days[d.weekday]} ${d.day} ${months[d.month]} ${d.year + 543}';
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _BookingHeader extends StatelessWidget {
  const _BookingHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, top + 14, 16, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.primaryDark,
                size: 21,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'จอง',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Venue Mini Card ──────────────────────────────────────────────────────────

class _VenueMiniCard extends StatelessWidget {
  const _VenueMiniCard({required this.venue});
  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    final district = venue.name.split(' ').last;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: AppColors.primaryDark,
              size: 22,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.amber),
                    const SizedBox(width: 5),
                    Text(
                      venue.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      ' · $district',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ─── Picker Row (date / time) ─────────────────────────────────────────────────

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.icon,
    required this.text,
    required this.isEmpty,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final bool isEmpty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isEmpty ? AppColors.border : AppColors.primaryDark,
            width: isEmpty ? 1.0 : 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      isEmpty ? AppColors.textSecondary : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              isEmpty ? Icons.expand_more : Icons.expand_less,
              size: 22,
              color: isEmpty ? AppColors.textMuted : AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Duration Chips ───────────────────────────────────────────────────────────

class _DurationChips extends StatelessWidget {
  const _DurationChips({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = [30, 45, 60];
    return Row(
      children: options.asMap().entries.map((e) {
        final i = e.key;
        final mins = e.value;
        final isSelected = mins == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : 4,
              right: i == options.length - 1 ? 0 : 4,
            ),
            child: GestureDetector(
              onTap: () => onChanged(mins),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accentGold : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.accentBorder : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$mins นาที',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppColors.accentText
                        : const Color(0xFF444444),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Total Price Card ─────────────────────────────────────────────────────────

class _TotalPriceCard extends StatelessWidget {
  const _TotalPriceCard({required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'ราคารวม',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '฿$price',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CTA Bar ──────────────────────────────────────────────────────────────────

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + bottom),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            color: enabled ? AppColors.accentGold : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled ? AppColors.accentBorder : AppColors.border,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          child: Text(
            'ยืนยันการจอง',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: enabled ? AppColors.accentText : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CALENDAR BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════

class _CalendarSheet extends StatefulWidget {
  const _CalendarSheet({required this.initialDate, required this.onConfirm});
  final DateTime initialDate;
  final ValueChanged<DateTime> onConfirm;

  @override
  State<_CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends State<_CalendarSheet> {
  late DateTime _viewMonth;
  late DateTime _selected;

  static const _thaiMonths = [
    '',
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];
  static const _dayHeaders = ['อา', 'จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส'];

  @override
  void initState() {
    super.initState();
    final init = widget.initialDate;
    _viewMonth = DateTime(init.year, init.month);
    _selected = init;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final firstOfMonth = DateTime(_viewMonth.year, _viewMonth.month);
    final daysInMonth =
        DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    // weekday: 1=Mon, 7=Sun. Convert to Sunday-first (Sun=0)
    final startOffset = firstOfMonth.weekday % 7;
    final beYear = _viewMonth.year + 543;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A0E3D6E),
            blurRadius: 28,
            offset: Offset(0, -10),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            margin: const EdgeInsets.only(top: 14, bottom: 16),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFA8D4E8),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          // header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'เลือกวันที่',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(
                  () => _viewMonth =
                      DateTime(_viewMonth.year, _viewMonth.month - 1),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  size: 20,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                '${_thaiMonths[_viewMonth.month]} $beYear',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => setState(
                  () => _viewMonth =
                      DateTime(_viewMonth.year, _viewMonth.month + 1),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // day-of-week headers
          Row(
            children: _dayHeaders
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          // date grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (_, i) {
              if (i < startOffset) return const SizedBox();
              final day = i - startOffset + 1;
              final date = DateTime(_viewMonth.year, _viewMonth.month, day);
              final dateOnly = DateTime(date.year, date.month, date.day);
              final isSelected =
                  date.year == _selected.year &&
                  date.month == _selected.month &&
                  date.day == _selected.day;
              final isPast = dateOnly.isBefore(todayOnly);

              return GestureDetector(
                onTap: isPast ? null : () => setState(() => _selected = date),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 12,
                      color: isPast
                          ? AppColors.textMuted
                          : isSelected
                          ? AppColors.amber
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // confirm button
          GestureDetector(
            onTap: () {
              widget.onConfirm(_selected);
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accentBorder),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              child: const Text(
                'ยืนยันวันที่',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TIME PICKER BOTTOM SHEET — Drum Wheel
// ═══════════════════════════════════════════════════════════════════════════════

class _TimeSheet extends StatefulWidget {
  const _TimeSheet({
    this.selectedDate,
    this.initialTime,
    required this.onConfirm,
  });
  final DateTime? selectedDate;
  final String? initialTime;
  final ValueChanged<String> onConfirm;

  @override
  State<_TimeSheet> createState() => _TimeSheetState();
}

class _TimeSheetState extends State<_TimeSheet> {
  static final List<int> _hours = List.generate(13, (i) => i + 8); // 8–20
  static const List<int> _minutes = [0, 15, 30, 45];

  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minCtrl;
  late int _selectedHour;
  late int _selectedMin;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      final parts = widget.initialTime!.split(':');
      _selectedHour = int.parse(parts[0]).clamp(8, 20);
      final raw = int.parse(parts[1]);
      _selectedMin = _minutes.reduce(
        (a, b) => (b - raw).abs() < (a - raw).abs() ? b : a,
      );
    } else {
      _selectedHour = 10;
      _selectedMin = 0;
    }
    _hourCtrl = FixedExtentScrollController(
      initialItem: _hours.indexOf(_selectedHour),
    );
    _minCtrl = FixedExtentScrollController(
      initialItem: _minutes.indexOf(_selectedMin),
    );
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  String get _timeStr =>
      '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMin.toString().padLeft(2, '0')}';

  String get _dateLabel {
    final d = widget.selectedDate;
    if (d == null) return '';
    const days = ['', 'จันทร์', 'อังคาร', 'พุธ', 'พฤหัส', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
    const months = [
      '', 'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
      'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
    ];
    return '${days[d.weekday]} ${d.day} ${months[d.month]} ${d.year + 543}';
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    const itemH = 44.0;
    const visibleItems = 3;
    const wheelH = itemH * visibleItems;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(color: Color(0x1A0E3D6E), blurRadius: 28, offset: Offset(0, -10)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            margin: const EdgeInsets.only(top: 14, bottom: 16),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFA8D4E8),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เลือกเวลา',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  if (_dateLabel.isNotEmpty)
                    Text(_dateLabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // drum wheel
          SizedBox(
            height: wheelH,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // center highlight strip
                Container(
                  height: itemH,
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // wheels
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // hour wheel
                    SizedBox(
                      width: 90,
                      child: ListWheelScrollView(
                        controller: _hourCtrl,
                        itemExtent: itemH,
                        diameterRatio: 2.2,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (i) =>
                            setState(() => _selectedHour = _hours[i]),
                        children: _hours.map((h) {
                          final selected = h == _selectedHour;
                          return Center(
                            child: Text(
                              h.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: selected ? 24 : 18,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                color: selected ? AppColors.textPrimary : AppColors.textMuted,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // separator
                    const Text(
                      ':',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    // minute wheel
                    SizedBox(
                      width: 90,
                      child: ListWheelScrollView(
                        controller: _minCtrl,
                        itemExtent: itemH,
                        diameterRatio: 2.2,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (i) =>
                            setState(() => _selectedMin = _minutes[i]),
                        children: _minutes.map((m) {
                          final selected = m == _selectedMin;
                          return Center(
                            child: Text(
                              m.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: selected ? 24 : 18,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                color: selected ? AppColors.textPrimary : AppColors.textMuted,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                // fade top
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: itemH,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0)],
                        ),
                      ),
                    ),
                  ),
                ),
                // fade bottom
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: itemH,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // confirm button
          GestureDetector(
            onTap: () {
              widget.onConfirm(_timeStr);
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accentBorder),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              child: const Text(
                'ยืนยันเวลา',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accentText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
