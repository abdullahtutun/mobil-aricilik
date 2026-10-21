import 'package:go_router/go_router.dart';
import 'package:mobil_aricilik/app/deep_link.dart';
import 'package:mobil_aricilik/app/flavor.dart';
import 'package:mobil_aricilik/app/routes.dart';
import 'package:mobil_aricilik/app/shell/app_shell.dart';
import 'package:mobil_aricilik/app/shell/more_screen.dart';
import 'package:mobil_aricilik/app/shell/scan_screen.dart';
import 'package:mobil_aricilik/core/design_system/gallery/component_gallery_screen.dart';
import 'package:mobil_aricilik/features/apiaries/presentation/apiaries_screen.dart';
import 'package:mobil_aricilik/features/settings/presentation/country_picker_screen.dart';
import 'package:mobil_aricilik/features/settings/presentation/developer_menu_screen.dart';
import 'package:mobil_aricilik/features/settings/presentation/settings_screen.dart';
import 'package:mobil_aricilik/features/tasks/presentation/tasks_screen.dart';
import 'package:mobil_aricilik/features/today/presentation/today_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final isDev = ref.watch(flavorProvider) == Flavor.dev;
  final router = GoRouter(
    // `mobilaricilik://x/y` → `/x/y`; uygulama içi konumlara dokunmaz.
    redirect: (context, state) => deepLinkLocation(state.uri),
    // Eşleşmeyen konum (henüz hedefi olmayan derin linkler dahil) hata
    // sayfası yerine Bugün'e düşer.
    onException: (context, state, router) => router.go(AppRoutes.today),
    routes: [
      // Dal sırası AppTab sırasıyla aynı olmalı.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
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
                          builder: (context, state) =>
                              const ComponentGalleryScreen(),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.apiaries,
                builder: (context, state) => const ApiariesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (context, state) => const MoreScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                    routes: [
                      GoRoute(
                        path: 'country',
                        builder: (context, state) =>
                            const CountryPickerScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Kabuğun dışında: sekmelerin ve alt gezinmenin üstünde açılır.
      GoRoute(
        path: AppRoutes.scan,
        builder: (context, state) => const ScanScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
