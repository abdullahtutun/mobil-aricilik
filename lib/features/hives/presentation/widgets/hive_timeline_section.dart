import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive_timeline.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/inspection_labels.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/presentation/widgets/media_strip.dart';

/// Kovan kartındaki zaman tüneli (teknik.md §9): kovanın bütün olayları
/// ikonlu ve en yeni önce; foto küçük resimleri ve sesli notlar satır
/// içinde. Yeni kayıt geldikçe (bu telefonda ya da
/// senkronla) kendiliğinden güncellenir. Olay yoksa hiç çizilmez.
class HiveTimelineSection extends ConsumerWidget {
  const new({required this.hiveId, super.key});

  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Yeniden kurulurken önceki liste görünür kalsın.
    final events = ref.watch(hiveTimelineProvider(hiveId)).value ?? const [];
    if (events.isEmpty) return const SizedBox.shrink();
    final apiaries =
        ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[];
    final apiaryNames = {
      for (final summary in apiaries) summary.apiary.id: summary.apiary.name,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.hiveTimelineTitle, style: context.typography.title),
        ),
        SizedBox(height: context.spacing.lg),
        for (final (i, event) in events.indexed)
          _EventTile(
            key: ValueKey(event.id),
            event: event,
            apiaryNames: apiaryNames,
            isLast: i == events.length - 1,
          ),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  const new({
    required this.event,
    required this.apiaryNames,
    required this.isLast,
    super.key,
  });

  final HiveTimelineEvent event;

  /// Silinen ya da bu telefona henüz inmeyen arılık yok.
  final Map<String, String> apiaryNames;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final time = AppFormat.of(context).dateTime(event.at.toLocal());
    String apiary(String id) => apiaryNames[id] ?? l10n.timelineUnknownApiary;

    return switch (event) {
      InspectionEvent(:final inspection, :final media) => TimelineTile(
        icon: Icons.fact_check_rounded,
        title: l10n.timelineInspection,
        time: time,
        details: inspectionSummary(l10n, inspection.values),
        footer: media.isEmpty ? null : MediaStrip(media),
        isLast: isLast,
      ),
      MediaEvent(:final media) => TimelineTile(
        icon: switch (media.kind) {
          MediaKind.photo => Icons.photo_camera_rounded,
          MediaKind.audio => Icons.mic_rounded,
        },
        title: switch (media.kind) {
          MediaKind.photo => l10n.timelinePhoto,
          MediaKind.audio => l10n.timelineVoiceNote,
        },
        time: time,
        // Sesli notun süresi Dinle butonunda yazar.
        footer: MediaStrip([media]),
        isLast: isLast,
      ),
      LocationEvent(fromApiaryId: null, :final toApiaryId) => TimelineTile(
        icon: Icons.add_location_alt_rounded,
        title: l10n.timelineAdded,
        time: time,
        details: [apiary(toApiaryId)],
        isLast: isLast,
      ),
      LocationEvent(:final fromApiaryId?, :final toApiaryId) => TimelineTile(
        icon: Icons.local_shipping_rounded,
        title: l10n.timelineMoved,
        time: time,
        details: [
          l10n.timelineMoveRoute(apiary(fromApiaryId), apiary(toApiaryId)),
        ],
        isLast: isLast,
      ),
    };
  }
}
