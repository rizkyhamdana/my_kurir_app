import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_kurir_app/firebase_options.dart';
import 'package:my_kurir_app/util/session_manager.dart';
import 'package:my_kurir_app/util/theme_notifier.dart';
import 'routes/app_router.dart';

final themeNotifier = ThemeNotifier();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupFirebaseMessaging(); // ✅ Setup FCM aman Android/iOS

  await themeNotifier.initPrefs();

  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) => MainApp(themeMode: mode),
    ),
  );
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Minta izin notifikasi
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    if (Platform.isIOS || Platform.isMacOS) {
      final apnsToken = await messaging.getAPNSToken();
      print('📱 APNS Token: $apnsToken');

      // 💡 Jangan panggil getToken kalau APNS token belum tersedia
      if (apnsToken == null) {
        print('⏳ APNS belum siap, tunda getToken.');
        return;
      }
    }

    // ✅ Aman untuk ambil FCM Token
    final token = await messaging.getToken();
    print('📦 FCM Token: $token');

    if (token != null) {
      await SessionManager.saveFcmToken(token);

      final userId = await SessionManager.getUserId();
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'fcmToken': token},
        );
      }
    }

    // Listener saat token diperbarui
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await SessionManager.saveFcmToken(newToken);

      final userId = await SessionManager.getUserId();
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'fcmToken': newToken},
        );
      }
    });
  } else {
    print('🔒 Not authorized for notifications.');
  }
}

class MainApp extends StatelessWidget {
  final ThemeMode themeMode;
  const MainApp({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kurir Desa',
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF4A80F0),
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF4A80F0),
          secondary: const Color(0xFF4A80F0).withAlpha(170),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF4A80F0),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF4A80F0),
          secondary: const Color(0xFF4A80F0).withAlpha(170),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
