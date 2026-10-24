import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/relative_date.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/apiary_hives_section.dart';

/// Arılık detayı: büyük ad, altında aktif kovan sayısı ve son ziyaret;
/// kovan ekle eylemi ve kovan ızgarası/listesi. Harita şeridi ve tur,
/// toplu besleme gibi eylemler kendi adımlarında gelecek.
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
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.go(AppRoutes.apiaryEdit(apiaryId)),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            _Header(summary),
            // Kovan yokken boş durumun kendi butonu var.
            if (hasHives) ...[
              SizedBox(height: spacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: BigButton(
                  label: l10n.hivesAdd,
                  icon: Icons.add_rounded,
                  expanded: false,
                  onPressed: () => openAddHives(context, apiaryId),
                ),
              ),
            ],
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
    final lastVisit = summary.lastVisitAt;
    final visit = lastVisit == null
        ? l10n.apiaryNoVisit
        : l10n.apiaryLastVisit(
            relativeDay(
              l10n,
              AppFormat.of(context),
              lastVisit,
              now: clock.now(),
            ),
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(summary.apiary.name, style: context.typography.headline),
        ),
        SizedBox(height: context.spacing.xs),
        Text(
          l10n.apiaryDetailSubtitle(
            l10n.apiaryHiveCount(summary.activeHiveCount),
            visit,
          ),
          style: context.typography.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
