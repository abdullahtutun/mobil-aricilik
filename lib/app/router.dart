import 'package:go_router/go_router.dart';
import 'package:mobil_aricilik/features/today/presentation/today_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const TodayScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
