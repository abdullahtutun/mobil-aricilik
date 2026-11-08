import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';
import 'package:mobil_arici/features/organization/presentation/widgets/business_avatar.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_rules.dart';

/// İşletme profili (docs/design "İşletme profili"): üstte avatar (logo ya da
/// baş harfler), ad, "ad soyad · rol" ve bölge rozeti; kovan, arılık ve
/// muayene sayıları (kayıtlardan canlı); İşletme (tür, para birimi), ekip
/// kartı, Hesap (giriş e-postası, ilk kayıt ve sezon) ve Ayarlar kısayolu.
/// Her şey yerel veriden gelir, offline açılır. Düzenle yalnız owner ve
/// partner'a görünür.
class BusinessProfileScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final profile = ref.watch(businessProfileProvider);
    final canEdit = ref.watch(canEditOrganizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.businessTitle),
        actions: [
          if (canEdit && profile != null)
            TextButton(
              onPressed: () => context.go(AppRoutes.businessEdit),
              child: Text(l10n.businessEdit),
            ),
        ],
      ),
      body: profile == null
          ? Center(
              child: EmptyState(
                icon: Icons.storefront_outlined,
                title: l10n.businessMissingTitle,
                message: l10n.businessMissingMessage,
              ),
            )
          : ListView(
              padding: EdgeInsets.all(spacing.lg),
              children: [
                _Header(profile: profile),
                SizedBox(height: spacing.lg),
                const _Counts(),
                SizedBox(height: spacing.xl),
                SectionLabel(l10n.businessSectionBusiness),
                SizedBox(height: spacing.sm),
                ListGroup(
                  children: [
                    ListRow(
                      title: l10n.businessType,
                      value: operationTypeLabel(l10n, profile.operationType),
                      onTap: canEdit
                          ? () => context.go(AppRoutes.businessEdit)
                          : null,
                    ),
                    ListRow(
                      title: l10n.businessCurrency,
                      value: profile.currency,
                      onTap: canEdit
                          ? () => context.go(AppRoutes.businessEdit)
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: spacing.lg),
                const _TeamCard(),
                SizedBox(height: spacing.xl),
                SectionLabel(l10n.businessSectionAccount),
                SizedBox(height: spacing.sm),
                _AccountGroup(profile: profile),
                SizedBox(height: spacing.lg),
                const _SettingsShortcut(),
              ],
            ),
    );
  }
}

/// "Gezginci" / "Sabit".
String operationTypeLabel(AppLocalizations l10n, OperationType type) =>
    switch (type) {
      OperationType.migratory => l10n.businessTypeMigratory,
      OperationType.stationary => l10n.businessTypeStationary,
    };

class _Header extends ConsumerWidget {
  const new({required this.profile});

  final OrganizationProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final member = ref.watch(ownMemberProfileProvider);
    final email = ref.watch(currentUserProvider.select((user) => user?.email));
    final region = ref.watch(regionConfigProvider);
    final pending = ref.watch(businessProfilePendingProvider).value ?? false;
    final country =
        countryNamesFor(
          Localizations.localeOf(context).languageCode,
        )[profile.countryCode] ??
        profile.countryCode;
    final person = activityName(email);
    final role = member?.role;
    final subtitle = switch ((person, role)) {
      (final person?, final role?) => l10n.businessPersonRole(
        person,
        roleLabel(l10n, role),
      ),
      (final person?, null) => person,
      (null, final role?) => roleLabel(l10n, role),
      (null, null) => null,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BusinessAvatar(
          name: profile.name,
          color: profile.avatarColor,
          logoPath: profile.logoPath,
          dimension: context.touchTargets.fieldLarge,
        ),
        SizedBox(width: spacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing.xs,
            children: [
              Semantics(
                header: true,
                child: Text(profile.name, style: context.typography.title),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: context.typography.body.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.xs,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(context.radii.button),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                        vertical: spacing.xs,
                      ),
                      child: Text(
                        l10n.businessRegionBadge(
                          country,
                          region.profile == RegionProfile.tr
                              ? l10n.businessRegionTr
                              : l10n.businessRegionOther,
                        ),
                        style: context.typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  if (pending)
                    StatusBadge(
                      status: AppStatus.info,
                      icon: Icons.cloud_upload_outlined,
                      label: l10n.businessPendingSync,
                      dense: true,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Kovan, arılık ve muayene sayısı; kayıtlardan canlı, elle girilmez.
class _Counts extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final counts =
        ref.watch(businessCountsProvider).value ??
        (hives: 0, apiaries: 0, inspections: 0);

    Widget tile(int count, String label) => Expanded(
      child: CountTile(count: count, value: format.number(count), label: label),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.touchTargets.gap,
        children: [
          tile(counts.hives, l10n.businessCountHives(counts.hives)),
          tile(counts.apiaries, l10n.businessCountApiaries(counts.apiaries)),
          tile(
            counts.inspections,
            l10n.businessCountInspections(counts.inspections),
          ),
        ],
      ),
    );
  }
}

/// Üst üste binen avatarlar, "Ekip · N kişi" ve owner dışındaki rollerin
/// dağılımı; dokununca Ekip ekranı açılır.
class _TeamCard extends ConsumerWidget {
  const new();

  /// Kartta en çok bu kadar avatar üst üste görünür.
  static const maxAvatars = 3;

  static const List<OrgAvatarColor> _colors = [
    OrgAvatarColor.honey,
    OrgAvatarColor.sky,
    OrgAvatarColor.slate,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final members = ref.watch(memberProfilesProvider).value ?? const [];
    final emails = ref.watch(memberEmailsProvider).value ?? const {};
    if (members.isEmpty) return const SizedBox.shrink();

    final others = [
      for (final member in members)
        if (member.role != MembershipRole.owner) member,
    ];
    final shown = (others.isEmpty ? members : others).take(maxAvatars).toList();
    final distribution = roleDistribution(members.map((m) => m.role));
    final dimension = context.sizes.avatar;
    final step = dimension - spacing.md;

    String initials(MemberProfile member) {
      final name = activityName(emails[member.userId]);
      return name == null ? '?' : nameInitials(name);
    }

    return AppCard(
      onTap: () => context.go(AppRoutes.team),
      child: MergeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.button),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: SizedBox(
                    width: dimension + step * (shown.length - 1),
                    height: dimension,
                    child: Stack(
                      children: [
                        for (final (i, member) in shown.indexed)
                          PositionedDirectional(
                            start: step * i,
                            child: InitialsAvatar(
                              text: initials(member),
                              color: _colors[i % _colors.length],
                              dimension: dimension,
                              border: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.businessTeamTitle(members.length),
                        style: context.typography.label,
                      ),
                      Text(
                        distribution.isEmpty
                            ? l10n.businessTeamSolo
                            : [
                                for (final (role, count) in distribution)
                                  roleCountLabel(l10n, role, count),
                              ].join(l10n.listSeparator),
                        style: context.typography.bodySmall.copyWith(
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
      ),
    );
  }
}

/// "1 ortak", "2 işçi", "1 danışman".
String roleCountLabel(AppLocalizations l10n, MembershipRole role, int count) =>
    switch (role) {
      MembershipRole.owner => l10n.businessRoleCountOwner(count),
      MembershipRole.partner => l10n.businessRoleCountPartner(count),
      MembershipRole.worker => l10n.businessRoleCountWorker(count),
      MembershipRole.viewer => l10n.businessRoleCountViewer(count),
    };

/// Giriş e-postası (değiştirme akışı yakında) ve ilk kayıt · sezon.
class _AccountGroup extends ConsumerWidget {
  const new({required this.profile});

  final OrganizationProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final email = ref.watch(currentUserProvider.select((user) => user?.email));
    final createdAt = profile.createdAt;

    return ListGroup(
      children: [
        ListRow(
          title: l10n.businessEmail,
          value: email ?? '–',
          // Yeni adrese kod gönderen akış ayrı adımda gelecek.
          onTap: () => showMessageSnackBar(context, l10n.businessEmailSoon),
        ),
        if (createdAt != null)
          ListRow(
            title: l10n.businessFirstRecord,
            value: l10n.businessFirstRecordValue(
              AppFormat.of(context).monthYearLong(createdAt.toLocal()),
              seasonNumber(createdAt.toLocal(), clock.now()),
            ),
          ),
      ],
    );
  }
}

/// Ayarlar'a kısayol: dil, birim, tema ve veri ayarları.
class _SettingsShortcut extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;

    return AppCard(
      onTap: () => context.go(AppRoutes.settings),
      child: MergeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.button),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_rounded,
                  size: context.sizes.icon,
                  color: colors.primary,
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Text(
                    l10n.businessSettingsShortcut,
                    style: context.typography.label,
                  ),
                ),
                SizedBox(width: spacing.md),
                Text(
                  l10n.settingsTitle,
                  style: context.typography.label.copyWith(
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
