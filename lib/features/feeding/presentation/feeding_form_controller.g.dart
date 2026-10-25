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

@ProviderFor(FeedingFormController)
final feedingFormControllerProvider = FeedingFormControllerFamily._();

/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
final class FeedingFormControllerProvider
    extends $AsyncNotifierProvider<FeedingFormController, FeedingFormState?> {
  /// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
  /// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
  /// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.
  FeedingFormControllerProvider._({
    required FeedingFormControllerFamily super.from,
    required String super.argument,
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
        '($argument)';
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
    r'4334bd66a283c4906636374c75a9abcee1b87dd5';

/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.

final class FeedingFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          FeedingFormController,
          AsyncValue<FeedingFormState?>,
          FeedingFormState?,
          FutureOr<FeedingFormState?>,
          String
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

  FeedingFormControllerProvider call(String hiveId) =>
      FeedingFormControllerProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'feedingFormControllerProvider';
}

/// Besleme formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa durum null.
/// Besleme yerel DB'ye yazılır; arılığın tümü seçiliyse arılıktaki aktif
/// kovanlara (şurupta bal katı olanlar hariç) tek transaction'da.

abstract class _$FeedingFormController
    extends $AsyncNotifier<FeedingFormState?> {
  late final _$args = ref.$arg as String;
  String get hiveId => _$args;

  FutureOr<FeedingFormState?> build(String hiveId);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
