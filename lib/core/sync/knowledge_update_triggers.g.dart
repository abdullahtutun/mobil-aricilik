// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_update_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bilgi bankası güncellemesine arka planda bakar: açılışta oturum hazır
/// olunca ve her senkron turu bitince (servis en çok saatte bir bakar).
/// Bilgi bankası ekranı açılınca da zorlanmış bir kontrol yapılır.
/// `bootstrap` uygulama boyunca dinler.

@ProviderFor(knowledgeUpdateTriggers)
final knowledgeUpdateTriggersProvider = KnowledgeUpdateTriggersProvider._();

/// Bilgi bankası güncellemesine arka planda bakar: açılışta oturum hazır
/// olunca ve her senkron turu bitince (servis en çok saatte bir bakar).
/// Bilgi bankası ekranı açılınca da zorlanmış bir kontrol yapılır.
/// `bootstrap` uygulama boyunca dinler.

final class KnowledgeUpdateTriggersProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Bilgi bankası güncellemesine arka planda bakar: açılışta oturum hazır
  /// olunca ve her senkron turu bitince (servis en çok saatte bir bakar).
  /// Bilgi bankası ekranı açılınca da zorlanmış bir kontrol yapılır.
  /// `bootstrap` uygulama boyunca dinler.
  KnowledgeUpdateTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeUpdateTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeUpdateTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return knowledgeUpdateTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$knowledgeUpdateTriggersHash() =>
    r'86fb2455036c67e0467e2863641ebb7927eb3f8d';
