// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
/// [wholeApiary] formu arılığın tümü seçili açar.

@ProviderFor(FeedingFormController)
final feedingFormControllerProvider = FeedingFormControllerFamily._();

/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
/// [wholeApiary] formu arılığın tümü seçili açar.
final class FeedingFormControllerProvider
    extends $AsyncNotifierProvider<FeedingFormController, FeedingFormState?> {
  /// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
  /// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
  /// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
  /// [wholeApiary] formu arılığın tümü seçili açar.
  FeedingFormControllerProvider._({
    required FeedingFormControllerFamily super.from,
    required (String, {bool wholeApiary}) super.argument,
  }) : super(
         retry: null,
         name: r'feedingFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$feedingFormControllerHash();

  @override
  String toString() {
    return r'feedingFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  FeedingFormController create() => FeedingFormController();

  @override
  bool operator ==(Object other) {
    return other is FeedingFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$feedingFormControllerHash() =>
    r'70031e335055aca1ca36fcb3a810aac945bf1aa0';

/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
/// [wholeApiary] formu arılığın tümü seçili açar.

final class FeedingFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          FeedingFormController,
          AsyncValue<FeedingFormState?>,
          FeedingFormState?,
          FutureOr<FeedingFormState?>,
          (String, {bool wholeApiary})
        > {
  FeedingFormControllerFamily._()
    : super(
        retry: null,
        name: r'feedingFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
  /// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
  /// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
  /// [wholeApiary] formu arılığın tümü seçili açar.

  FeedingFormControllerProvider call(
    String hiveId, {
    bool wholeApiary = false,
  }) => FeedingFormControllerProvider._(
    argument: (hiveId, wholeApiary: wholeApiary),
    from: this,
  );

  @override
  String toString() => r'feedingFormControllerProvider';
}

/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
/// [wholeApiary] formu arılığın tümü seçili açar.

abstract class _$FeedingFormController
    extends $AsyncNotifier<FeedingFormState?> {
  late final _$args = ref.$arg as (String, {bool wholeApiary});
  String get hiveId => _$args.$1;
  bool get wholeApiary => _$args.wholeApiary;

  FutureOr<FeedingFormState?> build(String hiveId, {bool wholeApiary = false});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<FeedingFormState?>, FeedingFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FeedingFormState?>, FeedingFormState?>,
              AsyncValue<FeedingFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, wholeApiary: _$args.wholeApiary),
    );
  }
}
