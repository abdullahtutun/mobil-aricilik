import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flavor.g.dart';

// Prod projesi açılana kadar iki flavor da aynı Supabase projesine bağlı.
// Anon key istemciye açık bir anahtar; veriyi RLS korur.
const _sharedSupabaseUrl = 'https://jcddnelaboueazhordfz.supabase.co';
const _sharedSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im'
    'pjZGRuZWxhYm91ZWF6aG9yZGZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI1Mjc2ODYsIm'
    'V4cCI6MjEwODEwMzY4Nn0.M0XvUNlPpZHQBWA9Uq3-vlusrUWjnxow_a5WV87OzGo';

/// Uygulamanın konuştuğu sunucu. Ekranlar bunu bilmez; ağa giden
/// servislerin provider'ları [backendProvider]'a göre uygulama seçer.
enum Backend { supabase, pocketbase }

enum Flavor {
  dev(
    supabaseUrl: _sharedSupabaseUrl,
    supabaseAnonKey: _sharedSupabaseAnonKey,
    defaultBackend: Backend.pocketbase,
    pocketbaseUrl: 'https://arici-api-dev.tutunsoft.com',
  ),
  prod(
    supabaseUrl: _sharedSupabaseUrl,
    supabaseAnonKey: _sharedSupabaseAnonKey,
    defaultBackend: Backend.supabase,
    pocketbaseUrl: 'https://arici-api.tutunsoft.com',
  );

  new({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.defaultBackend,
    required this.pocketbaseUrl,
  });

  final String supabaseUrl;
  final String supabaseAnonKey;

  /// `--dart-define=BACKEND=...` verilmezse kullanılan sunucu.
  final Backend defaultBackend;

  /// PocketBase sunucusunun kök adresi; `--dart-define=PB_URL=...` ezer.
  final String pocketbaseUrl;
}

/// `--dart-define=BACKEND=supabase|pocketbase`; boşsa flavor'ın varsayılanı.
const backendDefine = String.fromEnvironment('BACKEND');

/// `--dart-define=PB_URL=...`; boşsa flavor'ın adresi. Yerelde ör.
/// `http://127.0.0.1:8090` (iOS simülatörü), `http://10.0.2.2:8090`
/// (Android emülatörü).
const pocketbaseUrlDefine = String.fromEnvironment('PB_URL');

/// [flavor]'ın sunucusu; [define] doluysa o. Tanınmayan değerde
/// [ArgumentError] atar: yanlış yazılmış ayarla sessizce başka sunucuya
/// bağlanılmasın.
Backend resolveBackend(Flavor flavor, {String define = backendDefine}) {
  final name = define.trim();
  if (name.isEmpty) return flavor.defaultBackend;
  return Backend.values.asNameMap()[name] ??
      (throw ArgumentError.value(
        define,
        'BACKEND',
        'supabase ya da pocketbase olmalı',
      ));
}

/// [flavor]'ın PocketBase adresi; [define] doluysa o. Sondaki `/` atılır.
String resolvePocketbaseUrl(
  Flavor flavor, {
  String define = pocketbaseUrlDefine,
}) {
  final url = define.trim().isEmpty ? flavor.pocketbaseUrl : define.trim();
  return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}

/// Çalışan flavor. `bootstrap` gerçek değerle override eder; override
/// edilmezse (ör. testlerde) geliştirici araçları kapalı kalsın diye prod.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) => Flavor.prod;

/// Kullanılan sunucu ([resolveBackend]). Yalnız data katmanındaki servis
/// provider'ları okur; ekranlar okumaz.
@Riverpod(keepAlive: true)
Backend backend(Ref ref) => resolveBackend(ref.watch(flavorProvider));

/// PocketBase sunucusunun adresi ([resolvePocketbaseUrl]).
@Riverpod(keepAlive: true)
String pocketbaseUrl(Ref ref) =>
    resolvePocketbaseUrl(ref.watch(flavorProvider));
