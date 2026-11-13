import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/services/basemap_service_provider.dart';
import 'package:mobil_arici/core/services/place_search_service.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/presentation/place_search_controller.dart';

/// Arılığın konumunu haritada seçme: üstte il, ilçe ya da yer araması,
/// ortada sabit iğne; harita kaydırılınca iğnenin altındaki nokta seçilir.
/// "Bu konumu seç" noktayı [LatLng] olarak geri döner; kapatınca null.
class ApiaryLocationPickerScreen extends ConsumerStatefulWidget {
  const new({super.key, this.initial});

  /// Formdaki mevcut konum; yoksa dünya görünümüyle açılır.
  final LatLng? initial;

  @override
  ConsumerState<ApiaryLocationPickerScreen> createState() =>
      _ApiaryLocationPickerScreenState();
}

class _ApiaryLocationPickerScreenState
    extends ConsumerState<ApiaryLocationPickerScreen> {
  /// Mevcut konumla açılınca arılığın çevresi seçilebilecek kadar yakın.
  static const _initialZoom = 15.0;

  /// Sınırı bilinmeyen arama sonucunda bu yakınlıkta açılır.
  static const _resultZoom = 13.0;

  /// Aranan yerin sınırına sığdırırken bundan yakına inilmez.
  static const _fitMaxZoom = 15.0;

  final _mapController = MapController();
  final _query = TextEditingController();
  late LatLng _center = widget.initial ?? const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    // Altlık uygulama boyunca tutulur; önceki açılışta yüklenemediyse
    // hata da tutulur. Ekran her açılışta yeniden dener, internet arada
    // gelmiş olabilir (Arılıklar'daki harita sekmesi gibi; P9.2 madde 2).
    if (ref.read(basemapProvider).hasError) ref.invalidate(basemapProvider);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _query.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    unawaited(
      ref
          .read(placeSearchControllerProvider.notifier)
          .search(
            _query.text,
            languageCode: Localizations.localeOf(context).languageCode,
          ),
    );
  }

  void _select(PlaceResult place) {
    FocusScope.of(context).unfocus();
    ref.read(placeSearchControllerProvider.notifier).clear();
    final bounds = place.bounds;
    if (bounds == null) {
      _mapController.move(LatLng(place.latitude, place.longitude), _resultZoom);
    } else {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds(
            LatLng(bounds.south, bounds.west),
            LatLng(bounds.north, bounds.east),
          ),
          padding: EdgeInsets.all(context.spacing.lg),
          maxZoom: _fitMaxZoom,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final basemap = ref.watch(basemapProvider);
    final search = ref.watch(placeSearchControllerProvider);
    final mapReady = basemap is AsyncData<Basemap>;

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.locationPickerTitle),
      ),
      body: BottomActionLayout(
        separated: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: TextField(
                controller: _query,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.words,
                style: context.typography.body,
                decoration: InputDecoration(
                  hintText: l10n.locationPickerSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    tooltip: l10n.locationPickerSearch,
                    constraints: BoxConstraints.tight(
                      Size.square(context.touchTargets.field),
                    ),
                    onPressed: _search,
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ),
                onSubmitted: (_) => _search(),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  switch (basemap) {
                    AsyncData(:final value) => _PickerMap(
                      basemap: value,
                      controller: _mapController,
                      initialCenter: _center,
                      initialZoom: widget.initial == null ? 2 : _initialZoom,
                      onCenterChanged: (center) =>
                          setState(() => _center = center),
                    ),
                    AsyncValue(isLoading: true) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    AsyncValue() => ListView(
                      padding: EdgeInsets.all(spacing.lg),
                      children: [
                        NoteCard(
                          icon: Icons.cloud_off_rounded,
                          title: l10n.apiariesMapOfflineTitle,
                          message: l10n.locationPickerMapOfflineMessage,
                          child: BigButton(
                            label: l10n.actionRetry,
                            icon: Icons.refresh_rounded,
                            variant: BigButtonVariant.secondary,
                            onPressed: () => ref.invalidate(basemapProvider),
                          ),
                        ),
                      ],
                    ),
                  },
                  if (search != null)
                    Positioned.fill(
                      child: _SearchResults(search, onSelect: _select),
                    ),
                ],
              ),
            ),
          ],
        ),
        action: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (mapReady) ...[
              Text(
                AppFormat.of(context)
                    .coordinates(_center.latitude, _center.longitude),
                textAlign: TextAlign.center,
                style: context.typography.label,
              ),
              SizedBox(height: spacing.sm),
            ],
            BigButton(
              label: l10n.locationPickerConfirm,
              icon: Icons.check_rounded,
              onPressed: mapReady ? () => context.pop(_center) : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Harita, ortada sabit iğne ve atıf. İğnenin ucu haritanın tam ortası.
class _PickerMap extends StatelessWidget {
  const new({
    required this.basemap,
    required this.controller,
    required this.initialCenter,
    required this.initialZoom,
    required this.onCenterChanged,
  });

  final Basemap basemap;
  final MapController controller;
  final LatLng initialCenter;
  final double initialZoom;
  final ValueChanged<LatLng> onCenterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final pinSize = context.sizes.illustrationIcon;

    return Stack(
      children: [
        FlutterMap(
          mapController: controller,
          options: MapOptions(
            backgroundColor: colors.surfaceContainer,
            initialCenter: initialCenter,
            initialZoom: initialZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            onPositionChanged: (camera, hasGesture) =>
                onCenterChanged(camera.center),
          ),
          children: [basemap.tileLayer()],
        ),
        IgnorePointer(
          child: Center(
            child: Transform.translate(
              // İkonun alt ucu noktayı gösterir.
              offset: Offset(0, -pinSize / 2),
              child: Semantics(
                label: l10n.locationPickerPinLabel,
                child: Icon(
                  Icons.location_on_rounded,
                  size: pinSize,
                  color: colors.primary,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: spacing.lg,
          right: spacing.lg,
          top: spacing.lg,
          child: IgnorePointer(
            child: NoteCard(message: l10n.locationPickerHint),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
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
                l10n.apiariesMapAttribution,
                style: context.typography.bodySmall.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Arama sürerken gösterge, sonuçlar, sonuç yok ya da internet yok; haritanın
/// üstünü kaplar.
class _SearchResults extends StatelessWidget {
  const new(this.search, {required this.onSelect});

  final AsyncValue<List<PlaceResult>> search;
  final ValueChanged<PlaceResult> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return ColoredBox(
      color: context.colors.surface,
      child: switch (search) {
        AsyncData(:final value) when value.isNotEmpty => ListView(
          padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.lg),
          children: [
            ListGroup(
              children: [
                for (final place in value)
                  ListRow(
                    title: place.name,
                    subtitle: place.displayName,
                    onTap: () => onSelect(place),
                  ),
              ],
            ),
          ],
        ),
        AsyncData() => _Message(
          icon: Icons.search_off_rounded,
          message: l10n.locationPickerNoResults,
        ),
        AsyncError() => _Message(
          icon: Icons.cloud_off_rounded,
          message: l10n.locationPickerSearchOffline,
        ),
        AsyncValue() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Message extends StatelessWidget {
  const new({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        context.spacing.lg,
        0,
        context.spacing.lg,
        context.spacing.lg,
      ),
      children: [
        Semantics(
          liveRegion: true,
          child: NoteCard(icon: icon, message: message),
        ),
      ],
    );
  }
}
