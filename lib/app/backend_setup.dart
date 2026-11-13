import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/pocketbase_setup.dart';
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/sync_transport.dart';

/// Arka plan görevinin sunucuya gittiği arayüzler. `refreshSession`
/// senkron turunun başında token'ı yeniler (K-6).
typedef BackgroundConnection = ({
  SyncTransport sync,
  FileStore files,
  Future<void> Function() refreshSession,
});

/// Uygulama açılırken sunucu istemcisini hazırlar; ağı beklemez. Dönen
/// override'lar uygulamanın provider kabına eklenir.
Future<List<Override>> initializeBackend(Flavor flavor) =>
    initializePocketBase(flavor);

/// Senkronun bağlandığı sunucunun kimliği, `pocketbase|<adres>`; değişirse
/// (ör. dev ↔ prod, `PB_URL`) yerel imleçler sıfırlanır
/// (`resetCursorsIfBackendChanged`). Ön ek, Supabase'den geçişte yazılan
/// kimlikle aynı kalsın diye duruyor.
String syncBackendIdentity(Flavor flavor) =>
    'pocketbase|${resolvePocketbaseUrl(flavor)}';

/// Arka plan isolate'inde sunucu istemcisini açar; kayıtlı oturum yoksa
/// null (görev bir şey yapmaz).
Future<BackgroundConnection?> openBackgroundConnection(Flavor flavor) =>
    openPocketBaseBackgroundConnection(flavor);
