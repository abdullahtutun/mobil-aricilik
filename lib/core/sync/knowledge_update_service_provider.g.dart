// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_update_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek bilgi bankası güncelleyicisi; kilit bu örneğe bağlı
/// olduğu için canlı tutulur.

@ProviderFor(knowledgeUpdateService)
final knowledgeUpdateServiceProvider = KnowledgeUpdateServiceProvider._();

/// Uygulamadaki tek bilgi bankası güncelleyicisi; kilit bu örneğe bağlı
/// olduğu için canlı tutulur.

final class KnowledgeUpdateServiceProvider
    extends
        $FunctionalProvider<
          KnowledgeUpdateService,
          KnowledgeUpdateService,
          KnowledgeUpdateService
        >
    with $Provider<KnowledgeUpdateService> {
  /// Uygulamadaki tek bilgi bankası güncelleyicisi; kilit bu örneğe bağlı
  /// olduğu için canlı tutulur.
  KnowledgeUpdateServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeUpdateServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeUpdateServiceHash();

  @$internal
  @override
  $ProviderElement<KnowledgeUpdateService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KnowledgeUpdateService create(Ref ref) {
    return knowledgeUpdateService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KnowledgeUpdateService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KnowledgeUpdateService>(value),
    );
  }
}

String _$knowledgeUpdateServiceHash() =>
    r'b93f5a161a90f9f4b134bb470281cc5c045c49a9';
