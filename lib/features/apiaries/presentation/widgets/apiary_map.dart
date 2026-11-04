import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/services/directions_service.dart';
import 'package:mobil_arici/core/services/directions_service_provider.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/relative_date.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';

/// Konumu olan arılıklar haritada pin olarak: pinde aktif kovan sayısı,
/// dikkat isteyen kovanı olan arılıkta dolu pin ve uyarı ikonu. Pine
/// dokununca altta arılığın kartı açılır (Yol tarifi ve Göster); haritanın
/// boş yerine dokununca kapanır. Atıf metni hep görünür.
class ApiaryMap extends StatefulWidget {
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

  @override
  State<ApiaryMap> createState() => _ApiaryMapState();
}

class _ApiaryMapState extends State<ApiaryMap> {
  /// Tek arılıkta ya da arılıklar üst üsteyken bundan yakına inilmez.
  static const _fitMaxZoom = 14.0;

  /// Kartı açık arılık.
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final pinBox = context.sizes.mapPin;
    final located = [
      for (final summary in widget.summaries)
        if (summary.apiary case Apiary(:final latitude?, :final longitude?))
          (summary: summary, point: LatLng(latitude, longitude)),
    ];
    final selected = located
        .where((item) => item.summary.apiary.id == _selectedId)
        .firstOrNull;

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
            onTap: (_, _) => setState(() => _selectedId = null),
          ),
          children: [
            widget.basemap.tileLayer(),
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
                            widget.attentionCounts[item.summary.apiary.id] ?? 0,
                        onTap: () => setState(
                          () => _selectedId = item.summary.apiary.id,
                        ),
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
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (selected != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    spacing.lg,
                    0,
                    spacing.lg,
                    spacing.sm,
                  ),
                  child: _ApiaryMapCard(
                    key: ValueKey(selected.summary.apiary.id),
                    summary: selected.summary,
                    point: selected.point,
                    attentionCount:
                        widget.attentionCounts[selected.summary.apiary.id] ?? 0,
                  ),
                ),
              const _Attribution(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pine dokununca altta açılan kart: ad, kovan sayısı, dikkat isteyen
/// kovanlar ve son ziyaret; altında Yol tarifi (telefonun harita
/// uygulaması) ve Göster (arılığın sayfası).
class _ApiaryMapCard extends ConsumerWidget {
  const new({
    required this.summary,
    required this.point,
    required this.attentionCount,
    super.key,
  });

  final ApiarySummary summary;
  final LatLng point;
  final int attentionCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final lastVisit = summary.lastVisitAt;
    final details = [
      l10n.apiaryHiveCount(summary.activeHiveCount),
      if (attentionCount > 0) l10n.apiaryMapPinAttention(attentionCount),
      if (lastVisit == null)
        l10n.apiaryNoVisit
      else
        l10n.apiaryLastVisit(
          relativeDay(l10n, AppFormat.of(context), lastVisit, now: clock.now()),
        ),
    ].join(l10n.titleSeparator);

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(summary.apiary.name, style: context.typography.title),
            SizedBox(height: spacing.xs),
            Text(
              details,
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.md),
            Row(
              spacing: spacing.sm,
              children: [
                Expanded(
                  child: BigButton(
                    label: l10n.apiaryMapDirections,
                    variant: BigButtonVariant.secondary,
                    onPressed: () => _openDirections(context, ref),
                  ),
                ),
                Expanded(
                  child: BigButton(
                    label: l10n.apiaryMapShow,
                    onPressed: () =>
                        context.go(AppRoutes.apiary(summary.apiary.id)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Arılığa yol tarifi. Telefonda kurulu birden çok harita uygulaması
  /// varsa hangisiyle açılacağı sorulur; tek uygulama doğrudan açılır. Hiç
  /// bulunamazsa Google Haritalar bağlantısı (uygulama ya da tarayıcı).
  Future<void> _openDirections(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final directions = ref.read(directionsServiceProvider);
    final apps = await directions.installedApps(
      point.latitude,
      point.longitude,
    );
    if (!context.mounted) return;

    final bool opened;
    if (apps.isEmpty) {
      opened = await ref
          .read(urlLauncherServiceProvider)
          .open(apiaryDirectionsUri(point.latitude, point.longitude));
    } else {
      final app = apps.length == 1
          ? apps.single
          : await showOptionSheet<DirectionsApp>(
              context,
              (context) => OptionSheet(
                title: l10n.apiaryMapDirectionsChooseApp,
                options: [
                  for (final app in apps)
                    SheetOption(
                      value: app,
                      icon: Icons.directions_rounded,
                      label: app.name,
                    ),
                ],
              ),
            );
      // Sayfa kapatıldı.
      if (app == null) return;
      try {
        await directions.open(
          app,
          point.latitude,
          point.longitude,
          title: summary.apiary.name,
        );
        opened = true;
      } on DirectionsUnavailable {
        if (context.mounted) {
          showMessageSnackBar(context, l10n.apiaryMapDirectionsFailed);
        }
        return;
      }
    }
    if (!opened && context.mounted) {
      showMessageSnackBar(context, l10n.apiaryMapDirectionsFailed);
    }
  }
}

/// Noktaya yol tarifi adresi (Google Haritalar evrensel bağlantısı).
Uri apiaryDirectionsUri(double latitude, double longitude) => Uri.https(
  'www.google.com',
  '/maps/dir/',
  {'api': '1', 'destination': '$latitude,$longitude'},
);

class _ApiaryPin extends StatelessWidget {
  const new({
    required this.summary,
    required this.attentionCount,
    required this.onTap,
  });

  final ApiarySummary summary;
  final int attentionCount;
  final VoidCallback onTap;

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
        onTap: onTap,
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
