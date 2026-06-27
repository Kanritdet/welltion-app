import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/player_provider.dart';
import 'providers/device_provider.dart';

void main() {
  runApp(const WelltionApp());
}

class WelltionApp extends StatelessWidget {
  const WelltionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ],
      child: MaterialApp.router(
        title: 'weLLtion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
