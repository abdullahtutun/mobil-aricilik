import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_providers.dart';
import 'package:mobil_arici/features/knowledge/presentation/widgets/knowledge_widgets.dart';

/// Makale: üst çubukta kategorisi, gövdede başlık, özet ve Markdown metin.
/// Yazı stilleri tasarım tokenlarından; linkler tarayıcıda açılır.
class KnowledgeArticleScreen extends ConsumerWidget {
  const new({required this.articleId, super.key});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final articles = ref.watch(
      knowledgeArticlesProvider(Localizations.localeOf(context).languageCode),
    );
    final article = articles.value
        ?.where((article) => article.id == articleId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article == null
              ? l10n.knowledgeTitle
              : knowledgeCategoryTitle(l10n, article.category),
        ),
      ),
      body: switch ((articles, article)) {
        (_, final article?) => _ArticleBody(article),
        (AsyncData(), null) || (AsyncError(), null) => EmptyState(
          icon: Icons.menu_book_outlined,
          title: l10n.knowledgeArticleNotFound,
          message: l10n.knowledgeCategoryEmptyMessage,
          centered: true,
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _ArticleBody extends ConsumerWidget {
  const new(this.article);

  final KnowledgeArticle article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final text = context.typography;

    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        Text(article.title, style: text.headline),
        SizedBox(height: spacing.sm),
        Text(
          article.summary,
          style: text.body.copyWith(color: colors.textSecondary),
        ),
        SizedBox(height: spacing.lg),
        MarkdownBody(
          data: article.body,
          styleSheet: MarkdownStyleSheet(
            p: text.body,
            h1: text.headline,
            h2: text.title,
            h3: text.subtitle,
            h1Padding: EdgeInsets.only(top: spacing.md),
            h2Padding: EdgeInsets.only(top: spacing.md),
            h3Padding: EdgeInsets.only(top: spacing.sm),
            strong: const TextStyle(fontWeight: FontWeight.w700),
            em: const TextStyle(fontStyle: FontStyle.italic),
            a: text.body.copyWith(
              color: colors.primary,
              decoration: TextDecoration.underline,
            ),
            listBullet: text.body,
            listIndent: spacing.xl,
            blockSpacing: spacing.md,
            blockquote: text.body.copyWith(color: colors.textSecondary),
            blockquotePadding: EdgeInsets.all(spacing.md),
            blockquoteDecoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(context.radii.small),
            ),
            tableBody: text.body,
            tableHead: text.label,
            tableBorder: TableBorder.all(
              color: colors.divider,
              width: context.strokes.border,
            ),
            tableCellsPadding: EdgeInsets.all(spacing.sm),
            horizontalRuleDecoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colors.divider,
                  width: context.strokes.border,
                ),
              ),
            ),
          ),
          onTapLink: (_, href, _) {
            final uri = Uri.tryParse(href ?? '');
            if (uri != null && uri.hasScheme) {
              unawaited(_open(context, ref, uri));
            }
          },
        ),
      ],
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref, Uri uri) async {
    final opened = await ref.read(urlLauncherServiceProvider).open(uri);
    if (!opened && context.mounted) {
      showMessageSnackBar(
        context,
        AppLocalizations.of(context).knowledgeLinkFailed,
      );
    }
  }
}
