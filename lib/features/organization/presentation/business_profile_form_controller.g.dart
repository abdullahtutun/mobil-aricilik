// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İşletme profil formu (`/more/business/edit`). Ekran açık kaldığı sürece
/// yaşar. Her şey yerel DB'ye ve outbox'a yazılır, ağ beklenmez; seçilen
/// logo dosyası kaydedilince yükleme kuyruğuna girer, kaydedilmeden kapanan
/// formun seçtiği dosya silinir.

@ProviderFor(BusinessProfileFormController)
final businessProfileFormControllerProvider =
    BusinessProfileFormControllerProvider._();

/// İşletme profil formu (`/more/business/edit`). Ekran açık kaldığı sürece
/// yaşar. Her şey yerel DB'ye ve outbox'a yazılır, ağ beklenmez; seçilen
/// logo dosyası kaydedilince yükleme kuyruğuna girer, kaydedilmeden kapanan
/// formun seçtiği dosya silinir.
final class BusinessProfileFormControllerProvider
    extends
        $NotifierProvider<
          BusinessProfileFormController,
          BusinessProfileFormState
        > {
  /// İşletme profil formu (`/more/business/edit`). Ekran açık kaldığı sürece
  /// yaşar. Her şey yerel DB'ye ve outbox'a yazılır, ağ beklenmez; seçilen
  /// logo dosyası kaydedilince yükleme kuyruğuna girer, kaydedilmeden kapanan
  /// formun seçtiği dosya silinir.
  BusinessProfileFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessProfileFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessProfileFormControllerHash();

  @$internal
  @override
  BusinessProfileFormController create() => BusinessProfileFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BusinessProfileFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BusinessProfileFormState>(value),
    );
  }
}

String _$businessProfileFormControllerHash() =>
    r'976069671a7115e5ee57cf1e670ccf48cfb29ad6';

/// İşletme profil formu (`/more/business/edit`). Ekran açık kaldığı sürece
/// yaşar. Her şey yerel DB'ye ve outbox'a yazılır, ağ beklenmez; seçilen
/// logo dosyası kaydedilince yükleme kuyruğuna girer, kaydedilmeden kapanan
/// formun seçtiği dosya silinir.

abstract class _$BusinessProfileFormController
    extends $Notifier<BusinessProfileFormState> {
  BusinessProfileFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<BusinessProfileFormState, BusinessProfileFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BusinessProfileFormState, BusinessProfileFormState>,
              BusinessProfileFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
