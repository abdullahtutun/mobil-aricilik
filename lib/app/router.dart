import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/auth_redirect.dart';
import 'package:mobil_arici/app/deep_link.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_shell.dart';
import 'package:mobil_arici/app/shell/more_screen.dart';
import 'package:mobil_arici/app/shell/scan_screen.dart';
import 'package:mobil_arici/core/design_system/gallery/component_gallery_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiaries_screen.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_code_screen.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_controller.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/settings/presentation/country_picker_screen.dart';
import 'package:mobil_arici/features/settings/presentation/developer_menu_screen.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';
import 'package:mobil_arici/features/tasks/presentation/tasks_screen.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final isDev = ref.watch(flavorProvider) == Flavor.dev;

  // Router yeniden kurulmasın (sekme yığınları kaybolur); oturum değişince
  // yalnız yönlendirme yeniden değerlendirilir.
  final signedIn = ValueNotifier(ref.read(currentUserProvider) != null);
  ref
    ..listen(currentUserProvider, (_, user) => signedIn.value = user != null)
    ..onDispose(signedIn.dispose);

  final router = GoRouter(
    refreshListenable: signedIn,
    // Önce `mobilarici://x/y` → `/x/y` (uygulama içi konumlara dokunmaz);
    // router yeni konumla yeniden çağırınca oturum kapısı uygulanır.
    redirect: (context, state) =>
        deepLinkLocation(state.uri) ??
        authRedirect(signedIn: signedIn.value, path: state.uri.path),
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
      // Kabuğun dışında: çıkışta sekme yığınları da kapanır, sonraki
      // kullanıcı öncekinin ekranlarını görmez.
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInEmailScreen(),
        routes: [
          GoRoute(
            path: 'code',
            // Kod gönderilmeden (ör. derin linkle) gelinirse e-postaya dön.
            redirect: (context, state) =>
                ref.read(signInControllerProvider).email == null
                ? AppRoutes.signIn
                : null,
            builder: (context, state) => const SignInCodeScreen(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
