import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/venue_model.dart';
import '../../widgets/cards/venue_card.dart';

class FindMachineScreen extends StatefulWidget {
  const FindMachineScreen({super.key});

  @override
  State<FindMachineScreen> createState() => _FindMachineScreenState();
}

class _FindMachineScreenState extends State<FindMachineScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<VenueModel> get _filtered {
    if (_query.isEmpty) return MockData.venues;
    final q = _query.toLowerCase();
    return MockData.venues
        .where((v) =>
            v.name.toLowerCase().contains(q) ||
            v.address.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 14),
                  _FindToggle(isPlaceActive: false),
                  const SizedBox(height: 14),
                  _buildSearchBar(),
                ],
              ),
            ),
            const _MapPlaceholder(),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'ไม่พบเครื่อง',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final venue = _filtered[i];
                        return VenueCard(
                          venue: venue,
                          onTap: () => context.push('/place/${venue.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'ค้นหา',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
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

  Widget _buildSearchBar() {
    return Container(
      height: 44,
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
                hintText: 'ค้นหาเครื่อง WeLLzen...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// ─── Internal Widgets ─────────────────────────────────────────────────────────

class _FindToggle extends StatelessWidget {
  const _FindToggle({required this.isPlaceActive});
  final bool isPlaceActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _tab(context, 'ค้นหาสถานที่', isPlaceActive, () {
            if (!isPlaceActive) context.go('/find');
          }),
          const SizedBox(width: 4),
          _tab(context, 'ค้นหาเครื่อง', !isPlaceActive, () {
            if (isPlaceActive) context.go('/machine');
          }),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 30, color: AppColors.primaryMid),
            SizedBox(height: 6),
            Text(
              'แผนที่',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
