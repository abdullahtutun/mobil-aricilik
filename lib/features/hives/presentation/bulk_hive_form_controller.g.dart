// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_hive_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "20 kovan oluştur, 101'den başla": aynı tip ve kaynakta ardışık
/// numaralı aktif kovanlar. Ekran açık kaldığı sürece yaşar. Arılık yoksa
/// ya da silinmişse durum null. Hepsi tek transaction'da yerel DB'ye
/// yazılır.

@ProviderFor(BulkHiveFormController)
final bulkHiveFormControllerProvider = BulkHiveFormControllerFamily._();

/// "20 kovan oluştur, 101'den başla": aynı tip ve kaynakta ardışık
/// numaralı aktif kovanlar. Ekran açık kaldığı sürece yaşar. Arılık yoksa
/// ya da silinmişse durum null. Hepsi tek transaction'da yerel DB'ye
/// yazılır.
final class BulkHiveFormControllerProvider
    extends $AsyncNotifierProvider<BulkHiveFormController, BulkHiveFormState?> {
  /// "20 kovan oluştur, 101'den başla": aynı tip ve kaynakta ardışık
  /// numaralı aktif kovanlar. Ekran açık kaldığı sürece yaşar. Arılık yoksa
  /// ya da silinmişse durum null. Hepsi tek transaction'da yerel DB'ye
  /// yazılır.
  BulkHiveFormControllerProvider._({
    required BulkHiveFormControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bulkHiveFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bulkHiveFormControllerHash();

  @override
  String toString() {
    return r'bulkHiveFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BulkHiveFormController create() => BulkHiveFormController();

  @override
  bool operator ==(Object other) {
    return other is BulkHiveFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bulkHiveFormControllerHash() =>
    r'81e157502b195699b86d79952382820edced07fd';

/// "20 kovan oluştur, 101'den başla": aynı tip ve kaynakta ardışık
/// numaralı aktif kovanlar. Ekran açık kaldığı sürece yaşar. Arılık yoksa
/// ya da silinmişse durum null. Hepsi tek transaction'da yerel DB'ye
/// yazılır.

final class BulkHiveFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BulkHiveFormController,
          AsyncValue<BulkHiveFormState?>,
          BulkHiveFormState?,
          FutureOr<BulkHiveFormState?>,
          String
        > {
  BulkHiveFormControllerFamily._()
    : super(
        retry: null,
        name: r'bulkHiveFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "20 kovan oluştur, 101'den başla": aynı tip ve kaynakta ardışık
  /// numaralı aktif kovanlar. Ekran açık kaldığı sürece yaşar. Arılık yoksa
  /// ya da silinmişse durum null. Hepsi tek transaction'da yerel DB'ye
  /// yazılır.

  BulkHiveFormControllerProvider call(String apiaryId) =>
      BulkHiveFormControllerProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'bulkHiveFormControllerProvider';
}

/// "20 kovan oluştur, 101'den başla": aynı tip ve kaynakta ardışık
/// numaralı aktif kovanlar. Ekran açık kaldığı sürece yaşar. Arılık yoksa
/// ya da silinmişse durum null. Hepsi tek transaction'da yerel DB'ye
/// yazılır.

abstract class _$BulkHiveFormController
    extends $AsyncNotifier<BulkHiveFormState?> {
  late final _$args = ref.$arg as String;
  String get apiaryId => _$args;

  FutureOr<BulkHiveFormState?> build(String apiaryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<BulkHiveFormState?>, BulkHiveFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BulkHiveFormState?>, BulkHiveFormState?>,
              AsyncValue<BulkHiveFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
