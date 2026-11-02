// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kovan ekleme ([hiveId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Eklenecek arılık ya da düzenlenecek kovan yoksa (ya da
/// silinmişse) durum null. Her şey yerel DB'ye yazılır.

@ProviderFor(HiveFormController)
final hiveFormControllerProvider = HiveFormControllerFamily._();

/// Kovan ekleme ([hiveId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Eklenecek arılık ya da düzenlenecek kovan yoksa (ya da
/// silinmişse) durum null. Her şey yerel DB'ye yazılır.
final class HiveFormControllerProvider
    extends $AsyncNotifierProvider<HiveFormController, HiveFormState?> {
  /// Kovan ekleme ([hiveId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Eklenecek arılık ya da düzenlenecek kovan yoksa (ya da
  /// silinmişse) durum null. Her şey yerel DB'ye yazılır.
  HiveFormControllerProvider._({
    required HiveFormControllerFamily super.from,
    required ({String apiaryId, String? hiveId}) super.argument,
  }) : super(
         retry: null,
         name: r'hiveFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveFormControllerHash();

  @override
  String toString() {
    return r'hiveFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  HiveFormController create() => HiveFormController();

  @override
  bool operator ==(Object other) {
    return other is HiveFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveFormControllerHash() =>
    r'dc1c3cd37ca1f89c78e730f0f431b74217315519';

/// Kovan ekleme ([hiveId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Eklenecek arılık ya da düzenlenecek kovan yoksa (ya da
/// silinmişse) durum null. Her şey yerel DB'ye yazılır.

final class HiveFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          HiveFormController,
          AsyncValue<HiveFormState?>,
          HiveFormState?,
          FutureOr<HiveFormState?>,
          ({String apiaryId, String? hiveId})
        > {
  HiveFormControllerFamily._()
    : super(
        retry: null,
        name: r'hiveFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovan ekleme ([hiveId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Eklenecek arılık ya da düzenlenecek kovan yoksa (ya da
  /// silinmişse) durum null. Her şey yerel DB'ye yazılır.

  HiveFormControllerProvider call({required String apiaryId, String? hiveId}) =>
      HiveFormControllerProvider._(
        argument: (apiaryId: apiaryId, hiveId: hiveId),
        from: this,
      );

  @override
  String toString() => r'hiveFormControllerProvider';
}

/// Kovan ekleme ([hiveId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Eklenecek arılık ya da düzenlenecek kovan yoksa (ya da
/// silinmişse) durum null. Her şey yerel DB'ye yazılır.

abstract class _$HiveFormController extends $AsyncNotifier<HiveFormState?> {
  late final _$args = ref.$arg as ({String apiaryId, String? hiveId});
  String get apiaryId => _$args.apiaryId;
  String? get hiveId => _$args.hiveId;

  FutureOr<HiveFormState?> build({required String apiaryId, String? hiveId});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HiveFormState?>, HiveFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HiveFormState?>, HiveFormState?>,
              AsyncValue<HiveFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(apiaryId: _$args.apiaryId, hiveId: _$args.hiveId),
    );
  }
}
