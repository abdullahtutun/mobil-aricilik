import 'package:mobil_arici/core/analytics/analytics_repository.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_providers.g.dart';

/// Kullanım olaylarını yazan tek giriş; ekranlar ve controller'lar olayı
/// buradan kaydeder.
@Riverpod(keepAlive: true)
AnalyticsRepository analyticsRepository(Ref ref) =>
    AnalyticsRepository(ref.watch(appDatabaseProvider));

/// "Kullanım verisi paylaş" (bu telefonun ayarı).
@Riverpod(keepAlive: true)
Stream<bool> analyticsEnabled(Ref ref) =>
    ref.watch(localSettingsRepositoryProvider).watchAnalyticsEnabled();
