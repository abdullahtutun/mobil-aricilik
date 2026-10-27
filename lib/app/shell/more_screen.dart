import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

/// Seyrek kullanılan modüllerin girişi (docs/design "Daha fazla"): üstte
/// işletme kartı, altında bölüm bölüm iki sütunlu modül karoları. Arılık:
/// yaşlı analar; işletme: ekip, raporlar, belge kasası; yardım: görüş
/// bildir, ayarlar, senkron.
/// Diğer modüller geldikçe kendi bölümlerine eklenir.
class MoreScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final organization = ref.watch(currentOrganizationProvider).value;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            if (organization != null) ...[
              _OrganizationCard(
                name: organization.name,
                countryCode: organization.countryCode,
              ),
              SizedBox(height: spacing.xl),
            ],
            _ModuleSection(
              title: l10n.moreSectionApiary,
              tone: (colors.surfaceContainer, colors.primary),
              tiles: [
                _ModuleTile(
                  icon: Icons.workspace_premium_outlined,
                  label: l10n.oldQueensTitle,
                  onTap: () => context.go(AppRoutes.oldQueens),
                ),
              ],
            ),
            SizedBox(height: spacing.xl),
            _ModuleSection(
              title: l10n.moreSectionBusiness,
              tone: (colors.statusGoodContainer, colors.secondary),
              tiles: [
                _ModuleTile(
                  icon: Icons.group_outlined,
                  label: l10n.teamTitle,
                  onTap: () => context.go(AppRoutes.team),
                ),
                _ModuleTile(
                  icon: Icons.picture_as_pdf_outlined,
                  label: l10n.reportsTitle,
                  onTap: () => context.go(AppRoutes.reports),
                ),
                _ModuleTile(
                  icon: Icons.folder_copy_outlined,
                  label: l10n.documentsTitle,
                  onTap: () => context.go(AppRoutes.documents),
                ),
              ],
            ),
            SizedBox(height: spacing.xl),
            _ModuleSection(
              title: l10n.moreSectionHelp,
              tone: (colors.statusInfoContainer, colors.statusInfo),
              tiles: [
                _ModuleTile(
                  icon: Icons.feedback_outlined,
                  label: l10n.moreFeedback,
                  onTap: () => context.go(AppRoutes.feedback),
                ),
                _ModuleTile(
                  icon: Icons.settings_outlined,
                  label: l10n.settingsTitle,
                  onTap: () => context.go(AppRoutes.settings),
                ),
                _ModuleTile(
                  icon: Icons.sync_rounded,
                  label: l10n.syncTitle,
                  onTap: () => context.push(AppRoutes.sync),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bölüm başlığı ve altında iki sütunlu karolar; tek kalan karo da yarım
/// genişlikte. Bölümün karoları aynı renk tonunda ([tone]: zemin, ikon).
class _ModuleSection extends StatelessWidget {
  const new({required this.title, required this.tone, required this.tiles});

  final String title;
  final (Color, Color) tone;
  final List<_ModuleTile> tiles;

  @override
  Widget build(BuildContext context) {
    final gap = context.touchTargets.gap;
    return _ModuleTone(
      tone: tone,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: gap,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: context.spacing.xs),
            child: SectionLabel(title),
          ),
          for (var i = 0; i < tiles.length; i += 2)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: gap,
                children: [
                  Expanded(child: tiles[i]),
                  Expanded(
                    child: i + 1 < tiles.length
                        ? tiles[i + 1]
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Bölümün karolarına renk tonunu taşır.
class _ModuleTone extends InheritedWidget {
  const new({required this.tone, required super.child});

  final (Color, Color) tone;

  static (Color, Color)? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ModuleTone>()?.tone;

  @override
  bool updateShouldNotify(_ModuleTone oldWidget) => tone != oldWidget.tone;
}

/// İşletmenin adı ve ülkesi; solda baş harfleri çam yeşili dairede.
class _OrganizationCard extends StatelessWidget {
  const new({required this.name, required this.countryCode});

  final String name;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final initials = format.upperCase(
      name
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .take(2)
          .map((word) => word.characters.first)
          .join(),
    );
    final country = countryNamesFor(
      Localizations.localeOf(context).languageCode,
    )[countryCode];

    return MergeSemantics(
      child: AppCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            children: [
              ExcludeSemantics(
                child: SizedBox.square(
                  dimension: context.touchTargets.field,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.secondary,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: context.typography.title.copyWith(
                          color: colors.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: context.typography.title),
                    if (country != null)
                      Text(
                        country,
                        style: context.typography.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modül karosu: bölümün tonunda ikon kutusu ve adı; dokununca modül
/// açılır.
class _ModuleTile extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final (background, foreground) =
        _ModuleTone.of(context) ??
        (colors.statusInfoContainer, colors.statusInfo);

    return MergeSemantics(
      child: AppCard(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: context.sizes.avatar,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(context.radii.button),
                    ),
                    child: Icon(
                      icon,
                      size: context.sizes.iconSmall,
                      color: foreground,
                    ),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(child: Text(label, style: context.typography.label)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
