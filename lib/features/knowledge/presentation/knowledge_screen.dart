import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_providers.dart';
import 'package:mobil_arici/features/knowledge/presentation/widgets/knowledge_widgets.dart';

/// Bilgi bankası (docs/design "Bilgi bankası"): üstte internetsiz tam metin
/// arama; arama boşken "Bu ay yapılacaklar" kartı (ay, bölge ve
/// yarımküreye göre), teşhis yardımcısı ve hesaplayıcılar. Açılınca
/// içerik güncellemesine bakılır; yeni paket inerse ekran kendiliğinden
/// yenilenir.
class KnowledgeScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends ConsumerState<KnowledgeScreen> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(knowledgeUpdatesProvider.notifier).check(force: true));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final articles = ref.watch(
      knowledgeArticlesProvider(Localizations.localeOf(context).languageCode),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.knowledgeTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: l10n.knowledgeSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (query) => setState(() => _query = query),
          ),
          SizedBox(height: spacing.lg),
          ...switch (articles) {
            AsyncData(:final value) when _query.trim().isNotEmpty => _results(
              context,
              searchKnowledgeArticles(value, _query),
            ),
            AsyncData(:final value) => _home(context, value),
            AsyncError() => [Text(l10n.knowledgeLoadError)],
            // Uygulamayla gelen dosyalar; hemen okunur.
            _ => const <Widget>[],
          },
        ],
      ),
    );
  }

  List<Widget> _results(BuildContext context, List<KnowledgeArticle> results) {
    final l10n = AppLocalizations.of(context);
    if (results.isEmpty) {
      return [
        EmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.knowledgeNoResultsTitle,
          message: l10n.knowledgeNoResultsMessage,
        ),
      ];
    }
    return [KnowledgeArticleList(results)];
  }

  List<Widget> _home(BuildContext context, List<KnowledgeArticle> articles) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final region = ref.watch(regionConfigProvider);
    final month = monthKnowledgeArticle(
      articles,
      month: clock.now().month,
      hemisphere: region.hemisphere,
      profile: region.profile,
    );

    return [
      if (month != null) ...[
        _MonthCard(article: month, region: region),
        SizedBox(height: spacing.lg),
      ],
      const _DiagnosisCard(),
      SizedBox(height: spacing.lg),
      ListGroup(
        children: [
          ListRow(
            title: l10n.knowledgeCalculatorsTitle,
            subtitle: l10n.knowledgeCalculatorsSubtitle,
            onTap: () => unawaited(context.push(AppRoutes.calculators)),
          ),
        ],
      ),
      SizedBox(height: spacing.lg),
      const _OfflineNote(),
    ];
  }
}

/// "Bu ay yapılacaklar": çam yeşili kart; üstte ay ve yer (TR profilinde
/// Türkiye, diğerlerinde yarımküre), başlık ve makalenin özeti. Dokununca
/// makale açılır.
class _MonthCard extends StatelessWidget {
  const new({required this.article, required this.region});

  final KnowledgeArticle article;
  final RegionConfig region;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final place = switch ((region.profile, region.hemisphere)) {
      (RegionProfile.tr, _) => l10n.knowledgePlaceTurkey,
      (_, Hemisphere.northern) => l10n.knowledgePlaceNorthern,
      (_, Hemisphere.southern) => l10n.knowledgePlaceSouthern,
    };
    final text = context.typography;

    return MergeSemantics(
      child: Material(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(context.radii.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () =>
              unawaited(context.push(AppRoutes.knowledgeArticle(article.id))),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing.sm,
              children: [
                Text(
                  format.upperCase(
                    l10n.knowledgeMonthLabel(format.month(clock.now()), place),
                  ),
                  style: text.labelSmall.copyWith(color: colors.onSecondary),
                ),
                Text(
                  l10n.knowledgeMonthTitle,
                  style: text.headline.copyWith(color: colors.onSecondary),
                ),
                Text(
                  article.summary,
                  style: text.body.copyWith(color: colors.onSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Teşhis yardımcısı; dokununca belirti seçimi açılır.
class _DiagnosisCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;

    return MergeSemantics(
      child: AppCard(
        onTap: () => unawaited(context.push(AppRoutes.diagnosis)),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            children: [
              SizedBox.square(
                dimension: context.touchTargets.field,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.statusCriticalContainer,
                    borderRadius: BorderRadius.circular(context.radii.button),
                  ),
                  child: Icon(
                    Icons.troubleshoot_rounded,
                    size: context.sizes.icon,
                    color: colors.statusCritical,
                  ),
                ),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: spacing.xs,
                  children: [
                    Text(
                      l10n.knowledgeDiagnosisTitle,
                      style: context.typography.title,
                    ),
                    Text(
                      l10n.knowledgeDiagnosisSubtitle,
                      style: context.typography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: context.sizes.icon,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "✓ Tüm içerik internetsiz açılır".
class _OfflineNote extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      spacing: context.spacing.sm,
      children: [
        Icon(
          Icons.check_rounded,
          size: context.sizes.iconSmall,
          color: colors.statusGood,
        ),
        Expanded(
          child: Text(
            AppLocalizations.of(context).knowledgeOffline,
            style: context.typography.label.copyWith(color: colors.statusGood),
          ),
        ),
      ],
    );
  }
}
