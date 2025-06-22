import 'package:go_router/go_router.dart';
import 'package:my_kurir_app/pages/auth/login_page.dart';
import 'package:my_kurir_app/pages/auth/register_page.dart';
import 'package:my_kurir_app/pages/history/history_page.dart';
import 'package:my_kurir_app/pages/kurir/kurir_history_page.dart';
import 'package:my_kurir_app/pages/kurir/kurir_home_page.dart';
import 'package:my_kurir_app/pages/kurir/kurir_profile_page.dart';
import 'package:my_kurir_app/pages/kurir/kurir_tracking_page.dart';
import 'package:my_kurir_app/pages/onboarding/onboarding_page.dart';
import '../pages/splashscreen/splashscreen_page.dart';
import '../pages/home/home_page.dart';
import '../pages/order/order_page.dart';
import '../pages/order/pick_location_page.dart';
import '../pages/profile/tracking_page.dart';
import '../pages/tracking/profile_page.dart';
import '../models/order_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreenPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(path: '/', redirect: (context, state) => '/home'),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(path: '/order', builder: (context, state) => const OrderPage()),
      GoRoute(
        path: '/pick-location',
        builder: (context, state) => const PickLocationPage(),
      ),
      GoRoute(
        path: '/tracking',
        builder: (context, state) {
          final orderData = state.extra as OrderModel?;
          return TrackingPage(orderData: orderData);
        },
      ),
      GoRoute(
        path: '/kurir-home',
        builder: (context, state) => const KurirHomePage(),
      ),
      GoRoute(
        path: '/kurir-tracking',
        builder: (context, state) => const KurirTrackingPage(),
      ),
      GoRoute(
        path: '/kurir-history',
        builder: (context, state) => const KurirHistoryPage(),
      ),
      GoRoute(
        path: '/kurir-profile',
        builder: (context, state) => const KurirProfilePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
