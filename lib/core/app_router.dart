import 'package:go_router/go_router.dart';
import '../screens/shell/main_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/find/find_screen.dart';
import '../screens/find/place_detail_screen.dart';
import '../screens/find/booking_screen.dart';
import '../screens/find/booking_status_screen.dart';
import '../models/booking_model.dart';
import '../screens/mind/mind_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/music/music_screen.dart';
import '../screens/connect/connect_device_screen.dart';
import '../screens/profile/my_orders_screen.dart';
import '../screens/profile/device_settings_screen.dart';
import '../screens/profile/device_detail_screen.dart';
import '../screens/partner/partner_dashboard_screen.dart';
import '../screens/partner/partner_bookings_screen.dart';
import '../screens/partner/partner_machine_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/shop/product_detail_screen.dart';
import '../screens/shop/products_list_screen.dart';
import '../screens/music/healer_profile_screen.dart';
import '../screens/shop/cart_screen.dart';
import '../screens/shop/checkout_screen.dart';
import '../screens/shop/order_confirmed_screen.dart';
import '../screens/shop/order_error_screen.dart';
import '../models/product_model.dart';


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
        ]),
        // Tab 2 — Mind
        StatefulShellBranch(routes: [
          GoRoute(path: '/mind', builder: (_, _) => const MindScreen()),
        ]),
      ],
    ),

    // ── Profile (full-page, ไม่อยู่ใน shell) ──
    GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),

    // ── E-Commerce Flow ──
    GoRoute(
      path: '/products',
      builder: (_, _) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: 'category/:cat',
          builder: (_, state) {
            final catStr = state.pathParameters['cat']!;
            final cat = ProductCategory.values.firstWhere(
              (c) => c.name == catStr,
              orElse: () => ProductCategory.singingBowl,
            );
            return ProductsListScreen(filterCategory: cat);
          },
        ),
      ],
    ),
    GoRoute(path: '/product/:id', builder: (_, state) => ProductDetailScreen(productId: state.pathParameters['id']!)),
    GoRoute(
      path: '/connect',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final modeStr = extra['mode'] as String? ?? 'ownDevice';
        final mode = ConnectMode.values.firstWhere((m) => m.name == modeStr, orElse: () => ConnectMode.ownDevice);
        return ConnectDeviceScreen(mode: mode, bookingId: extra['bookingId'] as String?, venueId: extra['venueId'] as String?);
      },
    ),
    GoRoute(path: '/cart',            builder: (_, _) => const CartScreen()),
    GoRoute(path: '/checkout',        builder: (_, _) => const CheckoutScreen()),
    GoRoute(
      path: '/order-confirmed',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return OrderConfirmedScreen(
          orderId: extra['orderId'] as String? ?? 'ord1',
          total: (extra['total'] as num?)?.toDouble() ?? 0,
        );
      },
    ),
    GoRoute(path: '/order-error', builder: (_, state) {
      final extra = state.extra as Map<String, dynamic>? ?? {};
      return OrderErrorScreen(errorMessage: extra['errorMessage'] as String?);
    }),

    // ── Find & Booking Flow ──
    GoRoute(path: '/place/:id',    builder: (_, state) => PlaceDetailScreen(venueId: state.pathParameters['id']!)),
    GoRoute(path: '/booking/:id',  builder: (_, state) => BookingScreen(venueId: state.pathParameters['id']!)),
    GoRoute(
      path: '/booking-status',
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BookingStatusScreen(
          booking: extra['booking'] as BookingModel,
          venueName: extra['venueName'] as String,
        );
      },
    ),

    // ── Music & Mind Flow ──
    GoRoute(path: '/music',        builder: (_, state) => MusicScreen(deviceName: state.extra as String? ?? 'WeLLzen')),
    GoRoute(path: '/player',       builder: (_, _) => const PlayerScreen()),
    GoRoute(path: '/player/queue', builder: (_, _) => const PlayerScreen()),
    GoRoute(path: '/healer/:id',   builder: (_, state) => HealerProfileScreen(healerId: state.pathParameters['id']!)),

    // ── Profile & Partner Flow ──
    GoRoute(
      path: '/device-settings',
      builder: (_, _) => const DeviceSettingsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (_, state) => DeviceDetailScreen(deviceId: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(path: '/partner',            builder: (_, _) => const PartnerDashboardScreen()),
    GoRoute(path: '/partner/bookings',   builder: (_, _) => const PartnerBookingsScreen()),
    GoRoute(
      path: '/partner/machines',
      builder: (_, _) => const PartnerMachineScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (_, state) => DeviceDetailScreen(deviceId: state.pathParameters['id']!),
        ),
      ],
    ),

    // ── My Orders ──
    GoRoute(
      path: '/orders',
      builder: (_, state) {
        final raw = state.extra;
        final tab = raw is Map ? raw['tab'] as String? : null;
        return MyOrdersScreen(initialTab: tab == 'orders' ? 1 : 0);
      },
    ),
  ],
);
