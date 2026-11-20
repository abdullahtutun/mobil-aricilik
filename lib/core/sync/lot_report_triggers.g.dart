// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_report_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahtesiyle override eder.

@ProviderFor(lotReportApi)
final lotReportApiProvider = LotReportApiProvider._();

/// Testler sahtesiyle override eder.

final class LotReportApiProvider
    extends $FunctionalProvider<LotReportApi, LotReportApi, LotReportApi>
    with $Provider<LotReportApi> {
  /// Testler sahtesiyle override eder.
  LotReportApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotReportApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotReportApiHash();

  @$internal
  @override
  $ProviderElement<LotReportApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LotReportApi create(Ref ref) {
    return lotReportApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LotReportApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LotReportApi>(value),
    );
  }
}

String _$lotReportApiHash() => r'b6ab88ae706e21ff7cf2e739c5fef5f4bd03705f';

/// Uygulamadaki tek rapor yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

@ProviderFor(lotReportService)
final lotReportServiceProvider = LotReportServiceProvider._();

/// Uygulamadaki tek rapor yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

final class LotReportServiceProvider
    extends
        $FunctionalProvider<
          LotReportService,
          LotReportService,
          LotReportService
        >
    with $Provider<LotReportService> {
  /// Uygulamadaki tek rapor yükleyicisi; kilit bu örneğe bağlı olduğu için
  /// canlı tutulur.
  LotReportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotReportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotReportServiceHash();

  @$internal
  @override
  $ProviderElement<LotReportService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LotReportService create(Ref ref) {
    return lotReportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LotReportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LotReportService>(value),
    );
  }
}

String _$lotReportServiceHash() => r'9b120ce78a908b8ba0816575a2c270f6f0b9f249';

/// Uygulama açıkken yayımdaki lotların raporlarını yükler; anlar
/// [listenStorageFileSync]'te (açılış, ağ gelince, her senkron turu
/// sonunda). Lot yayımlanınca satır önce gönderilmeli, bu yüzden yazmanın
/// kendisi tetiklemez; ardından gelen senkron turu tetikler. Yazamayan
/// rolde (viewer) çalışmaz. `bootstrap` uygulama boyunca dinler.

@ProviderFor(lotReportTriggers)
final lotReportTriggersProvider = LotReportTriggersProvider._();

/// Uygulama açıkken yayımdaki lotların raporlarını yükler; anlar
/// [listenStorageFileSync]'te (açılış, ağ gelince, her senkron turu
/// sonunda). Lot yayımlanınca satır önce gönderilmeli, bu yüzden yazmanın
/// kendisi tetiklemez; ardından gelen senkron turu tetikler. Yazamayan
/// rolde (viewer) çalışmaz. `bootstrap` uygulama boyunca dinler.

final class LotReportTriggersProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Uygulama açıkken yayımdaki lotların raporlarını yükler; anlar
  /// [listenStorageFileSync]'te (açılış, ağ gelince, her senkron turu
  /// sonunda). Lot yayımlanınca satır önce gönderilmeli, bu yüzden yazmanın
  /// kendisi tetiklemez; ardından gelen senkron turu tetikler. Yazamayan
  /// rolde (viewer) çalışmaz. `bootstrap` uygulama boyunca dinler.
  LotReportTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotReportTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotReportTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return lotReportTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$lotReportTriggersHash() => r'35529448a8fece0f5565ff0baf4c262cdc1bce52';
