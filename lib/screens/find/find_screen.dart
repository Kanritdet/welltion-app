import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/machine_model.dart';
import '../../models/mock_data.dart';
import '../../models/venue_model.dart';

class FindScreen extends StatefulWidget {
  const FindScreen({super.key});

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  bool _isPlaceTab = true;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<VenueModel> get _filteredVenues {
    if (_query.isEmpty) return MockData.venues;
    final q = _query.toLowerCase();
    return MockData.venues
        .where((v) =>
            v.name.toLowerCase().contains(q) ||
            v.address.toLowerCase().contains(q))
        .toList();
  }

  int _availableMachines(String venueName) => MockData.machines
      .where((m) => m.venueName == venueName && m.status == MachineStatus.available)
      .length;

  int _totalMachines(String venueName) =>
      MockData.machines.where((m) => m.venueName == venueName).length;

  void _switchTab(bool isPlace) {
    setState(() {
      _isPlaceTab = isPlace;
      _query = '';
      _searchCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFixedHeader(),
            if (_isPlaceTab) const _MapPlaceholder(),
            Expanded(
              child: _isPlaceTab ? _buildPlaceBody() : _buildMachineBody(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Fixed header: title + subtitle + toggle + (machine: search bar) ──
  Widget _buildFixedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ค้นหา weLLtion',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isPlaceTab
                          ? 'สถานที่ใกล้คุณและพร้อมให้บริการ'
                          : 'พิมพ์ชื่อสถานที่ปลายทาง เพื่อดูว่ามีเครื่องให้บริการไหม',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_outline, color: AppColors.primaryDark, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildTabToggle(),
          if (!_isPlaceTab) ...[
            const SizedBox(height: 12),
            _buildSearchBar(),
          ],
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3F8),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _tabItem('ค้นหาสถานที่', true),
          const SizedBox(width: 4),
          _tabItem('ค้นหาเครื่อง', false),
        ],
      ),
    );
  }

  Widget _tabItem(String label, bool isPlace) {
    final active = _isPlaceTab == isPlace;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchTab(isPlace),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.accentText : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'พิมพ์ชื่อสถานที่ปลายทาง...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() {
                _query = '';
                _searchCtrl.clear();
              }),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.close, size: 16, color: AppColors.textMuted),
              ),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }

  // ── Tab 1: ค้นหาสถานที่ ──────────────────────────────────────────
  Widget _buildPlaceBody() {
    final venues = MockData.venues;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: venues.length + 1,
      separatorBuilder: (_, i) => i == 0 ? const SizedBox.shrink() : const SizedBox(height: 10),
      itemBuilder: (context, i) {
        if (i == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'สถานที่ใกล้คุณ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          );
        }
        final venue = venues[i - 1];
        return _buildPlaceCard(venue);
      },
    );
  }

  Widget _buildPlaceCard(VenueModel venue) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x100E3D6E), blurRadius: 12, offset: Offset(0, 3))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64, height: 64,
                  child: venue.photos.isNotEmpty
                      ? Image.network(venue.photos.first, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imagePlaceholder())
                      : _imagePlaceholder(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(venue.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text('${venue.distanceKm} กม.',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 10),
                        const Icon(Icons.star_rounded, size: 13, color: AppColors.amber),
                        const SizedBox(width: 2),
                        Text(venue.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(venue.priceInfo,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/place/${venue.id}'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'ดูรายละเอียด',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.accentText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab 2: ค้นหาเครื่อง ──────────────────────────────────────────
  Widget _buildMachineBody() {
    if (_query.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'พิมพ์ชื่อสถานที่เพื่อค้นหา\nเครื่อง weLLzen ใกล้เคียง',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.6),
          ),
        ),
      );
    }

    final venues = _filteredVenues;
    if (venues.isEmpty) {
      return const Center(
        child: Text('ไม่พบสถานที่', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
      );
    }

    final destination = venues.first;
    final nearby = venues.skip(1).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _buildSectionLabel('สถานที่ปลายทางของคุณ'),
        const SizedBox(height: 10),
        _buildDestinationCard(destination),
        if (nearby.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionLabel('บริการเดียวกันใกล้เคียง'),
          const SizedBox(height: 10),
          ...nearby.map(_buildNearbyCard),
        ],
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
    );
  }

  Widget _buildDestinationCard(VenueModel venue) {
    final available = _availableMachines(venue.name);
    final total = _totalMachines(venue.name);
    final hasService = available > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x100E3D6E), blurRadius: 12, offset: Offset(0, 3))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64, height: 64,
                  child: venue.photos.isNotEmpty
                      ? Image.network(venue.photos.first, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imagePlaceholder())
                      : _imagePlaceholder(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(venue.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text('${venue.distanceKm} กม.',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 10),
                        const Icon(Icons.star_rounded, size: 13, color: AppColors.amber),
                        const SizedBox(width: 2),
                        Text(venue.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(venue.priceInfo,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                    const SizedBox(height: 6),
                    _buildAvailabilityBadge(available, total, showServiceLabel: hasService),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/booking/${venue.id}'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'จองเครื่องที่นี่',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accentText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(VenueModel venue) {
    final available = _availableMachines(venue.name);
    final total = _totalMachines(venue.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x100E3D6E), blurRadius: 12, offset: Offset(0, 3))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64, height: 64,
                  child: venue.photos.isNotEmpty
                      ? Image.network(venue.photos.first, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imagePlaceholder())
                      : _imagePlaceholder(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(venue.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text('${venue.distanceKm} กม.',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 10),
                        const Icon(Icons.star_rounded, size: 13, color: AppColors.amber),
                        const SizedBox(width: 2),
                        Text(venue.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(venue.priceInfo,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                    const SizedBox(height: 6),
                    _buildAvailabilityBadge(available, total),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/place/${venue.id}'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'ดูรายละเอียด',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.accentText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityBadge(int available, int total, {bool showServiceLabel = false}) {
    final hasAny = available > 0;
    final bg = hasAny ? AppColors.successLight : AppColors.errorLight;
    final fg = hasAny ? AppColors.successDark : AppColors.errorDark;
    final icon = hasAny ? Icons.check_circle_outline : Icons.cancel_outlined;
    final label = showServiceLabel
        ? 'มีบริการ · เครื่องว่าง $available/$total'
        : 'เครื่องว่าง $available/$total';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.primaryLight,
      child: const Center(child: Icon(Icons.store_outlined, size: 24, color: AppColors.primaryMid)),
    );
  }
}

// ── Map Placeholder (Tab 1 only) ──────────────────────────────────
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFDCEEF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA8D4E8), style: BorderStyle.solid, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Center(
                child: Icon(Icons.map_outlined, size: 24, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 8),
            const Text('แผนที่', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
