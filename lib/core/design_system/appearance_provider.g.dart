// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appearance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görünüm seçimi. Şimdilik bellekte; kalıcı kayıt ayarlar adımında gelecek.

@ProviderFor(Appearance)
final appearanceProvider = AppearanceProvider._();

/// Görünüm seçimi. Şimdilik bellekte; kalıcı kayıt ayarlar adımında gelecek.
final class AppearanceProvider
    extends $NotifierProvider<Appearance, AppearanceSettings> {
  /// Görünüm seçimi. Şimdilik bellekte; kalıcı kayıt ayarlar adımında gelecek.
  AppearanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appearanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appearanceHash();

  @$internal
  @override
  Appearance create() => Appearance();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppearanceSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppearanceSettings>(value),
    );
  }
}

String _$appearanceHash() => r'c2f2471a5feb911376e9adf846f8a51cc5b5abea';

/// Görünüm seçimi. Şimdilik bellekte; kalıcı kayıt ayarlar adımında gelecek.

abstract class _$Appearance extends $Notifier<AppearanceSettings> {
  AppearanceSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppearanceSettings, AppearanceSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppearanceSettings, AppearanceSettings>,
              AppearanceSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
