import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/device_provider.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/cards/booking_summary_card.dart';
import '../../widgets/tiles/device_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<BookingProvider>().loadBookings(user.id);
        context.read<DeviceProvider>().loadDevices(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 18),
              _buildProductSection(context),
              const SizedBox(height: 18),
              _buildDeviceSection(context),
              const SizedBox(height: 18),
              _buildBookingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'weLLtion',
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
            child: const Icon(Icons.person_outline, color: AppColors.primaryDark, size: 21),
          ),
        ),
      ],
    );
  }

  // ─── Products ───────────────────────────────────────────────────────────────

  Widget _buildProductSection(BuildContext context) {
    final products = MockData.products.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionRow(
          title: 'เลือกชมสินค้า',
          onSeeAll: () => context.push('/product/${products.first.id}'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProductCard(
                product: products[0],
                badge: 'ขายดี',
                onTap: () => context.push('/product/${products[0].id}'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProductCard(
                product: products[1],
                onTap: () => context.push('/product/${products[1].id}'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Devices ────────────────────────────────────────────────────────────────

  Widget _buildDeviceSection(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (_, deviceProvider, _) {
        final devices = deviceProvider.userDevices;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'อุปกรณ์ของฉัน',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 11),
            Column(
              children: [
                ...devices.map((device) {
                  final name = MockData.productById(device.productId)?.name ?? 'WeLLzen';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: DeviceListTile(
                      device: device,
                      productName: name,
                      onTap: () => context.push('/music', extra: name),
                    ),
                  );
                }),
                _ConnectButton(onTap: () => context.push('/connect')),
              ],
            ),
          ],
        );
      },
    );
  }

  // ─── Booking ────────────────────────────────────────────────────────────────

  Widget _buildBookingSection(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (_, bookingProvider, _) {
        final upcoming = bookingProvider.upcoming;
        if (upcoming.isEmpty) return const SizedBox.shrink();

        final next = upcoming.first;
        final venueName = MockData.venueById(next.venueId)?.name ?? '—';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'การจองของฉัน',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 11),
            BookingSummaryCard(
              booking: next,
              venueName: venueName,
              onTap: () => context.push('/booking/pending'),
            ),
          ],
        );
      },
    );
  }
}

// ─── Internal Widgets ─────────────────────────────────────────────────────────

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.title, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Row(
              children: const [
                Text(
                  'ดูทั้งหมด',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryDark),
                ),
                Icon(Icons.chevron_right, size: 15, color: AppColors.primaryDark),
              ],
            ),
          ),
      ],
    );
  }
}

class _ConnectButton extends StatelessWidget {
  const _ConnectButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner_outlined, size: 19, color: AppColors.primaryDark),
              SizedBox(width: 7),
              Text(
                'เชื่อมต่ออุปกรณ์',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.sky
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const radius = 16.0;
    const dash = 6.0;
    const gap = 4.0;

    final rect = Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final end = math.min(d + dash, metric.length);
        canvas.drawPath(metric.extractPath(d, end), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter _) => false;
}