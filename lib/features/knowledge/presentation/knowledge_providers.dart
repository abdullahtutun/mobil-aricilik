import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/knowledge_update_service_provider.dart';
import 'package:mobil_arici/features/knowledge/data/knowledge_repository.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'knowledge_providers.g.dart';

/// İndirilen paketin klasörü; testler geçici klasörle override eder.
@Riverpod(keepAlive: true)
MediaFileStore knowledgeFileStore(Ref ref) => MediaFileStore.app('knowledge');

@Riverpod(keepAlive: true)
KnowledgeRepository knowledgeRepository(Ref ref) =>
    KnowledgeRepository(rootBundle, ref.watch(knowledgeFileStoreProvider));

/// Okunan içerik sürümü; yeni paket inince yeniden okunur.
@Riverpod(keepAlive: true)
Future<KnowledgeLibrary> knowledgeLibrary(Ref ref) =>
    ref.watch(knowledgeRepositoryProvider).load();

/// [language]'deki ve bölgede görünen makaleler, başlık sırasıyla.
@riverpod
Future<List<KnowledgeArticle>> knowledgeArticles(
  Ref ref,
  String language,
) async {
  final library = await ref.watch(knowledgeLibraryProvider.future);
  final profile = ref.watch(
    regionConfigProvider.select((region) => region.profile),
  );
  return visibleKnowledgeArticles(
    library.articles,
    language: language,
    profile: profile,
  );
}

/// İçerik güncellemesi: Storage'da yeni paket varsa indirir ve içeriği
/// yeniden okutur; açık ekranlar kendiliğinden yenilenir.
@Riverpod(keepAlive: true)
class KnowledgeUpdates extends _$KnowledgeUpdates {
  @override
  void build() {}

  /// [force] false ise servis son kontrolden bir saat geçmeden bakmaz.
  Future<void> check({bool force = false}) async {
    final updated = await ref
        .read(knowledgeUpdateServiceProvider)
        .update(force: force);
    if (updated && ref.mounted) ref.invalidate(knowledgeLibraryProvider);
  }
}
