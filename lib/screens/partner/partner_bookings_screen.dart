import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';

enum _BookingTab { pending, confirmed, awaitingPayment }

class PartnerBookingsScreen extends StatefulWidget {
  const PartnerBookingsScreen({super.key});

  @override
  State<PartnerBookingsScreen> createState() => _PartnerBookingsScreenState();
}

class _PartnerBookingsScreenState extends State<PartnerBookingsScreen> {
  _BookingTab _tab = _BookingTab.pending;

  // Mock bookings for partner view
  final List<_PartnerBooking> _pending = [
    _PartnerBooking('สมศรี ดีมาก', '45 นาที · ฿100 · WeLLzen #2', 'วันนี้ 14:00', _BookingTab.pending),
    _PartnerBooking('อัจฉรา มีสุข', '30 นาที · ฿70 · WeLLzen #1', 'วันนี้ 15:30', _BookingTab.pending),
    _PartnerBooking('ปรีดา วงษ์ทอง', '60 นาที · ฿130 · WeLLzen #3', 'พรุ่งนี้ 09:00', _BookingTab.pending),
  ];

  final List<_PartnerBooking> _confirmed = [
    _PartnerBooking('วีระ สุขสันต์', '60 นาที · ฿130 · WeLLzen #1', 'วันนี้ 16:00', _BookingTab.confirmed),
    _PartnerBooking('ธนา ก้องเกียรติ', '30 นาที · ฿70 · WeLLzen #3', 'วันนี้ 18:30', _BookingTab.confirmed),
  ];

  final List<_PartnerBooking> _awaitingPayment = [
    _PartnerBooking('กิตติ มั่นคง', '45 นาที · ฿100 · WeLLzen #2 · วันนี้ 16:00', 'เหลือ 09:42', _BookingTab.awaitingPayment),
    _PartnerBooking('สุดา รักษ์ดี', '30 นาที · ฿70 · WeLLzen #1 · วันนี้ 17:30', 'เหลือ 04:15', _BookingTab.awaitingPayment),
  ];

  List<_PartnerBooking> get _currentList {
    switch (_tab) {
      case _BookingTab.pending: return _pending;
      case _BookingTab.confirmed: return _confirmed;
      case _BookingTab.awaitingPayment: return _awaitingPayment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTabToggle(),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back, size: 21, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 12),
          const Text('จัดการจอง', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3F8),
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _tabItem('รอยืนยัน · ${_pending.length}', _BookingTab.pending),
          _tabItem('ยืนยันแล้ว', _BookingTab.confirmed),
          _tabItem('รอชำระ · ${_awaitingPayment.length}', _BookingTab.awaitingPayment),
        ],
      ),
    );
  }

  Widget _tabItem(String label, _BookingTab tab) {
    final active = _tab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = tab),
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
              fontSize: 12,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              color: active ? AppColors.accentText : const Color(0xFF444444),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    final items = _currentList;
    if (items.isEmpty) {
      return const Center(child: Text('ไม่มีรายการ', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final b = items[i];
        return switch (_tab) {
          _BookingTab.pending => _buildPendingCard(b, i),
          _BookingTab.confirmed => _buildConfirmedCard(b),
          _BookingTab.awaitingPayment => _buildAwaitingCard(b),
        };
      },
    );
  }

  // ── Pending card: ปฏิเสธ + ยืนยันคิว ────────────────────────────
  Widget _buildPendingCard(_PartnerBooking b, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.accentBorder, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.person, size: 22, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 1),
                    Text(b.detail, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 13, color: AppColors.primaryDark),
                        const SizedBox(width: 4),
                        Text(b.timeInfo, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _reject(index),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEAD3D1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text('ปฏิเสธ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFB3261E))),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _confirm(index),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      border: Border.all(color: AppColors.accentBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 18, color: AppColors.accentText),
                        SizedBox(width: 6),
                        Text('ยืนยันคิว', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accentText)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Confirmed card ────────────────────────────────────────────────
  Widget _buildConfirmedCard(_PartnerBooking b) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.person, size: 22, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 1),
                Text(b.detail, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 1),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 13, color: AppColors.primaryDark),
                    const SizedBox(width: 4),
                    Text(b.timeInfo, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(999)),
            child: const Text('ยืนยันแล้ว', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF3B6D11))),
          ),
        ],
      ),
    );
  }

  // ── Awaiting payment card ─────────────────────────────────────────
  Widget _buildAwaitingCard(_PartnerBooking b) {
    final isUrgent = b.timeInfo.contains('04');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.person, size: 22, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 1),
                    Text(b.detail, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(b.timeInfo.replaceAll('เหลือ ', ''),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isUrgent ? const Color(0xFF854F0B) : AppColors.textPrimary)),
                  const Text('เหลือเวลา', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFFFAEEDA) : const Color(0xFFEEF8EE),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(isUrgent ? Icons.warning : Icons.schedule,
                  size: 15,
                  color: isUrgent ? const Color(0xFF854F0B) : const Color(0xFF2E7D32)),
                const SizedBox(width: 8),
                Text(
                  isUrgent ? 'ใกล้หมดเวลา · ลูกค้ายังไม่ชำระ' : 'ยืนยันคิวแล้ว · รอลูกค้าชำระ',
                  style: TextStyle(fontSize: 11, color: isUrgent ? const Color(0xFF854F0B) : const Color(0xFF2E7D32)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirm(int index) {
    final item = _pending[index];
    setState(() {
      _pending.removeAt(index);
      _confirmed.insert(0, _PartnerBooking(item.name, item.detail, item.timeInfo, _BookingTab.confirmed));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ยืนยัน ${item.name} แล้ว'), duration: const Duration(seconds: 2)),
    );
  }

  void _reject(int index) {
    final item = _pending[index];
    setState(() => _pending.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ปฏิเสธ ${item.name} แล้ว'), duration: const Duration(seconds: 2)),
    );
  }
}

class _PartnerBooking {
  final String name;
  final String detail;
  final String timeInfo;
  final _BookingTab status;

  _PartnerBooking(this.name, this.detail, this.timeInfo, this.status);
}
