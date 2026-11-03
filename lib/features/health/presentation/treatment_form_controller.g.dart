// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İlaç uygulaması formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa
/// durum null. Uygulama yerel DB'ye yazılır; arılığın tümü seçiliyse
/// arılıktaki her aktif kovana tek transaction'da. Kaydedilmeden kapanan
/// formun reçete fotoğrafı dosyası silinir. [wholeApiary] formu arılığın
/// tümü seçili açar.

@ProviderFor(TreatmentFormController)
final treatmentFormControllerProvider = TreatmentFormControllerFamily._();

/// İlaç uygulaması formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa
/// durum null. Uygulama yerel DB'ye yazılır; arılığın tümü seçiliyse
/// arılıktaki her aktif kovana tek transaction'da. Kaydedilmeden kapanan
/// formun reçete fotoğrafı dosyası silinir. [wholeApiary] formu arılığın
/// tümü seçili açar.
final class TreatmentFormControllerProvider
    extends
        $AsyncNotifierProvider<TreatmentFormController, TreatmentFormState?> {
  /// İlaç uygulaması formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa
  /// durum null. Uygulama yerel DB'ye yazılır; arılığın tümü seçiliyse
  /// arılıktaki her aktif kovana tek transaction'da. Kaydedilmeden kapanan
  /// formun reçete fotoğrafı dosyası silinir. [wholeApiary] formu arılığın
  /// tümü seçili açar.
  TreatmentFormControllerProvider._({
    required TreatmentFormControllerFamily super.from,
    required (String, {bool wholeApiary}) super.argument,
  }) : super(
         retry: null,
         name: r'treatmentFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$treatmentFormControllerHash();

  @override
  String toString() {
    return r'treatmentFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TreatmentFormController create() => TreatmentFormController();

  @override
  bool operator ==(Object other) {
    return other is TreatmentFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$treatmentFormControllerHash() =>
    r'436a6508b2924be74f1229088dbb5371e606c4ab';

/// İlaç uygulaması formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa
/// durum null. Uygulama yerel DB'ye yazılır; arılığın tümü seçiliyse
/// arılıktaki her aktif kovana tek transaction'da. Kaydedilmeden kapanan
/// formun reçete fotoğrafı dosyası silinir. [wholeApiary] formu arılığın
/// tümü seçili açar.

final class TreatmentFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TreatmentFormController,
          AsyncValue<TreatmentFormState?>,
          TreatmentFormState?,
          FutureOr<TreatmentFormState?>,
          (String, {bool wholeApiary})
        > {
  TreatmentFormControllerFamily._()
    : super(
        retry: null,
        name: r'treatmentFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// İlaç uygulaması formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa
  /// durum null. Uygulama yerel DB'ye yazılır; arılığın tümü seçiliyse
  /// arılıktaki her aktif kovana tek transaction'da. Kaydedilmeden kapanan
  /// formun reçete fotoğrafı dosyası silinir. [wholeApiary] formu arılığın
  /// tümü seçili açar.

  TreatmentFormControllerProvider call(
    String hiveId, {
    bool wholeApiary = false,
  }) => TreatmentFormControllerProvider._(
    argument: (hiveId, wholeApiary: wholeApiary),
    from: this,
  );

  @override
  String toString() => r'treatmentFormControllerProvider';
}

/// İlaç uygulaması formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa
/// durum null. Uygulama yerel DB'ye yazılır; arılığın tümü seçiliyse
/// arılıktaki her aktif kovana tek transaction'da. Kaydedilmeden kapanan
/// formun reçete fotoğrafı dosyası silinir. [wholeApiary] formu arılığın
/// tümü seçili açar.

abstract class _$TreatmentFormController
    extends $AsyncNotifier<TreatmentFormState?> {
  late final _$args = ref.$arg as (String, {bool wholeApiary});
  String get hiveId => _$args.$1;
  bool get wholeApiary => _$args.wholeApiary;

  FutureOr<TreatmentFormState?> build(
    String hiveId, {
    bool wholeApiary = false,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TreatmentFormState?>, TreatmentFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TreatmentFormState?>, TreatmentFormState?>,
              AsyncValue<TreatmentFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, wholeApiary: _$args.wholeApiary),
    );
  }
}
