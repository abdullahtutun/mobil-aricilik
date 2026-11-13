import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_session_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pocketbase_client_provider.g.dart';

/// Açılışta diskten okunan PocketBase oturumu ve okunduğu sunucu adresi.
typedef StoredPocketBaseSession = ({String serverUrl, String? data});

/// `bootstrap`, uygulama açılmadan önce okunan oturumla override eder
/// (`initializePocketBase`); okuma asenkron, istemci senkron kurulur.
/// Override edilmezse oturum yok.
@Riverpod(keepAlive: true)
StoredPocketBaseSession? storedPocketBaseSession(Ref ref) => null;

/// Oturumun ve bekleyen kod isteğinin güvenli deposu; anahtarlar sunucu
/// adresine özel.
@Riverpod(keepAlive: true)
PocketBaseSessionStorage pocketBaseSessionStorage(Ref ref) =>
    PocketBaseSessionStorage(ref.watch(pocketbaseUrlProvider));

/// Uygulamadaki tek PocketBase istemcisi. Yalnız data katmanındaki
/// servisler (auth, senkron) alır; ekranlar dokunmaz. Kayıtlı oturum
/// başka bir adresten okunduysa yüklenmez.
@Riverpod(keepAlive: true)
PocketBase pocketbaseClient(Ref ref) {
  final url = ref.watch(pocketbaseUrlProvider);
  final stored = ref.watch(storedPocketBaseSessionProvider);
  final client = PocketBase(
    url,
    authStore: ref
        .watch(pocketBaseSessionStorageProvider)
        .authStore(initial: stored?.serverUrl == url ? stored?.data : null),
  );
  ref.onDispose(client.close);
  return client;
}
