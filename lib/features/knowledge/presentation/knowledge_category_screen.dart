import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_providers.dart';
import 'package:mobil_arici/features/knowledge/presentation/widgets/knowledge_widgets.dart';

/// Kategorinin makaleleri, başlık sırasıyla. [category] null ise (adreste
/// tanınmayan kategori) boş durum gösterilir.
class KnowledgeCategoryScreen extends ConsumerWidget {
  const new({required this.category, super.key});

  final KnowledgeCategory? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final category = this.category;
    final articles = ref
        .watch(
          knowledgeArticlesProvider(
            Localizations.localeOf(context).languageCode,
          ),
        )
        .value
        ?.where((article) => article.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category == null
              ? l10n.knowledgeTitle
              : knowledgeCategoryTitle(l10n, category),
        ),
      ),
      body: switch (articles) {
        null => const SizedBox.shrink(),
        [] => EmptyState(
          icon: Icons.menu_book_outlined,
          title: l10n.knowledgeCategoryEmptyTitle,
          message: l10n.knowledgeCategoryEmptyMessage,
          centered: true,
        ),
        _ => ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [KnowledgeArticleList(articles)],
        ),
      },
    );
  }
}
