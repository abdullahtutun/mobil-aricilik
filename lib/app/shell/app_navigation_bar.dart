import 'package:flutter/material.dart';
import 'package:mobil_arici/app/shell/app_tab.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Alt gezinme: iki yanda ikişer sekme, ortada başparmağın altında büyük
/// Okut / Kaydet butonu.
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

  /// Ortadaki buton basılı tutulunca: hızlı kayıt menüsü.
  final VoidCallback onQuickRecord;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    Widget tab(AppTab tab) => Expanded(
      child: _TabItem(
        tab: tab,
        selected: tab == currentTab,
        onTap: () => onTabSelected(tab),
      ),
    );

    return Material(
      color: colors.surfaceContainer,
      shape: Border(
        top: BorderSide(color: colors.divider, width: context.strokes.border),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xs,
            vertical: spacing.sm,
          ),
          child: Row(
            children: [
              tab(AppTab.today),
              tab(AppTab.apiaries),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                child: _ScanButton(onTap: onScan, onLongPress: onQuickRecord),
              ),
              tab(AppTab.tasks),
              tab(AppTab.more),
            ],
          ),
        ),
      ),
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
    final foreground = selected ? colors.primary : colors.textSecondary;
    final typography = context.typography;
    final labelStyle = (selected ? typography.labelSmall : typography.bodySmall)
        .copyWith(color: foreground);

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
              Icon(
                selected ? tab.selectedIcon : tab.icon,
                size: context.sizes.icon,
                color: foreground,
              ),
              SizedBox(height: context.spacing.xs),
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

/// Dokun: okut. Basılı tut: hızlı kayıt. Tooltip yok; uzun basmayla çakışır.
class _ScanButton extends StatelessWidget {
  const new({required this.onTap, required this.onLongPress});

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final size = context.touchTargets.fieldLarge;

    return Semantics(
      container: true,
      button: true,
      onLongPressHint: l10n.scanLongPressHint,
      child: Material(
        color: colors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.card),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: size, minHeight: size),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: context.sizes.icon,
                    color: colors.onPrimary,
                  ),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    l10n.scanTitle,
                    maxLines: 1,
                    style: context.typography.labelSmall.copyWith(
                      color: colors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
