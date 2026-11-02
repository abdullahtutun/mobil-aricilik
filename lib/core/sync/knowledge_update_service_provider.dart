import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/knowledge_update_service.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'knowledge_update_service_provider.g.dart';

/// Uygulamadaki tek bilgi bankası güncelleyicisi; kilit bu örneğe bağlı
/// olduğu için canlı tutulur.
@Riverpod(keepAlive: true)
KnowledgeUpdateService knowledgeUpdateService(Ref ref) {
  final storage = ref
      .watch(supabaseClientProvider)
      .storage
      .from(KnowledgeUpdateService.bucket);
  return KnowledgeUpdateService(
    storage.download,
    ref.watch(knowledgeRepositoryProvider),
  );
}
