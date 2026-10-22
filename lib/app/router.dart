import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/deep_link.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/session_redirect.dart';
import 'package:mobil_arici/app/shell/app_shell.dart';
import 'package:mobil_arici/app/shell/more_screen.dart';
import 'package:mobil_arici/app/shell/scan_screen.dart';
import 'package:mobil_arici/core/design_system/gallery/component_gallery_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiaries_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_screen.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_code_screen.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_controller.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/first_apiary_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/setup_in_progress.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/settings/presentation/developer_menu_screen.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';
import 'package:mobil_arici/features/tasks/presentation/tasks_screen.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

const _apiaryId = 'apiaryId';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final isDev = ref.watch(flavorProvider) == Flavor.dev;

  // Router yeniden kurulmasın (sekme yığınları kaybolur); oturum, işletme
  // ya da kurulum değişince yalnız yönlendirme yeniden değerlendirilir.
  SessionStage stage() => sessionStageOf(
    signedIn: ref.read(currentUserProvider) != null,
    hasOrganization: ref.read(currentOrganizationProvider).value != null,
    settingUp: ref.read(setupInProgressProvider),
  );
  final session = ValueNotifier(stage());
  ref
    ..listen(currentUserProvider, (_, _) => session.value = stage())
    ..listen(currentOrganizationProvider, (_, _) => session.value = stage())
    ..listen(setupInProgressProvider, (_, _) => session.value = stage())
    ..onDispose(session.dispose);

  final router = GoRouter(
    refreshListenable: session,
    // Önce `mobilarici://x/y` → `/x/y` (uygulama içi konumlara dokunmaz);
    // router yeni konumla yeniden çağırınca oturum kapısı uygulanır.
    redirect: (context, state) =>
        deepLinkLocation(state.uri) ??
        sessionRedirect(stage: session.value, location: state.uri),
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
                routes: [
                  // `:apiaryId`'den önce; "new" kimlik sanılmasın.
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const ApiaryFormScreen(),
                  ),
                  GoRoute(
                    path: ':$_apiaryId',
                    builder: (context, state) => ApiaryDetailScreen(
                      apiaryId: state.pathParameters[_apiaryId]!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => ApiaryFormScreen(
                          apiaryId: state.pathParameters[_apiaryId],
                        ),
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
      // Kabuğun dışında: işletme kurulana kadar sekmeler yok.
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingApiary,
        builder: (context, state) => const FirstApiaryScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
