import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/business/business_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';
import 'package:mobil_arici/features/organization/presentation/widgets/business_avatar.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_rules.dart';

/// Seyrek kullanılan modüllerin girişi (docs/design "Daha fazla"): üstte
/// işletme kartı (işletme profilini açar), altında bölüm bölüm iki sütunlu
/// modül karoları. Arılık: yaşlı analar, gezginci (yalnız gezginci
/// işletmede), ana yetiştirme, hasat ve lotlar; işletme: ekip, raporlar,
/// sezon raporu, belge kasası, malzeme ve stok, finans (yalnız owner ve
/// partner), destekler (yalnız TR profilinde); yardım: bilgi bankası,
/// görüş bildir, ayarlar, senkron. Diğer modüller geldikçe kendi
/// bölümlerine eklenir.
class MoreScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final profile = ref.watch(businessProfileProvider);
    final migratory = ref.watch(
      businessConfigProvider.select((config) => config.features.migratory),
    );
    final canSeeFinance = ref.watch(canSeeFinanceProvider);
    final subsidies = ref.watch(
      regionConfigProvider.select((region) => region.features.subsidies),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            if (profile != null) ...[
              _OrganizationCard(profile: profile),
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
                // Sabit işletmede gizli; kayıtları silinmez.
                if (migratory)
                  _ModuleTile(
                    icon: Icons.local_shipping_outlined,
                    label: l10n.moreMigratory,
                    onTap: () => context.go(AppRoutes.migrations),
                  ),
                _ModuleTile(
                  icon: Icons.egg_outlined,
                  label: l10n.moreRearing,
                  onTap: () => context.go(AppRoutes.rearing),
                ),
                _ModuleTile(
                  icon: Icons.inventory_outlined,
                  label: l10n.lotsTitle,
                  onTap: () => context.go(AppRoutes.lots),
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
                  icon: Icons.insights_outlined,
                  label: l10n.seasonReportTile,
                  onTap: () => context.go(AppRoutes.season),
                ),
                _ModuleTile(
                  icon: Icons.folder_copy_outlined,
                  label: l10n.documentsTitle,
                  onTap: () => context.go(AppRoutes.documents),
                ),
                _ModuleTile(
                  icon: Icons.inventory_2_outlined,
                  label: l10n.inventoryTitle,
                  onTap: () => context.go(AppRoutes.inventory),
                ),
                if (canSeeFinance)
                  _ModuleTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: l10n.financeTitle,
                    onTap: () => context.go(AppRoutes.finance),
                  ),
                if (subsidies)
                  _ModuleTile(
                    icon: Icons.volunteer_activism_outlined,
                    label: l10n.subsidiesTitle,
                    onTap: () => context.go(AppRoutes.subsidies),
                  ),
              ],
            ),
            SizedBox(height: spacing.xl),
            _ModuleSection(
              title: l10n.moreSectionHelp,
              tone: (colors.statusInfoContainer, colors.statusInfo),
              tiles: [
                _ModuleTile(
                  icon: Icons.menu_book_outlined,
                  label: l10n.knowledgeTitle,
                  onTap: () => context.go(AppRoutes.knowledge),
                ),
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

/// İşletmenin adı, altında "ad soyad · rol · ülke"; solda avatar (logo ya
/// da baş harfler). Dokununca işletme profili açılır.
class _OrganizationCard extends ConsumerWidget {
  const new({required this.profile});

  final OrganizationProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final member = ref.watch(ownMemberProfileProvider);
    final email = ref.watch(currentUserProvider.select((user) => user?.email));
    final country = countryNamesFor(
      Localizations.localeOf(context).languageCode,
    )[profile.countryCode];
    final person = activityName(email);
    final role = member?.role;
    final details = [
      ?person,
      if (role != null) roleLabel(l10n, role),
      ?country,
    ].join(l10n.businessDetailSeparator);

    return MergeSemantics(
      child: AppCard(
        onTap: () => context.go(AppRoutes.business),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            children: [
              BusinessAvatar(
                name: profile.name,
                color: profile.avatarColor,
                logoPath: profile.logoPath,
                dimension: context.touchTargets.field,
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: context.typography.title),
                    if (details.isNotEmpty)
                      Text(
                        details,
                        style: context.typography.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: context.sizes.icon,
                color: colors.textSecondary,
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
