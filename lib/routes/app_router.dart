import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:my_kurir_app/pages/order/pick_location_page.dart';
import 'package:my_kurir_app/pages/profile/tracking_page.dart';
import 'package:my_kurir_app/pages/splashscreen/splashscreen_page.dart';
import 'package:my_kurir_app/pages/tracking/profile_page.dart';
import '../pages/home/home_page.dart';
import '../pages/order/order_page.dart';
import '../models/order_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home Route
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SplashScreenPage(),
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 1000),
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Order Route
      GoRoute(
        path: '/order',
        name: 'order',
        builder: (context, state) => const OrderPage(),
      ),

      // Tracking Route
      GoRoute(
        path: '/tracking',
        name: 'tracking',
        builder: (context, state) {
          final orderData = state.extra as OrderModel?;
          return TrackingPage(orderData: orderData);
        },
      ),
      GoRoute(
        path: '/pick-location',
        name: 'pick-location',
        builder: (context, state) => const PickLocationPage(),
      ),
      // Profile Route
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Halaman tidak ditemukan: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
}
