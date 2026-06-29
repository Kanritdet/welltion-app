import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/venue_model.dart';
import '../../models/booking_model.dart';

enum ConnectMode { ownDevice, booking, walkIn }

class ConnectDeviceScreen extends StatefulWidget {
  final ConnectMode mode;
  final String? bookingId;
  final String? venueId;

  const ConnectDeviceScreen({
    super.key,
    this.mode = ConnectMode.ownDevice,
    this.bookingId,
    this.venueId,
  });

  @override
  State<ConnectDeviceScreen> createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  bool _isScanned = false;
  bool _isQrTab = true;
  int _selectedDuration = 30;
  final _serialController = TextEditingController();

  @override
  void dispose() {
    _serialController.dispose();
    super.dispose();
  }

  BookingModel? get _booking => widget.bookingId != null
      ? MockData.bookings.where((b) => b.id == widget.bookingId).firstOrNull
      : MockData.bookings.firstOrNull;

  VenueModel? get _venue => widget.venueId != null
      ? MockData.venueById(widget.venueId!)
      : MockData.venues.firstOrNull;

  Map<int, int> get _pricing => _venue?.sessionPricing ?? {30: 70, 45: 100, 60: 130};

  bool get _canConnect => _isScanned || _serialController.text.trim().isNotEmpty;

  void _simulateScan() {
    setState(() => _isScanned = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: widget.mode == ConnectMode.walkIn
            ? _buildWalkIn()
            : _buildQrFlow(),
      ),
    );
  }

  // ── 06a / 06b: QR + Serial with tab toggle ───────────────────────
  Widget _buildQrFlow() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildConnectTabToggle(),
          const SizedBox(height: 20),
          if (_isQrTab) ...[
            _buildQrArea(),
            if (_isScanned) ...[
              const SizedBox(height: 16),
              _buildScanResult(),
            ],
          ] else ...[
            _buildSerialInput(),
          ],
          const SizedBox(height: 24),
          _buildCtaBar(),
        ],
      ),
    );
  }

  Widget _buildConnectTabToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3F8),
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _connectTab('สแกน QR', true),
          _connectTab('รหัสสินค้า', false),
        ],
      ),
    );
  }

  Widget _connectTab(String label, bool isQr) {
    final active = _isQrTab == isQr;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _isQrTab = isQr;
          if (!isQr) _isScanned = false;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active ? [const BoxShadow(color: Color(0x0F000000), blurRadius: 3, offset: Offset(0, 1))] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w500 : FontWeight.normal,
              color: active ? AppColors.primaryDark : const Color(0xFF444444),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            child: const Icon(Icons.close, size: 21, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'เชื่อมต่ออุปกรณ์',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildQrArea() {
    return GestureDetector(
      onTap: _isScanned ? null : _simulateScan,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E2C),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: 180,
                height: 180,
                child: Stack(children: _buildCorners()),
              ),
            ),
            if (!_isScanned)
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: const Text(
                  'วางกรอบให้ตรง QR Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0x66FFFFFF)),
                ),
              )
            else
              Positioned.fill(
                child: Center(
                  child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 64),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const size = 28.0;
    const thick = 3.0;
    const color = Color(0xFFE8F4FB);
    const rad = 5.0;

    return [
      Positioned(top: 0, left: 0, child: Container(width: size, height: size,
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: color, width: thick), left: BorderSide(color: color, width: thick)), borderRadius: BorderRadius.only(topLeft: Radius.circular(rad))))),
      Positioned(top: 0, right: 0, child: Container(width: size, height: size,
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: color, width: thick), right: BorderSide(color: color, width: thick)), borderRadius: BorderRadius.only(topRight: Radius.circular(rad))))),
      Positioned(bottom: 0, left: 0, child: Container(width: size, height: size,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: color, width: thick), left: BorderSide(color: color, width: thick)), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(rad))))),
      Positioned(bottom: 0, right: 0, child: Container(width: size, height: size,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: color, width: thick), right: BorderSide(color: color, width: thick)), borderRadius: BorderRadius.only(bottomRight: Radius.circular(rad))))),
      Positioned.fill(child: Center(child: Container(height: 2, color: const Color(0xFFF4EAD8).withValues(alpha: 0.4)))),
    ];
  }

  Widget _buildSerialInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'รหัสเครื่อง (Serial Number)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _serialController,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'WZ-0000-0000',
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            suffixIcon: const Icon(Icons.keyboard_outlined, color: AppColors.primaryDark, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.25), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanResult() {
    if (widget.mode == ConnectMode.booking) {
      final booking = _booking;
      final venue = booking != null ? MockData.venueById(booking.venueId) : null;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryDark, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.storefront, size: 22, color: AppColors.primaryDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue?.name ?? 'WeLLtion Studio',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      Text(
                        booking != null
                            ? 'การจอง ${booking.date.day} ${_monthName(booking.date.month)} · ${booking.startTime}'
                            : 'การจอง',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 18, color: AppColors.primaryDark),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Session ที่จ่ายแล้ว', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                  ),
                  Text(
                    '${booking?.durationMinutes ?? 45} นาที',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryDark, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.spa, size: 22, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WeLLzen Classic', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text('WSB03221 · สินค้าของคุณ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            width: 30, height: 30,
            decoration: const BoxDecoration(color: Color(0xFFEAF3DE), shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 17, color: Color(0xFF3B6D11)),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaBar() {
    final label = widget.mode == ConnectMode.booking ? 'เริ่มใช้งานทันที' : 'เชื่อมต่อ';
    final icon = widget.mode == ConnectMode.booking ? Icons.play_arrow : Icons.link;

    return GestureDetector(
        onTap: _canConnect
            ? () {
                if (widget.mode == ConnectMode.booking) {
                  context.go('/player');
                } else {
                  context.pop();
                }
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: _canConnect ? AppColors.accentGold : const Color(0xFFF5EEC5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 19,
                  color: _canConnect ? AppColors.accentText : AppColors.accentText.withValues(alpha: 0.35)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _canConnect ? AppColors.accentText : AppColors.accentText.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ),
    );
  }

  // ── 06c: Walk-in flow ────────────────────────────────────────────
  Widget _buildWalkIn() {
    final venue = _venue;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                if (venue != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.storefront, size: 20, color: AppColors.primaryDark),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(venue.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              const Text('Partner · เครื่อง WeLLzen', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 18),
                const Text('เลือกระยะเวลา', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                ..._pricing.entries.map((e) => _buildDurationCard(e.key, e.value)),
              ],
            ),
          ),
        ),
        _buildWalkInCtaBar(),
      ],
    );
  }

  Widget _buildDurationCard(int minutes, int price) {
    final selected = _selectedDuration == minutes;
    final labels = {30: 'เหมาะสำหรับผู้เริ่มต้น', 45: 'แนะนำ', 60: 'Full session'};
    return GestureDetector(
      onTap: () => setState(() => _selectedDuration = minutes),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected ? AppColors.primaryDark : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.timer, size: 17, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$minutes นาที', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  Text(labels[minutes] ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Text('฿$price', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildWalkInCtaBar() {
    final price = _pricing[_selectedDuration] ?? 70;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: GestureDetector(
        onTap: () => context.go('/checkout'),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.accentGold,
            border: Border.all(color: AppColors.accentBorder),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            'ชำระเงิน · ฿$price',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.accentText),
          ),
        ),
      ),
    );
  }

  String _monthName(int m) {
    const months = ['', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    return months[m];
  }
}
