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
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/apiary_hives_section.dart';

/// Arılık detayı: üst kısım (ad, aktif kovan sayısı, son ziyaret) ve kovan
/// ızgarası/listesi. Harita şeridi ve eylem çubuğu kendi adımlarında
/// gelecek.
class ApiaryDetailScreen extends ConsumerWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final hasHives =
        ref.watch(apiaryHivesProvider(apiaryId)).value?.isNotEmpty ?? false;

    return switch (ref.watch(apiarySummaryProvider(apiaryId))) {
      AsyncData(value: final summary?) => Scaffold(
        appBar: AppBar(
          actions: [
            if (hasHives)
              IconButton(
                tooltip: l10n.hiveLabelsTitle,
                icon: const Icon(Icons.qr_code_2_rounded),
                onPressed: () => context.go(AppRoutes.hiveLabels(apiaryId)),
              ),
            IconButton(
              tooltip: l10n.apiaryEdit,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => context.go(AppRoutes.apiaryEdit(apiaryId)),
            ),
          ],
        ),
        // Kovan yokken boş durumun kendi butonu var.
        floatingActionButton: hasHives
            ? FloatingActionButton.extended(
                onPressed: () => openAddHives(context, apiaryId),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.hivesAdd),
              )
            : null,
        body: ListView(
          // Son satır kovan ekle butonunun altında kalmasın.
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            context.touchTargets.fieldLarge + spacing.xl,
          ),
          children: [
            _Header(summary),
            SizedBox(height: spacing.xl),
            ApiaryHivesSection(apiaryId: apiaryId),
          ],
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
