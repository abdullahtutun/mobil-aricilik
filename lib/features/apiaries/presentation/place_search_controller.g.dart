// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Harita seçicideki il, ilçe ve yer araması. Durum null: henüz aranmadı ya
/// da arama temizlendi. Sonuçlar işletmenin ülkesiyle sınırlı.

@ProviderFor(PlaceSearchController)
final placeSearchControllerProvider = PlaceSearchControllerProvider._();

/// Harita seçicideki il, ilçe ve yer araması. Durum null: henüz aranmadı ya
/// da arama temizlendi. Sonuçlar işletmenin ülkesiyle sınırlı.
final class PlaceSearchControllerProvider
    extends
        $NotifierProvider<
          PlaceSearchController,
          AsyncValue<List<PlaceResult>>?
        > {
  /// Harita seçicideki il, ilçe ve yer araması. Durum null: henüz aranmadı ya
  /// da arama temizlendi. Sonuçlar işletmenin ülkesiyle sınırlı.
  PlaceSearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeSearchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeSearchControllerHash();

  @$internal
  @override
  PlaceSearchController create() => PlaceSearchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PlaceResult>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<PlaceResult>>?>(
        value,
      ),
    );
  }
}

String _$placeSearchControllerHash() =>
    r'd90e18dc65892c2b48c74782cad56559dfea9e57';

/// Harita seçicideki il, ilçe ve yer araması. Durum null: henüz aranmadı ya
/// da arama temizlendi. Sonuçlar işletmenin ülkesiyle sınırlı.

abstract class _$PlaceSearchController
    extends $Notifier<AsyncValue<List<PlaceResult>>?> {
  AsyncValue<List<PlaceResult>>? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<PlaceResult>>?,
              AsyncValue<List<PlaceResult>>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PlaceResult>>?,
                AsyncValue<List<PlaceResult>>?
              >,
              AsyncValue<List<PlaceResult>>?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
