import 'package:go_router/go_router.dart';
import 'package:mobil_aricilik/app/flavor.dart';
import 'package:mobil_aricilik/app/routes.dart';
import 'package:mobil_aricilik/core/design_system/gallery/component_gallery_screen.dart';
import 'package:mobil_aricilik/features/settings/presentation/developer_menu_screen.dart';
import 'package:mobil_aricilik/features/today/presentation/today_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final isDev = ref.watch(flavorProvider) == Flavor.dev;
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.today,
        builder: (context, state) => const TodayScreen(),
        routes: [
          // Prod'da bu rotalar hiç yok; derin linkle de açılamaz.
          if (isDev)
            GoRoute(
              path: 'dev',
              builder: (context, state) => const DeveloperMenuScreen(),
              routes: [
                GoRoute(
                  path: 'components',
                  builder: (context, state) => const ComponentGalleryScreen(),
                ),
              ],
            ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
