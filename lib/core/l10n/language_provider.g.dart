// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arayüz dili seçimi. Bellekte tutulur; açılışta yerel DB'den geri
/// yüklenir ve her değişiklik oraya yazılır (`app/device_preferences.dart`).

@ProviderFor(Language)
final languageProvider = LanguageProvider._();

/// Arayüz dili seçimi. Bellekte tutulur; açılışta yerel DB'den geri
/// yüklenir ve her değişiklik oraya yazılır (`app/device_preferences.dart`).
final class LanguageProvider extends $NotifierProvider<Language, AppLanguage> {
  /// Arayüz dili seçimi. Bellekte tutulur; açılışta yerel DB'den geri
  /// yüklenir ve her değişiklik oraya yazılır (`app/device_preferences.dart`).
  LanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageHash();

  @$internal
  @override
  Language create() => Language();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLanguage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLanguage>(value),
    );
  }
}

String _$languageHash() => r'20143fdf342dcad93111ab3035cf71e8b89c4ee5';

/// Arayüz dili seçimi. Bellekte tutulur; açılışta yerel DB'den geri
/// yüklenir ve her değişiklik oraya yazılır (`app/device_preferences.dart`).

abstract class _$Language extends $Notifier<AppLanguage> {
  AppLanguage build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLanguage, AppLanguage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLanguage, AppLanguage>,
              AppLanguage,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
