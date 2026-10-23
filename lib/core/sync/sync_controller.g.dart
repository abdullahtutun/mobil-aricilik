// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Senkron turlarını başlatır ve durumunu ekranlara verir. Tetikleyiciler
/// (`syncTriggersProvider`) ve ekranlar turu buradan başlatır. Kullanıcı
/// değişince sıfırlanır.

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Senkron turlarını başlatır ve durumunu ekranlara verir. Tetikleyiciler
/// (`syncTriggersProvider`) ve ekranlar turu buradan başlatır. Kullanıcı
/// değişince sıfırlanır.
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncActivity> {
  /// Senkron turlarını başlatır ve durumunu ekranlara verir. Tetikleyiciler
  /// (`syncTriggersProvider`) ve ekranlar turu buradan başlatır. Kullanıcı
  /// değişince sıfırlanır.
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncActivity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncActivity>(value),
    );
  }
}

String _$syncControllerHash() => r'7eafc5b2e740dd81bae0bc58898151d544901de9';

/// Senkron turlarını başlatır ve durumunu ekranlara verir. Tetikleyiciler
/// (`syncTriggersProvider`) ve ekranlar turu buradan başlatır. Kullanıcı
/// değişince sıfırlanır.

abstract class _$SyncController extends $Notifier<SyncActivity> {
  SyncActivity build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncActivity, SyncActivity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncActivity, SyncActivity>,
              SyncActivity,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
