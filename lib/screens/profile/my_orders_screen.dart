import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/booking_model.dart';
import '../../models/order_model.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late bool _isBookingTab;

  final _bookings = MockData.bookingsByUser('u1');
  final _orders = MockData.orders.where((o) => o.userId == 'u1').toList();

  @override
  void initState() {
    super.initState();
    _isBookingTab = widget.initialTab == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTabToggle(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isBookingTab ? _buildBookingList() : _buildOrderList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.canPop() ? context.pop() : context.go('/home'),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back, size: 21, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'คำสั่งซื้อของฉัน',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3DE),
        border: Border.all(color: AppColors.accentBorder),
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _tabItem('การจอง', true),
          _tabItem('คำสั่งซื้อ', false),
        ],
      ),
    );
  }

  Widget _tabItem(String label, bool isBooking) {
    final active = _isBookingTab == isBooking;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isBookingTab = isBooking),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              color: active ? AppColors.accentText : const Color(0xFF444444),
            ),
          ),
        ),
      ),
    );
  }

  // ── Booking List ─────────────────────────────────────────────────
  Widget _buildBookingList() {
    if (_bookings.isEmpty) return _emptyState('ยังไม่มีการจอง');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _bookings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildBookingCard(_bookings[i]),
    );
  }

  Widget _buildBookingCard(BookingModel b) {
    final venue = MockData.venueById(b.venueId);
    final statusConfig = _bookingStatusConfig(b.status);
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
                    Text(venue?.name ?? 'สถานที่', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text(venue?.address ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: statusConfig.$3, borderRadius: BorderRadius.circular(999)),
                child: Text(statusConfig.$1, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusConfig.$2)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFE3EFF4), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              _bookingInfo(Icons.calendar_today, _formatDate(b.date)),
              const SizedBox(width: 16),
              _bookingInfo(Icons.schedule, '${b.startTime} · ${b.durationMinutes} นาที'),
              const Spacer(),
              Text('฿${b.price.toInt()}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bookingInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primaryMid),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  (String, Color, Color) _bookingStatusConfig(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:
        return ('รอยืนยัน', AppColors.accentText, AppColors.accentGold);
      case BookingStatus.confirmed:
        return ('ยืนยันแล้ว', const Color(0xFF2E7D32), const Color(0xFFEEF8EE));
      case BookingStatus.cancelled:
        return ('ยกเลิกแล้ว', const Color(0xFFB3261E), const Color(0xFFFCEBEB));
      case BookingStatus.completed:
        return ('เสร็จสิ้น', AppColors.textSecondary, const Color(0xFFF5F5F5));
    }
  }

  // ── Order List ───────────────────────────────────────────────────
  Widget _buildOrderList() {
    if (_orders.isEmpty) return _emptyState('ยังไม่มีคำสั่งซื้อ');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildOrderCard(_orders[i]),
    );
  }

  Widget _buildOrderCard(OrderModel o) {
    final statusConfig = _orderStatusConfig(o.status);
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
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.shopping_bag, size: 22, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('คำสั่งซื้อ #${o.id.toUpperCase()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text('${o.items.length} รายการ · ${_formatDate(o.createdAt)}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: statusConfig.$3, borderRadius: BorderRadius.circular(999)),
                child: Text(statusConfig.$1, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusConfig.$2)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFE3EFF4), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.primaryMid),
              const SizedBox(width: 4),
              Expanded(
                child: Text(o.shippingAddress, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ),
              const SizedBox(width: 12),
              Text('฿${o.total.toInt()}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  (String, Color, Color) _orderStatusConfig(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return ('รอชำระ', AppColors.accentText, AppColors.accentGold);
      case OrderStatus.paid:
        return ('ชำระแล้ว', const Color(0xFF2E7D32), const Color(0xFFEEF8EE));
      case OrderStatus.shipped:
        return ('จัดส่งแล้ว', AppColors.primaryDark, AppColors.primaryLight);
      case OrderStatus.delivered:
        return ('ได้รับแล้ว', const Color(0xFF2E7D32), const Color(0xFFEEF8EE));
      case OrderStatus.cancelled:
        return ('ยกเลิกแล้ว', const Color(0xFFB3261E), const Color(0xFFFCEBEB));
    }
  }

  Widget _emptyState(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    return '${d.day} ${months[d.month]} ${d.year + 543}';
  }
}
