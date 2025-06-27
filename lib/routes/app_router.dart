import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_kurir_app/pages/auth/cubit/auth_cubit.dart';
import 'package:my_kurir_app/pages/auth/login_page.dart';
import 'package:my_kurir_app/pages/auth/register_page.dart';
import 'package:my_kurir_app/pages/history/cubit/history_cubit.dart';
import 'package:my_kurir_app/pages/history/history_page.dart';
import 'package:my_kurir_app/pages/kurir/history/cubit/kurir_history_cubit.dart';
import 'package:my_kurir_app/pages/kurir/history/kurir_history_page.dart';
import 'package:my_kurir_app/pages/kurir/home/cubit/kurir_home_cubit.dart';
import 'package:my_kurir_app/pages/kurir/home/kurir_home_page.dart';
import 'package:my_kurir_app/pages/kurir/profile/cubit/kurir_profile_cubit.dart';
import 'package:my_kurir_app/pages/kurir/profile/kurir_profile_page.dart';
import 'package:my_kurir_app/pages/kurir/tracking/cubit/kurir_tracking_cubit.dart';
import 'package:my_kurir_app/pages/kurir/tracking/kurir_tracking_page.dart';
import 'package:my_kurir_app/pages/onboarding/onboarding_page.dart';
import 'package:my_kurir_app/pages/order/cubit/order_cubit.dart';
import 'package:my_kurir_app/pages/profile/cubit/profile_cubit.dart';
import 'package:my_kurir_app/pages/tracking/cubit/tracking_cubit.dart';
import 'package:my_kurir_app/routes/route_logger.dart';
import '../pages/splashscreen/splashscreen_page.dart';
import '../pages/home/home_page.dart';
import '../pages/order/order_page.dart';
import '../pages/order/pick_location_page.dart';
import '../pages/tracking/tracking_page.dart';
import '../pages/profile/profile_page.dart';
import '../models/order_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    observers: [RouteLogger()],
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreenPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => BlocProvider(
          create: (_) => AuthCubit(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            BlocProvider(create: (_) => AuthCubit(), child: const LoginPage()),
      ),
      GoRoute(path: '/', redirect: (context, state) => '/home'),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/history',
        builder: (context, state) => BlocProvider(
          create: (context) => HistoryCubit(),
          child: const HistoryPage(),
        ),
      ),
      GoRoute(
        path: '/order',
        builder: (context, state) => BlocProvider(
          create: (context) => OrderCubit(),
          child: const OrderPage(),
        ),
      ),
      GoRoute(
        path: '/pick-location',
        builder: (context, state) => const PickLocationPage(),
      ),
      GoRoute(
        path: '/tracking',
        builder: (context, state) {
          final orderData = state.extra as OrderModel?;
          return BlocProvider(
            create: (context) => TrackingCubit(),
            child: TrackingPage(orderData: orderData),
          );
        },
      ),
      GoRoute(
        path: '/kurir-home',
        builder: (context, state) => BlocProvider(
          create: (context) => KurirHomeCubit(),
          child: const KurirHomePage(),
        ),
      ),
      GoRoute(
        path: '/kurir-tracking',
        builder: (context, state) => BlocProvider(
          create: (_) => KurirTrackingCubit(),
          child: const KurirTrackingPage(),
        ),
      ),
      GoRoute(
        path: '/kurir-history',
        builder: (context, state) => BlocProvider(
          create: (context) => KurirHistoryCubit(),
          child: const KurirHistoryPage(),
        ),
      ),
      GoRoute(
        path: '/kurir-profile',
        builder: (context, state) => BlocProvider(
          create: (context) => KurirProfileCubit(),
          child: const KurirProfilePage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileCubit(),
          child: const ProfilePage(),
        ),
      ),
    ],
  );
}
