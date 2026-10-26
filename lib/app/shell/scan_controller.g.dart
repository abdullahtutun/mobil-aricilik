// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kameradan gelen kodları kovana çevirir. Kamera aynı kodu saniyede
/// birkaç kez verir; bir kod çözülürken ya da sonuç ekrandayken gelenler
/// yok sayılır. Ekran açık kaldığı sürece yaşar.
///
/// Ekran kapanınca okutma sonucu (analitik) yazılır: kovan bulundu mu,
/// kaç kod tanınmadı, ne kadar sürdü. Kodun kendisi yazılmaz. Tanınmayan
/// koddan sonra vazgeçilirse sonuç `unknown`.

@ProviderFor(ScanController)
final scanControllerProvider = ScanControllerProvider._();

/// Kameradan gelen kodları kovana çevirir. Kamera aynı kodu saniyede
/// birkaç kez verir; bir kod çözülürken ya da sonuç ekrandayken gelenler
/// yok sayılır. Ekran açık kaldığı sürece yaşar.
///
/// Ekran kapanınca okutma sonucu (analitik) yazılır: kovan bulundu mu,
/// kaç kod tanınmadı, ne kadar sürdü. Kodun kendisi yazılmaz. Tanınmayan
/// koddan sonra vazgeçilirse sonuç `unknown`.
final class ScanControllerProvider
    extends $NotifierProvider<ScanController, ScanState> {
  /// Kameradan gelen kodları kovana çevirir. Kamera aynı kodu saniyede
  /// birkaç kez verir; bir kod çözülürken ya da sonuç ekrandayken gelenler
  /// yok sayılır. Ekran açık kaldığı sürece yaşar.
  ///
  /// Ekran kapanınca okutma sonucu (analitik) yazılır: kovan bulundu mu,
  /// kaç kod tanınmadı, ne kadar sürdü. Kodun kendisi yazılmaz. Tanınmayan
  /// koddan sonra vazgeçilirse sonuç `unknown`.
  ScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanControllerHash();

  @$internal
  @override
  ScanController create() => ScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanState>(value),
    );
  }
}

String _$scanControllerHash() => r'1a665949c7b69b10cff2bbe3a982be9a9840870b';

/// Kameradan gelen kodları kovana çevirir. Kamera aynı kodu saniyede
/// birkaç kez verir; bir kod çözülürken ya da sonuç ekrandayken gelenler
/// yok sayılır. Ekran açık kaldığı sürece yaşar.
///
/// Ekran kapanınca okutma sonucu (analitik) yazılır: kovan bulundu mu,
/// kaç kod tanınmadı, ne kadar sürdü. Kodun kendisi yazılmaz. Tanınmayan
/// koddan sonra vazgeçilirse sonuç `unknown`.

abstract class _$ScanController extends $Notifier<ScanState> {
  ScanState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScanState, ScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScanState, ScanState>,
              ScanState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
