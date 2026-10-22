// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cihazdaki veritabanı (uygulama belgeleri klasöründe
/// `mobil_arici.sqlite`). Bağlantı ilk sorguda açılır, açılış beklemez.
/// Testler bellek içi DB ile override eder.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Cihazdaki veritabanı (uygulama belgeleri klasöründe
/// `mobil_arici.sqlite`). Bağlantı ilk sorguda açılır, açılış beklemez.
/// Testler bellek içi DB ile override eder.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Cihazdaki veritabanı (uygulama belgeleri klasöründe
  /// `mobil_arici.sqlite`). Bağlantı ilk sorguda açılır, açılış beklemez.
  /// Testler bellek içi DB ile override eder.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'751fb6f450e375a7e74739a296c8bd3b8a0d31bf';
