import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';

/// Arılık detayı. Şimdilik üst kısım: ad, aktif kovan sayısı, son ziyaret.
/// Harita şeridi, kovan ızgarası ve eylem çubuğu kendi adımlarında gelecek.
class ApiaryDetailScreen extends ConsumerWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(apiarySummaryProvider(apiaryId))) {
      AsyncData(value: final summary?) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: l10n.apiaryEdit,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => context.go(AppRoutes.apiaryEdit(apiaryId)),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [_Header(summary)],
        ),
      ),
      AsyncData() => Scaffold(appBar: AppBar(), body: const ApiaryNotFound()),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.apiariesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

class _Header extends StatelessWidget {
  const new(this.summary);

  final ApiarySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final lastVisit = summary.lastVisitAt;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(summary.apiary.name, style: context.typography.headline),
        ),
        SizedBox(height: spacing.lg),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Stat(
                  value: format.number(summary.activeHiveCount),
                  valueStyle: context.typography.number,
                  label: l10n.apiaryActiveHives,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: _Stat(
                  value: lastVisit == null
                      ? l10n.apiaryVisitNone
                      : format.date(lastVisit.toLocal()),
                  valueStyle: context.typography.subtitle,
                  label: l10n.apiaryLastVisitLabel,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Değer üstte, ne olduğu altında; ekran okuyucu ikisini birlikte okur.
class _Stat extends StatelessWidget {
  const new({
    required this.value,
    required this.valueStyle,
    required this.label,
  });

  final String value;
  final TextStyle valueStyle;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: SectionCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: valueStyle),
            SizedBox(height: context.spacing.xs),
            Text(
              label,
              style: context.typography.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
