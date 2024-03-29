import 'package:audiobook/core/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: AudiobooksRoute.page, path: "/audiobooks", initial: true),
        AutoRoute(page: AudiobookPlayerRoute.page, path: "/audiobook_player"),
      ];
}
