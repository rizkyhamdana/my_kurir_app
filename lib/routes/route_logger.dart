import 'package:flutter/widgets.dart';

class RouteLogger extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint(
      '[ROUTE] Navigasi ke: ${route.settings.name ?? route.settings.arguments ?? route}',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint(
      '[ROUTE] Kembali ke: ${previousRoute?.settings.name ?? previousRoute?.settings.arguments ?? previousRoute}',
    );
  }
}
