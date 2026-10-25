import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_settings_provider.g.dart';

@Riverpod(keepAlive: true)
LocalSettingsRepository localSettingsRepository(Ref ref) =>
    LocalSettingsRepository(ref.watch(appDatabaseProvider));

/// "Fotoğrafları sadece Wi‑Fi'da yükle".
@Riverpod(keepAlive: true)
Stream<bool> mediaWifiOnly(Ref ref) =>
    ref.watch(localSettingsRepositoryProvider).watchMediaWifiOnly();

/// Varroa uyarı eşikleri (bu telefonun ayarı).
@Riverpod(keepAlive: true)
Stream<VarroaThresholds> varroaThresholds(Ref ref) =>
    ref.watch(localSettingsRepositoryProvider).watchVarroaThresholds();
