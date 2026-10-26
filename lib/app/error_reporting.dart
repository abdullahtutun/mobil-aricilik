import 'dart:async';

import 'package:mobil_arici/app/flavor.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Sentry projesinin DSN'i: `--dart-define=SENTRY_DSN=...`. Boşsa (yerel
/// geliştirme, testler) hata izleme kapalı.
const sentryDsn = String.fromEnvironment('SENTRY_DSN');

/// Çevrimdışıyken diskte bekleyen en fazla olay; ağ gelince (ya da sonraki
/// açılışta) gönderilir. Sahada günlerce internet olmayabilir.
const sentryMaxCachedEvents = 100;

/// [appRunner]'ı Sentry ile sarar: yakalanmayan Flutter, Dart ve native
/// hatalar Sentry'ye gider. Android ve iOS'ta olaylar önce diske yazılır;
/// ağ yoksa kuyrukta bekler. Kullanıcı kimliği, e-posta ve IP gönderilmez.
/// [dsn] boşsa yalnız [appRunner] çalışır.
Future<void> runWithErrorReporting(
  Flavor flavor,
  FutureOr<void> Function() appRunner, {
  String dsn = sentryDsn,
}) async {
  if (dsn.isEmpty) {
    await appRunner();
    return;
  }
  await SentryFlutter.init(
    (options) => options
      ..dsn = dsn
      ..environment = flavor.name
      ..sendDefaultPii = false
      ..maxCacheItems = sentryMaxCachedEvents,
    appRunner: appRunner,
  );
}
