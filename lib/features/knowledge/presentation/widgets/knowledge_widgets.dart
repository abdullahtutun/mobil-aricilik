import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';

/// Kategorinin adı.
String knowledgeCategoryTitle(
  AppLocalizations l10n,
  KnowledgeCategory category,
) => switch (category) {
  KnowledgeCategory.atlas => l10n.knowledgeAtlasTitle,
  KnowledgeCategory.guides => l10n.knowledgeGuidesTitle,
  KnowledgeCategory.regulations => l10n.knowledgeRegulationsTitle,
  KnowledgeCategory.firstYear => l10n.knowledgeFirstYearTitle,
  KnowledgeCategory.calendar => l10n.knowledgeCalendarTitle,
};

/// Makale listesi (arama sonuçları, kategori): başlık ve özet; dokununca
/// makale açılır.
class KnowledgeArticleList extends StatelessWidget {
  const new(this.articles, {super.key});

  final List<KnowledgeArticle> articles;

  @override
  Widget build(BuildContext context) => ListGroup(
    children: [
      for (final article in articles)
        ListRow(
          title: article.title,
          subtitle: article.summary,
          onTap: () =>
              unawaited(context.push(AppRoutes.knowledgeArticle(article.id))),
        ),
    ],
  );
}
