import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/design_system/app_theme.dart';
import 'package:mobil_aricilik/core/design_system/appearance_settings.dart';
import 'package:mobil_aricilik/core/design_system/theme_context.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

/// Galeride ve golden testlerde gösterilen dört görünüm.
enum GalleryTheme {
  light(AppearanceSettings(colorMode: AppColorMode.light)),
  dark(AppearanceSettings(colorMode: AppColorMode.dark)),
  sun(AppearanceSettings(colorMode: AppColorMode.sun)),
  glove(AppearanceSettings(colorMode: AppColorMode.light, gloveMode: true));

  new(this.settings);

  final AppearanceSettings settings;

  ThemeData get theme => switch (AppTheme.themeMode(settings)) {
    ThemeMode.dark => AppTheme.dark(settings),
    _ => AppTheme.light(settings),
  };

  String label(AppLocalizations l10n) => switch (this) {
    GalleryTheme.light => l10n.galleryThemeLight,
    GalleryTheme.dark => l10n.galleryThemeDark,
    GalleryTheme.sun => l10n.galleryThemeSun,
    GalleryTheme.glove => l10n.galleryThemeGlove,
  };
}

/// [child]'ı dört temada alt alta, her biri kendi zemini ve adıyla çizer.
class GalleryThemePanels extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.spacing.md,
      children: [
        for (final theme in GalleryTheme.values)
          Theme(
            data: theme.theme,
            child: _ThemePanel(label: theme.label(l10n), child: child),
          ),
      ],
    );
  }
}

class _ThemePanel extends StatelessWidget {
  const new({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radii.card),
        side: BorderSide(color: colors.divider, width: context.strokes.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: context.typography.label.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
