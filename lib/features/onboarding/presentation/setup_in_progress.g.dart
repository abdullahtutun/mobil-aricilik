// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_in_progress.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İşletme bu oturumda onboarding'de kuruluyor ya da kuruldu ve kurulumun
/// yerel adımı (ilk arılık) henüz bitmedi. Bu sürede router onboarding'de
/// tutar; işletme kurulunca Bugün yerine ilk arılık adımı açılır.
///
/// Yalnız bellekte: uygulama bu adımda kapanırsa yeniden açılışta Bugün
/// gelir, arılık Arılıklar sekmesinden eklenir. Çıkışta sıfırlanır.

@ProviderFor(SetupInProgress)
final setupInProgressProvider = SetupInProgressProvider._();

/// İşletme bu oturumda onboarding'de kuruluyor ya da kuruldu ve kurulumun
/// yerel adımı (ilk arılık) henüz bitmedi. Bu sürede router onboarding'de
/// tutar; işletme kurulunca Bugün yerine ilk arılık adımı açılır.
///
/// Yalnız bellekte: uygulama bu adımda kapanırsa yeniden açılışta Bugün
/// gelir, arılık Arılıklar sekmesinden eklenir. Çıkışta sıfırlanır.
final class SetupInProgressProvider
    extends $NotifierProvider<SetupInProgress, bool> {
  /// İşletme bu oturumda onboarding'de kuruluyor ya da kuruldu ve kurulumun
  /// yerel adımı (ilk arılık) henüz bitmedi. Bu sürede router onboarding'de
  /// tutar; işletme kurulunca Bugün yerine ilk arılık adımı açılır.
  ///
  /// Yalnız bellekte: uygulama bu adımda kapanırsa yeniden açılışta Bugün
  /// gelir, arılık Arılıklar sekmesinden eklenir. Çıkışta sıfırlanır.
  SetupInProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupInProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupInProgressHash();

  @$internal
  @override
  SetupInProgress create() => SetupInProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$setupInProgressHash() => r'c099b218859f406d2fc8d982c78939e0fe1d44f8';

/// İşletme bu oturumda onboarding'de kuruluyor ya da kuruldu ve kurulumun
/// yerel adımı (ilk arılık) henüz bitmedi. Bu sürede router onboarding'de
/// tutar; işletme kurulunca Bugün yerine ilk arılık adımı açılır.
///
/// Yalnız bellekte: uygulama bu adımda kapanırsa yeniden açılışta Bugün
/// gelir, arılık Arılıklar sekmesinden eklenir. Çıkışta sıfırlanır.

abstract class _$SetupInProgress extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
