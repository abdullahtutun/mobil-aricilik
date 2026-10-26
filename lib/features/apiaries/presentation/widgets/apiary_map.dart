import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';

/// Konumu olan arılıklar haritada pin olarak: pinde aktif kovan sayısı,
/// dikkat isteyen kovanı olan arılıkta dolu pin ve uyarı ikonu. Pine
/// dokununca arılık açılır. Atıf metni hep görünür.
class ApiaryMap extends StatelessWidget {
  const new({
    required this.basemap,
    required this.summaries,
    required this.attentionCounts,
    super.key,
  });

  final Basemap basemap;
  final List<ApiarySummary> summaries;

  /// Arılık kimliğinden dikkat isteyen kovan sayısına.
  final Map<String, int> attentionCounts;

  /// Tek arılıkta ya da arılıklar üst üsteyken bundan yakına inilmez.
  static const _fitMaxZoom = 14.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final pinBox = context.sizes.mapPin;
    final located = [
      for (final summary in summaries)
        if (summary.apiary case Apiary(:final latitude?, :final longitude?))
          (summary: summary, point: LatLng(latitude, longitude)),
    ];

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            backgroundColor: context.colors.surfaceContainer,
            // Konum yoksa dünya görünümü.
            initialCenter: const LatLng(0, 0),
            initialZoom: 2,
            initialCameraFit: located.isEmpty
                ? null
                : CameraFit.coordinates(
                    coordinates: [for (final item in located) item.point],
                    // Pin noktanın üstünde durur; üstte bir pin payı.
                    padding: EdgeInsets.fromLTRB(
                      pinBox / 2,
                      pinBox,
                      pinBox / 2,
                      pinBox / 2,
                    ),
                    maxZoom: _fitMaxZoom,
                  ),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            basemap.tileLayer(),
            MarkerLayer(
              markers: [
                for (final item in located)
                  Marker(
                    key: ValueKey(item.summary.apiary.id),
                    point: item.point,
                    width: pinBox,
                    height: pinBox,
                    alignment: Alignment.topCenter,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _ApiaryPin(
                        summary: item.summary,
                        attentionCount:
                            attentionCounts[item.summary.apiary.id] ?? 0,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (located.isEmpty)
          Positioned(
            left: spacing.lg,
            right: spacing.lg,
            top: spacing.lg,
            child: NoteCard(
              icon: Icons.location_off_rounded,
              message: l10n.apiariesMapNoLocation,
            ),
          ),
        const Positioned(right: 0, bottom: 0, child: _Attribution()),
      ],
    );
  }
}

class _ApiaryPin extends StatelessWidget {
  const new({required this.summary, required this.attentionCount});

  final ApiarySummary summary;
  final int attentionCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final warn = attentionCount > 0;
    final fill = warn ? colors.primary : colors.surface;
    final content = warn ? colors.onPrimary : colors.textPrimary;
    final hives = l10n.apiaryHiveCount(summary.activeHiveCount);

    return Semantics(
      button: true,
      label: [
        l10n.apiaryMapPinLabel(summary.apiary.name, hives),
        if (warn) l10n.apiaryMapPinAttention(attentionCount),
      ].join(l10n.listSeparator),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go(AppRoutes.apiary(summary.apiary.id)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: context.touchTargets.field,
                minHeight: context.touchTargets.field,
              ),
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(context.radii.card),
                border: Border.all(
                  color: warn ? colors.surface : colors.primary,
                  width: context.strokes.focus,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppFormat.of(context).number(summary.activeHiveCount),
                    style: context.typography.title.copyWith(color: content),
                  ),
                  if (warn) ...[
                    SizedBox(width: spacing.xs),
                    Icon(
                      Icons.error_rounded,
                      size: context.sizes.iconSmall,
                      color: content,
                    ),
                  ],
                ],
              ),
            ),
            CustomPaint(
              size: Size(spacing.lg, spacing.sm),
              painter: _PinTailPainter(colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinin altındaki, arılığın yerini gösteren üçgen.
class _PinTailPainter extends CustomPainter {
  const new(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PinTailPainter oldDelegate) => oldDelegate.color != color;
}

/// OpenFreeMap ve OpenStreetMap atfı; lisans gereği haritada hep görünür.
class _Attribution extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.radii.small),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.xs,
        ),
        child: Text(
          AppLocalizations.of(context).apiariesMapAttribution,
          style: context.typography.bodySmall.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
