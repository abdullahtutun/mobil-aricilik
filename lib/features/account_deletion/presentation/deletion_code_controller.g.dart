// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deletion_code_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hesap silmedeki kimlik doğrulama: `account-delete` silme kodunu
/// ("hesap silme kodun") e-postaya yollar ve sunucuda doğrular. Giriş kodu
/// kullanılmaz, yeni oturum açılmaz. Form ([CodeEntryForm]) giriş ekranıyla
/// aynı; hata metinleri girişinkiler.

@ProviderFor(DeletionCodeController)
final deletionCodeControllerProvider = DeletionCodeControllerProvider._();

/// Hesap silmedeki kimlik doğrulama: `account-delete` silme kodunu
/// ("hesap silme kodun") e-postaya yollar ve sunucuda doğrular. Giriş kodu
/// kullanılmaz, yeni oturum açılmaz. Form ([CodeEntryForm]) giriş ekranıyla
/// aynı; hata metinleri girişinkiler.
final class DeletionCodeControllerProvider
    extends $NotifierProvider<DeletionCodeController, CodeFormState> {
  /// Hesap silmedeki kimlik doğrulama: `account-delete` silme kodunu
  /// ("hesap silme kodun") e-postaya yollar ve sunucuda doğrular. Giriş kodu
  /// kullanılmaz, yeni oturum açılmaz. Form ([CodeEntryForm]) giriş ekranıyla
  /// aynı; hata metinleri girişinkiler.
  DeletionCodeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletionCodeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletionCodeControllerHash();

  @$internal
  @override
  DeletionCodeController create() => DeletionCodeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodeFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodeFormState>(value),
    );
  }
}

String _$deletionCodeControllerHash() =>
    r'f3f44f0aa0f5b01937dd42f6c90ba44f941bfe16';

/// Hesap silmedeki kimlik doğrulama: `account-delete` silme kodunu
/// ("hesap silme kodun") e-postaya yollar ve sunucuda doğrular. Giriş kodu
/// kullanılmaz, yeni oturum açılmaz. Form ([CodeEntryForm]) giriş ekranıyla
/// aynı; hata metinleri girişinkiler.

abstract class _$DeletionCodeController extends $Notifier<CodeFormState> {
  CodeFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CodeFormState, CodeFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CodeFormState, CodeFormState>,
              CodeFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
