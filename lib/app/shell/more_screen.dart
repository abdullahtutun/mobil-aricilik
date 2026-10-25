import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

/// Seyrek kullanılan modüllerin girişi: üstte işletme kartı, altında iki
/// sütunlu modül karoları. Şimdilik yaşlı analar, Ayarlar ve Senkron var; diğer
/// modüller geldikçe kendi bölümlerine eklenir.
class MoreScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final organization = ref.watch(currentOrganizationProvider).value;
    final gap = context.touchTargets.gap;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabMore),
        actions: const [SyncStatusButton()],
      ),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          if (organization != null) ...[
            _OrganizationCard(
              name: organization.name,
              countryCode: organization.countryCode,
            ),
            SizedBox(height: spacing.xl),
          ],
          SectionLabel(l10n.hiveQueenTitle),
          SizedBox(height: spacing.sm),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: gap,
              children: [
                Expanded(
                  child: _ModuleTile(
                    icon: Icons.workspace_premium_outlined,
                    label: l10n.oldQueensTitle,
                    onTap: () => context.go(AppRoutes.oldQueens),
                  ),
                ),
                // Karo öbür bölümlerdekiyle aynı genişlikte kalsın.
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.moreSectionHelp),
          SizedBox(height: spacing.sm),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: gap,
              children: [
                Expanded(
                  child: _ModuleTile(
                    icon: Icons.settings_outlined,
                    label: l10n.settingsTitle,
                    onTap: () => context.go(AppRoutes.settings),
                  ),
                ),
                Expanded(
                  child: _ModuleTile(
                    icon: Icons.sync_rounded,
                    label: l10n.syncTitle,
                    onTap: () => context.push(AppRoutes.sync),
                  ),
                ),
              ],
            ),
          ),
          EmptyState(
            icon: Icons.grid_view_rounded,
            title: l10n.moreEmptyTitle,
            message: l10n.moreEmptyMessage,
          ),
        ],
      ),
    );
  }
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
                  dimension: context.touchTargets.fieldLarge,
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

/// Modül karosu: kart zemininde ikon ve adı; dokununca modül açılır.
class _ModuleTile extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return MergeSemantics(
      child: AppCard(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: context.touchTargets.fieldLarge,
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: context.touchTargets.minimum,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.statusInfoContainer,
                      borderRadius: BorderRadius.circular(context.radii.button),
                    ),
                    child: Icon(
                      icon,
                      size: context.sizes.icon,
                      color: colors.statusInfo,
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
