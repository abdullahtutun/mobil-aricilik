import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/role_permissions.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';
import 'package:mobil_arici/features/team/domain/activity_rules.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:mobil_arici/features/team/presentation/join_code_sheet.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_rules.dart';

/// Ekip (docs/design "Ekip"): üye listesi, owner için rol değiştirme ve
/// çıkarma, owner ve partner için davet kodu, herkes için "Koda sahibim",
/// altta "Son işlemler". Davet ve üyelik işlemleri online çalışır;
/// çevrimdışıyken ne yapılacağı yazılır. Son işlemler yerel DB'den gelir.
/// Tasarımdaki son görülme yok: karşılığı olan veri henüz yok. Hesabını
/// silmeyi onaylamış üye "Hesabını siliyor · tarih" diye görünür; bekleme
/// süresinde rolü değiştirilmez, ekipten çıkarılamaz.
class TeamScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final role = ref.watch(currentRoleProvider);
    final members = ref.watch(memberProfilesProvider).value ?? const [];
    final emails = ref.watch(memberEmailsProvider).value ?? const {};
    final selfId = ref.watch(currentUserProvider.select((user) => user?.id));
    final selfEmail = ref.watch(currentUserProvider.select((u) => u?.email));
    final manage = canManageMembers(role);

    // Kendin en üstte, sonra eklenme sırası.
    final ordered = [
      ...members.where((m) => m.userId == selfId),
      ...members.where((m) => m.userId != selfId),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.teamTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            if (ordered.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xl),
                child: Text(
                  l10n.teamMembersEmpty,
                  style: context.typography.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              )
            else
              ListGroup(
                children: [
                  for (final member in ordered)
                    _MemberRow(
                      member: member,
                      isSelf: member.userId == selfId,
                      email: member.userId == selfId
                          ? selfEmail
                          : emails[member.userId],
                      onTap:
                          canChangeMember(
                            manage: manage,
                            isSelf: member.userId == selfId,
                            role: member.role,
                            deletionScheduledFor: member.deletionScheduledFor,
                          )
                          ? () => _openMemberActions(
                              context,
                              ref,
                              member,
                              emails[member.userId],
                            )
                          : null,
                    ),
                ],
              ),
            if (canInvite(role)) ...[
              SizedBox(height: spacing.xl),
              const _InviteCard(),
            ],
            SizedBox(height: spacing.xl),
            BigButton(
              label: l10n.teamHaveCode,
              icon: Icons.key_rounded,
              variant: BigButtonVariant.secondary,
              onPressed: () => _openJoinSheet(context),
            ),
            SizedBox(height: spacing.xl),
            const _RecentActivity(),
          ],
        ),
      ),
    );
  }

  Future<void> _openMemberActions(
    BuildContext context,
    WidgetRef ref,
    MemberProfile member,
    String? email,
  ) async {
    final l10n = AppLocalizations.of(context);
    final name = email ?? l10n.teamMemberUnknown;
    final action = await showOptionSheet<_MemberAction>(
      context,
      (context) => OptionSheet<_MemberAction>(
        title: name,
        options: [
          for (final action in _MemberAction.values)
            if (action.role case final role?)
              SheetOption(
                value: action,
                icon: Icons.badge_outlined,
                label: roleLabel(l10n, role),
                hint: roleHint(l10n, role),
                selected: role == member.role,
              ),
          SheetOption(
            value: _MemberAction.remove,
            icon: Icons.person_remove_outlined,
            iconColor: context.colors.statusCritical,
            label: l10n.teamRemoveAction,
          ),
        ],
      ),
    );
    if (action == null || !context.mounted) return;

    final actions = ref.read(teamActionsProvider);
    switch (action.role) {
      case final role?:
        if (role == member.role) return;
        await _run(
          context,
          () => actions.setRole(member.userId, role),
          done: l10n.teamRoleChanged(name, roleLabel(l10n, role)),
        );
      case null:
        final confirmed = await showConfirmDialog(
          context,
          title: l10n.teamRemoveTitle,
          message: l10n.teamRemoveMessage(name),
          confirmLabel: l10n.teamRemoveConfirm,
        );
        if (!confirmed || !context.mounted) return;
        await _run(
          context,
          () => actions.remove(member.userId),
          done: l10n.teamRemoved(name),
        );
    }
  }

  Future<void> _openJoinSheet(BuildContext context) async {
    final joined = await showJoinCodeSheet(context);
    if (!joined || !context.mounted) return;
    showMessageSnackBar(context, AppLocalizations.of(context).teamJoinDone);
  }
}

/// Üye satırına dokununca seçilen işlem: yeni rol ya da çıkarma.
enum _MemberAction {
  partner(MembershipRole.partner),
  worker(MembershipRole.worker),
  viewer(MembershipRole.viewer),
  remove(null);

  new(this.role);

  final MembershipRole? role;
}

/// İşlemi çalıştırır; başarıda [done], hatada anlaşılır mesaj gösterir.
Future<void> _run(
  BuildContext context,
  Future<void> Function() action, {
  required String done,
}) async {
  final l10n = AppLocalizations.of(context);
  try {
    await action();
    if (context.mounted) showMessageSnackBar(context, done);
  } on TeamServiceException catch (error) {
    if (context.mounted) {
      showMessageSnackBar(context, failureMessage(l10n, error.failure));
    }
  }
}

class _MemberRow extends StatelessWidget {
  const new({
    required this.member,
    required this.isSelf,
    required this.email,
    required this.onTap,
  });

  final MemberProfile member;
  final bool isSelf;
  final String? email;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final base = email ?? l10n.teamMemberUnknown;
    final name = isSelf ? l10n.teamMemberSelf(base) : base;
    final initial = AppFormat.of(context).upperCase(base.characters.first);

    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: context.touchTargets.field),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: SizedBox.square(
                dimension: context.sizes.avatar,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelf ? colors.secondary : colors.primary,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: context.typography.label.copyWith(
                        color: isSelf ? colors.onSecondary : colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: context.typography.label),
                  if (member.role == MembershipRole.viewer)
                    Text(
                      l10n.teamRoleViewerSubtitle,
                      style: context.typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  // Renk tek başına kalmaz: ikon ve kelimeyle.
                  if (member.deletionScheduledFor case final scheduled?)
                    Padding(
                      padding: EdgeInsets.only(top: spacing.xs),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hourglass_top_rounded,
                            size: context.sizes.iconSmall,
                            color: colors.statusWarning,
                          ),
                          SizedBox(width: spacing.xs),
                          Flexible(
                            child: Text(
                              l10n.teamMemberLeaving(
                                AppFormat.of(context).date(scheduled.toLocal()),
                              ),
                              style: context.typography.bodySmall.copyWith(
                                color: colors.statusWarning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: spacing.md),
            _RolePill(role: member.role),
            if (onTap != null) ...[
              SizedBox(width: spacing.xs),
              Icon(
                Icons.more_vert_rounded,
                size: context.sizes.iconSmall,
                color: colors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
    return MergeSemantics(
      child: onTap == null ? row : InkWell(onTap: onTap, child: row),
    );
  }
}

class _RolePill extends StatelessWidget {
  const new({required this.role});

  final MembershipRole role;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.md,
          vertical: context.spacing.sm,
        ),
        child: Text(
          roleLabel(AppLocalizations.of(context), role),
          style: context.typography.labelSmall.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Koyu davet kartı: rol seçimi, kod ve Kopyala. Kod rol seçilip "Kod üret"e
/// basılınca üretilir; rol değişince eski kod silinir.
class _InviteCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final state = ref.watch(inviteControllerProvider);
    final controller = ref.read(inviteControllerProvider.notifier);
    final onCard = colors.onInverseSurface;
    final invite = state.invite;

    return Material(
      color: colors.inverseSurface,
      borderRadius: BorderRadius.circular(context.radii.card),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.teamInviteTitle,
              style: context.typography.title.copyWith(color: onCard),
            ),
            SizedBox(height: spacing.sm),
            Text(
              l10n.teamInviteHint,
              style: context.typography.body.copyWith(color: onCard),
            ),
            SizedBox(height: spacing.lg),
            if (invite == null)
              _CardButton(
                label: l10n.teamInviteGenerate,
                icon: Icons.add_rounded,
                filled: true,
                onPressed: state.busy ? null : () => _generate(context, ref),
              )
            else
              _CodeBox(invite: invite),
            SizedBox(height: spacing.md),
            Row(
              spacing: spacing.sm,
              children: [
                for (final role in invitableRoles)
                  Expanded(
                    child: _CardButton(
                      label: roleLabel(l10n, role),
                      icon: role == state.role ? Icons.check_rounded : null,
                      filled: role == state.role,
                      onPressed: () => controller.selectRole(role),
                    ),
                  ),
              ],
            ),
            SizedBox(height: spacing.md),
            Text(
              roleHint(l10n, state.role),
              style: context.typography.bodySmall.copyWith(color: onCard),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(inviteControllerProvider.notifier).generate();
    } on TeamServiceException catch (error) {
      if (context.mounted) {
        showMessageSnackBar(context, failureMessage(l10n, error.failure));
      }
    }
  }
}

class _CodeBox extends StatelessWidget {
  const new({required this.invite});

  final Invite invite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onInverseSurface.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.radii.button),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                label: l10n.teamInviteCodeSemantics(
                  invite.code.split('').join(' '),
                ),
                excludeSemantics: true,
                child: Text(
                  invite.code,
                  style: context.typography.number.copyWith(
                    color: colors.inversePrimary,
                    letterSpacing: spacing.sm,
                  ),
                ),
              ),
            ),
            _CardButton(
              label: l10n.teamInviteCopy,
              icon: Icons.copy_rounded,
              filled: true,
              expanded: false,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: invite.code));
                if (context.mounted) {
                  showMessageSnackBar(context, l10n.teamInviteCopied);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Koyu kart üstündeki buton: dolu (bal) ya da çerçeveli. Seçili durumu
/// dolgunun yanında onay ikonu da taşır.
class _CardButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    required this.filled,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = filled ? colors.inverseSurface : colors.onInverseSurface;
    final icon = this.icon;
    return Semantics(
      button: true,
      selected: filled,
      excludeSemantics: true,
      label: label,
      onTap: onPressed,
      child: Material(
        color: filled ? colors.inversePrimary : Colors.transparent,
        shape: StadiumBorder(
          side: filled
              ? BorderSide.none
              : BorderSide(
                  color: colors.onInverseSurface,
                  width: context.strokes.border,
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.touchTargets.field),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
              child: Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: context.sizes.iconSmall,
                      color: foreground,
                    ),
                    SizedBox(width: context.spacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.label.copyWith(
                        color: foreground,
                      ),
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

/// "Son işlemler": ekibin son yazdığı kayıtlar, kişi adı kalın. Kişi adı
/// e-postanın `@`'den önceki kısmı; kendin "Sen".
class _RecentActivity extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final entries = ref.watch(recentActivityProvider).value ?? const [];
    final emails = ref.watch(memberEmailsProvider).value ?? const {};
    final selfId = ref.watch(currentUserProvider.select((user) => user?.id));
    final now = clock.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(l10n.teamActivityTitle),
        SizedBox(height: spacing.sm),
        if (entries.isEmpty)
          Text(
            l10n.teamActivityEmpty,
            style: context.typography.body.copyWith(
              color: colors.textSecondary,
            ),
          )
        else
          for (final entry in entries)
            _ActivityRow(
              who: entry.userId == selfId
                  ? l10n.teamActivitySelf
                  : activityName(emails[entry.userId]) ??
                        l10n.teamMemberUnknown,
              entry: entry,
              now: now,
            ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const new({required this.who, required this.entry, required this.now});

  final String who;
  final ActivityEntry entry;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final what = activityText(l10n, entry.kind, entry.count);
    final apiary = entry.apiaryName;
    final where = apiary == null ? '' : ' \u00b7 $apiary';
    final when = activityAgeText(l10n, AppFormat.of(context), entry.at, now);
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.sm),
      child: Semantics(
        label: l10n.teamActivitySemantics(who, what, where, when),
        excludeSemantics: true,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '$who ', style: context.typography.label),
              TextSpan(text: l10n.teamActivityLine(what, where, when)),
            ],
          ),
          style: context.typography.body,
        ),
      ),
    );
  }
}
