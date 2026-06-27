import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/shell/main_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/find/find_screen.dart';
import '../screens/find/find_machine_screen.dart';
import '../screens/mind/mind_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/music/music_screen.dart';

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text(name, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    // ── Navigation Shell: Bottom Nav (Home / Find / Mind) ──
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => MainShell(navigationShell: shell),
      branches: [
        // Tab 0 — Home
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        ]),
        // Tab 1 — Find (Place + Machine อยู่ใน branch เดียวกัน)
        StatefulShellBranch(routes: [
          GoRoute(path: '/find', builder: (_, _) => const FindScreen()),
          GoRoute(path: '/machine', builder: (_, _) => const FindMachineScreen()),
        ]),
        // Tab 2 — Mind
        StatefulShellBranch(routes: [
          GoRoute(path: '/mind', builder: (_, _) => const MindScreen()),
        ]),
      ],
    ),

    // ── Profile (full-page, ไม่อยู่ใน shell) ──
    GoRoute(path: '/profile', builder: (_, _) => const _PlaceholderScreen('14 Profile')),

    // ── E-Commerce Flow ──
    GoRoute(path: '/product/:id',       builder: (_, _) => const _PlaceholderScreen('05 Product Detail')),
    GoRoute(path: '/connect',           builder: (_, _) => const _PlaceholderScreen('06 Connect Device')),
    GoRoute(path: '/cart',              builder: (_, _) => const _PlaceholderScreen('07 Cart')),
    GoRoute(path: '/checkout',          builder: (_, _) => const _PlaceholderScreen('08 Checkout')),
    GoRoute(path: '/order-confirmed',   builder: (_, _) => const _PlaceholderScreen('09 Order Confirmed')),
    GoRoute(path: '/order-error',       builder: (_, _) => const _PlaceholderScreen('09b Order Error')),

    // ── Find & Booking Flow ──
    GoRoute(path: '/place/:id',         builder: (_, _) => const _PlaceholderScreen('10 Place Detail')),
    GoRoute(path: '/booking',           builder: (_, _) => const _PlaceholderScreen('11a Booking')),
    GoRoute(path: '/booking/pending',   builder: (_, _) => const _PlaceholderScreen('11d Booking Pending')),
    GoRoute(path: '/booking/confirmed', builder: (_, _) => const _PlaceholderScreen('11e Booking Confirmed')),
    GoRoute(path: '/booking/rejected',  builder: (_, _) => const _PlaceholderScreen('11f Booking Rejected')),

    // ── Music & Mind Flow ──
    GoRoute(path: '/music',        builder: (_, state) => MusicScreen(deviceName: state.extra as String? ?? 'WeLLzen')),
    GoRoute(path: '/player',       builder: (_, _) => const PlayerScreen()),
    GoRoute(path: '/player/queue', builder: (_, _) => const PlayerScreen()),
    GoRoute(path: '/healer/:id',   builder: (_, _) => const _PlaceholderScreen('13c Healer Profile')),

    // ── Profile & Partner Flow ──
    GoRoute(path: '/device-settings',    builder: (_, _) => const _PlaceholderScreen('15 Device Settings')),
    GoRoute(path: '/partner',            builder: (_, _) => const _PlaceholderScreen('16 Partner Dashboard')),
    GoRoute(path: '/partner/bookings',   builder: (_, _) => const _PlaceholderScreen('16b Booking Management')),
    GoRoute(path: '/partner/machines',   builder: (_, _) => const _PlaceholderScreen('17g Machine Management')),

    // ── My Orders ──
    GoRoute(path: '/orders', builder: (_, _) => const _PlaceholderScreen('18 My Orders')),
  ],
);
