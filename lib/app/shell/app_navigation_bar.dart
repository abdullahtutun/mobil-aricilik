import 'package:flutter/material.dart';
import 'package:mobil_arici/app/shell/app_tab.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Alt gezinme: iki yanda ikişer sekme, ortada başparmağın altında büyük
/// yuvarlak Okut butonu. Seçili sekmenin ikonu kart zemininde bir hapın
/// içinde, etiket koyu bal ve kalın; seçim yalnız renkle verilmez.
class AppNavigationBar extends StatelessWidget {
  const new({
    required this.currentTab,
    required this.onTabSelected,
    required this.onScan,
    required this.onQuickRecord,
    super.key,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  /// Ortadaki butona dokunulunca: okutma.
  final VoidCallback onScan;

  /// Ortadaki buton basılı tutulunca: hızlı kayıt menüsü. Null ise (viewer
  /// kayıt giremez) basılı tutmak bir şey yapmaz.
  final VoidCallback? onQuickRecord;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final halo = spacing.xs;
    // Okut, çevresindeki zemin halkasıyla barın üst çizgisinden taşar.
    final overhang =
        context.touchTargets.fieldLarge +
        2 * halo -
        context.touchTargets.field -
        spacing.sm;

    Widget tab(AppTab tab) => Expanded(
      child: _TabItem(
        tab: tab,
        selected: tab == currentTab,
        onTap: () => onTabSelected(tab),
      ),
    );

    return Stack(
      children: [
        Positioned.fill(
          top: overhang,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                top: BorderSide(
                  color: colors.divider,
                  width: context.strokes.border,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(spacing.xs, 0, spacing.xs, spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                tab(AppTab.today),
                tab(AppTab.apiaries),
                _ScanButton(
                  halo: halo,
                  onTap: onScan,
                  onLongPress: onQuickRecord,
                ),
                tab(AppTab.tasks),
                tab(AppTab.more),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const new({required this.tab, required this.selected, required this.onTap});

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final foreground = selected ? colors.primary : colors.textSecondary;
    final typography = context.typography;
    final labelStyle = typography.navLabel.copyWith(
      color: foreground,
      fontWeight: selected ? FontWeight.w700 : null,
    );

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radii.button),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? colors.surfaceContainer : colors.surface,
                  borderRadius: BorderRadius.circular(context.radii.pill),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.xs,
                  ),
                  child: Icon(
                    tab.icon,
                    size: context.sizes.icon,
                    color: foreground,
                  ),
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                tab.label(AppLocalizations.of(context)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: labelStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dokun: okut. Basılı tut: hızlı kayıt. Zemin halkalı koyu bal daire,
/// içinde okutma çerçevesi; adı ekran okuyucuya gider. Tooltip yok; uzun
/// basmayla çakışır.
class _ScanButton extends StatelessWidget {
  const new({
    required this.halo,
    required this.onTap,
    required this.onLongPress,
  });

  final double halo;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final size = context.touchTargets.fieldLarge;
    final iconSize = context.sizes.icon;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
      child: Padding(
        padding: EdgeInsets.all(halo),
        child: Semantics(
          container: true,
          button: true,
          onLongPressHint: onLongPress == null ? null : l10n.scanLongPressHint,
          child: Material(
            color: colors.primary,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: SizedBox.square(
                dimension: size,
                // Köşeli çerçeve ve ortasında okuma çizgisi.
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.crop_free_rounded,
                      size: iconSize,
                      color: colors.onPrimary,
                      semanticLabel: l10n.scanTitle,
                    ),
                    IgnorePointer(
                      child: SizedBox(
                        width: iconSize / 2,
                        height: context.strokes.focus,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.onPrimary,
                            borderRadius: BorderRadius.circular(
                              context.radii.pill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
