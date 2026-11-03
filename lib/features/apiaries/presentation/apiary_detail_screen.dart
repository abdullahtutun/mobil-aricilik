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
import 'package:mobil_arici/features/health/presentation/widgets/varroa_chart.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/apiary_hives_section.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_providers.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_screen.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';

/// ⋮ menüsünde "Kovan ekle"; öbür öğelerin değeri rota yolu.
const _addHivesValue = 'add-hives';

/// Arılık detayı: büyük ad, altında aktif kovan sayısı, son ziyaret ve (hava
/// paketinde varsa) il/ilçe; tur, toplu besleme, toplu ilaçlama ve hasat
/// eylemleri, kovan ızgarası/listesi ve altında son varroa ölçümlerinin
/// grafiği. Kovan ekle ⋮ menüsünde. Harita şeridi kendi adımında gelecek.
class ApiaryDetailScreen extends ConsumerWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final hives = ref.watch(apiaryHivesProvider(apiaryId)).value ?? const [];
    final hasHives = hives.isNotEmpty;
    final canWrite = ref.watch(canWriteRecordsProvider);
    // Toplu besleme ve ilaçlama formları bir aktif kovanla açılır; arılığın
    // tümü seçili gelir.
    final anchorHive = hives.where(canInspect).firstOrNull;
    final canTour = canWrite && anchorHive != null;
    final touring = ref.watch(currentTourProvider).value?.apiaryId == apiaryId;
    final padded = EdgeInsets.symmetric(horizontal: spacing.lg);
    final place = ref.watch(apiaryPlaceProvider(apiaryId));

    return switch (ref.watch(apiarySummaryProvider(apiaryId))) {
      AsyncData(value: final summary?) => Scaffold(
        appBar: AppBar(
          actions: [
            // Seyrek eylemler ⋮ menüsünde (docs/design "Arılık detayı").
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) => value == _addHivesValue
                  ? openAddHives(context, apiaryId)
                  : context.go(value),
              itemBuilder: (context) => [
                if (canWrite)
                  PopupMenuItem(
                    value: _addHivesValue,
                    child: Text(l10n.hivesAdd),
                  ),
                if (hasHives)
                  PopupMenuItem(
                    value: AppRoutes.hiveLabels(apiaryId),
                    child: Text(l10n.hiveLabelsTitle),
                  ),
                if (canWrite)
                  PopupMenuItem(
                    value: AppRoutes.apiaryEdit(apiaryId),
                    child: Text(l10n.apiaryEdit),
                  ),
              ],
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: spacing.lg),
          children: [
            Padding(
              padding: padded,
              child: _Header(summary, place: place),
            ),
            // Kovan yokken boş durumun kendi butonu var.
            if (hasHives) ...[
              SizedBox(height: spacing.lg),
              // Eylemler tek satırda; sığmayanlar yana kayar.
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: padded,
                child: Row(
                  spacing: context.touchTargets.gap,
                  children: [
                    if (canTour)
                      BigButton(
                        label: touring
                            ? l10n.apiaryTourResume
                            : l10n.apiaryTourStart,
                        icon: Icons.play_arrow_rounded,
                        expanded: false,
                        onPressed: () => openApiaryTour(context, ref, apiaryId),
                      ),
                    if (canTour) ...[
                      BigButton(
                        variant: BigButtonVariant.secondary,
                        label: l10n.apiaryBulkFeed,
                        expanded: false,
                        // push: kapanınca kovan kartına değil, arılığa dönülür.
                        onPressed: () => context.push(
                          AppRoutes.hiveFeed(
                            apiaryId,
                            anchorHive.id,
                            wholeApiary: true,
                          ),
                        ),
                      ),
                      BigButton(
                        variant: BigButtonVariant.secondary,
                        label: l10n.apiaryBulkTreat,
                        expanded: false,
                        onPressed: () => context.push(
                          AppRoutes.hiveTreat(
                            apiaryId,
                            anchorHive.id,
                            wholeApiary: true,
                          ),
                        ),
                      ),
                    ],
                    if (canWrite)
                      BigButton(
                        variant: BigButtonVariant.secondary,
                        label: l10n.apiaryHarvest,
                        expanded: false,
                        onPressed: () =>
                            context.go(AppRoutes.apiaryHarvest(apiaryId)),
                      ),
                  ],
                ),
              ),
            ],
            SizedBox(height: spacing.xl),
            Padding(
              padding: padded,
              child: ApiaryHivesSection(apiaryId: apiaryId),
            ),
            // Sahada önce kovanlar görünsün; grafik altta.
            if (hasHives) ...[
              SizedBox(height: spacing.xl),
              Padding(
                padding: padded,
                child: ApiaryVarroaCard(
                  apiaryId: apiaryId,
                  title: l10n.varroaChartTitle(l10n.hiveVarroa),
                ),
              ),
            ],
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
  const new(this.summary, {this.place});

  final ApiarySummary summary;

  /// İl/ilçe; konum ya da hava paketi yoksa null.
  final String? place;

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
          switch (place) {
            final place? => l10n.apiaryDetailSubtitlePlace(
              l10n.apiaryHiveCount(summary.activeHiveCount),
              visit,
              place,
            ),
            _ => l10n.apiaryDetailSubtitle(
              l10n.apiaryHiveCount(summary.activeHiveCount),
              visit,
            ),
          },
          style: context.typography.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
