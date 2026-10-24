import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/features/auth/data/auth_service.dart';
import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) =>
    SupabaseAuthService(ref.watch(supabaseClientProvider).auth);

/// Oturumdaki kullanıcı; null ise giriş yapılmamış. Çevrimdışıyken süresi
/// dolan token oturumu kapatmaz, yalnız sunucu refresh token'ı reddederse
/// ya da kullanıcı çıkış yaparsa null olur.
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  AppUser? build() {
    final service = ref.watch(authServiceProvider);
    final subscription = service.userChanges.listen((user) => state = user);
    ref.onDispose(subscription.cancel);
    return service.currentUser;
  }

  Future<void> signOut() => ref.read(authServiceProvider).signOut();
}
