import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/services/share_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion_rules.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_controller.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
import 'package:mobil_arici/features/account_deletion/presentation/deletion_code_controller.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/code_entry_form.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/role_permissions.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Akıştaki adım sayısı (bitiş ekranı ayrı).
const _stepCount = 4;

/// Silme talebinden kalıcı silmeye kadar geçen süre; sunucudaki
/// `account_deletion_grace()` ile aynı. Son onayda gösterilen tarih bundan
/// hesaplanır, bitiş ekranı sunucunun yazdığı tarihi gösterir.
const _gracePeriod = Duration(days: 7);

/// Ayarlar > Hesabımı sil. Adımlar: ne gideceği, önce verini al, e-postaya
/// gelen kodla kimlik doğrulama, işletme adını (ya da SİL) yazarak son
/// onay. Talep açılınca bitiş ekranına geçilir; oturum kapanır ve telefon
/// temizlenir. İnternet yoksa akış başlamaz. Geri tuşu bir önceki adıma
/// döner.
class AccountDeletionScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AccountDeletionScreen> createState() =>
      _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends ConsumerState<AccountDeletionScreen> {
  /// Açılışta bağlantı var mıydı; bilinene kadar null.
  bool? _online;

  @override
  void initState() {
    super.initState();
    unawaited(_checkConnection());
  }

  Future<void> _checkConnection() async {
    final online = await ref.read(connectivityServiceProvider).isOnline();
    if (mounted) setState(() => _online = online);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step = ref.watch(
      deletionFlowControllerProvider.select((state) => state.step),
    );

    final Widget body;
    if (_online == null) {
      body = const SizedBox.shrink();
    } else if (_online == false) {
      body = EmptyState(
        icon: Icons.cloud_off_rounded,
        title: l10n.deletionTitle,
        message: l10n.settingsDeleteAccountOffline,
        centered: true,
      );
    } else {
      body = switch (step) {
        DeletionStep.overview => const _OverviewStep(),
        DeletionStep.backup => const _BackupStep(),
        DeletionStep.verify => const _VerifyStep(),
        DeletionStep.confirm => const _ConfirmStep(),
      };
    }

    return PopScope(
      canPop: step == DeletionStep.overview || _online != true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(deletionFlowControllerProvider.notifier).back();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.deletionTitle)),
        body: body,
      ),
    );
  }
}

/// Adımın üstündeki "Adım 1/4" ve başlık.
class _StepHeader extends StatelessWidget {
  const new({required this.step, required this.title});

  final int step;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.deletionStepCounter(step, _stepCount),
          style: context.typography.label.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.spacing.xs),
        Semantics(
          header: true,
          child: Text(title, style: context.typography.headline),
        ),
      ],
    );
  }
}

/// İkincil metin paragrafı.
class _Paragraph extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.typography.body.copyWith(
      color: context.colors.textSecondary,
    ),
  );
}

String _organizationName(WidgetRef ref) =>
    ref.watch(businessProfileProvider)?.name ?? '';

// ---------------------------------------------------------------------------
// Adım 1: ne gidecek
// ---------------------------------------------------------------------------

class _OverviewStep extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final scenario = ref.watch(deletionScenarioProvider);
    final flow = ref.watch(deletionFlowControllerProvider);
    final controller = ref.read(deletionFlowControllerProvider.notifier);
    final organization = _organizationName(ref);
    final counts = ref.watch(deletionCountsProvider).value;
    final members = ref.watch(organizationMembersProvider).value ?? const [];
    final userId = ref.watch(currentUserProvider)?.id;
    final others = members.where((member) => member.userId != userId).length;

    final children = <Widget>[];
    switch (scenario) {
      case DeletionScenario.soloOwner:
        children.addAll([
          _StepHeader(step: 1, title: l10n.deletionSoloTitle),
          SizedBox(height: spacing.sm),
          _Paragraph(l10n.deletionSoloMessage(organization)),
          ..._countsSection(context, counts),
        ]);
      case DeletionScenario.ownerWithTeam:
        final candidates = transferCandidates(
          ref.watch(memberProfilesProvider).value ?? const [],
          userId: userId,
        );
        children.addAll([
          _StepHeader(step: 1, title: l10n.deletionTeamTitle),
          SizedBox(height: spacing.sm),
          _Paragraph(l10n.deletionTeamMessage(others, organization)),
          SizedBox(height: spacing.lg),
          RadioCardGroup<OwnerDeletionChoice>(
            options: [
              RadioCardOption(
                value: OwnerDeletionChoice.transfer,
                label: l10n.deletionChoiceTransfer,
              ),
              RadioCardOption(
                value: OwnerDeletionChoice.deleteOrganization,
                label: l10n.deletionChoiceDelete,
              ),
            ],
            selected: flow.choice,
            onChanged: controller.choose,
          ),
          if (flow.choice == OwnerDeletionChoice.transfer) ...[
            SizedBox(height: spacing.md),
            _Paragraph(l10n.deletionChoiceTransferHint),
            SizedBox(height: spacing.lg),
            if (candidates.isEmpty)
              NoteCard(
                icon: Icons.info_outline_rounded,
                message: l10n.deletionTransferNoPartner,
              )
            else
              LabeledField(
                label: l10n.deletionTransferPick,
                group: true,
                child: RadioCardGroup<String>(
                  options: [
                    for (final member in candidates)
                      RadioCardOption(
                        value: member.userId,
                        label: _memberName(ref, l10n, member),
                      ),
                  ],
                  selected: flow.transferTo,
                  onChanged: controller.selectTransferTarget,
                ),
              ),
          ],
          if (flow.choice == OwnerDeletionChoice.deleteOrganization) ...[
            SizedBox(height: spacing.md),
            _Paragraph(l10n.deletionChoiceDeleteHint(others)),
            ..._countsSection(context, counts),
          ],
        ]);
      case DeletionScenario.member:
        children.addAll([
          _StepHeader(step: 1, title: l10n.deletionMemberTitle),
          SizedBox(height: spacing.sm),
          _Paragraph(l10n.deletionMemberMessage(organization)),
        ]);
      case DeletionScenario.unknown:
        children.addAll([
          _StepHeader(step: 1, title: l10n.deletionTitle),
          SizedBox(height: spacing.sm),
          StatusMessage(
            status: AppStatus.info,
            message: l10n.deletionUnknownMessage,
          ),
        ]);
    }
    if (scenario != DeletionScenario.unknown) {
      children.addAll([
        SizedBox(height: spacing.lg),
        NoteCard(icon: Icons.schedule_rounded, message: l10n.deletionGraceNote),
      ]);
    }

    return BottomActionLayout(
      body: ListView(padding: EdgeInsets.all(spacing.lg), children: children),
      action: BigButton(
        label: l10n.deletionContinue,
        onPressed:
            canLeaveOverview(
              scenario: scenario,
              choice: flow.choice,
              transferTo: flow.transferTo,
            )
            ? controller.next
            : null,
      ),
    );
  }

  /// Sayılar ve (varsa) yayımdaki lot sayfalarının ayrı uyarısı.
  static List<Widget> _countsSection(
    BuildContext context,
    DeletionCounts? counts,
  ) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final shown = counts ?? emptyDeletionCounts;
    return [
      if (shown.publicLotPages > 0) ...[
        SizedBox(height: spacing.lg),
        CriticalLockCard(
          icon: Icons.qr_code_2_rounded,
          title: l10n.deletionLotWarningTitle,
          message: l10n.deletionLotWarningMessage(shown.publicLotPages),
        ),
      ],
      SizedBox(height: spacing.xl),
      SectionLabel(l10n.deletionCountsLabel),
      SizedBox(height: spacing.sm),
      ListGroup(
        children: [
          for (final (label, count) in [
            (l10n.deletionCountHives, shown.hives),
            (l10n.deletionCountApiaries, shown.apiaries),
            (l10n.deletionCountInspections, shown.inspections),
            (l10n.deletionCountHarvests, shown.harvests),
            (l10n.deletionCountDocuments, shown.documents),
            (l10n.deletionCountPhotos, shown.photos),
          ])
            ListRow(title: label, value: format.number(count)),
        ],
      ),
    ];
  }
}

/// Ortağın adı; ad girilmemişse e-postası, o da yoksa "Ortak".
String _memberName(WidgetRef ref, AppLocalizations l10n, MemberProfile member) {
  if (member.fullName case final name? when name.trim().isNotEmpty) {
    return name;
  }
  final emails = ref.watch(memberEmailsProvider).value ?? const {};
  return emails[member.userId] ?? l10n.deletionPartnerFallbackName;
}

// ---------------------------------------------------------------------------
// Adım 2: önce verini al
// ---------------------------------------------------------------------------

class _BackupStep extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_BackupStep> createState() => _BackupStepState();
}

class _BackupStepState extends ConsumerState<_BackupStep> {
  bool _exporting = false;
  bool _exported = false;

  Future<void> _exportJson() async {
    final l10n = AppLocalizations.of(context);
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null || _exporting) return;
    setState(() => _exporting = true);
    try {
      final bytes = await ref
          .read(accountDeletionRepositoryProvider)
          .exportJson(
            orgId,
            includeFinance: canExportFinance(ref.read(currentRoleProvider)),
          );
      final day = DateFormat('yyyy-MM-dd').format(clock.now());
      await ref
          .read(shareServiceProvider)
          .shareFile(
            bytes,
            filename: '${l10n.deletionBackupFileName(day)}.json',
            mimeType: 'application/json',
          );
      if (mounted) setState(() => _exported = true);
    } on Object {
      if (mounted) showMessageSnackBar(context, l10n.exportFailed);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final controller = ref.read(deletionFlowControllerProvider.notifier);

    return BottomActionLayout(
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          _StepHeader(step: 2, title: l10n.deletionBackupTitle),
          SizedBox(height: spacing.sm),
          _Paragraph(l10n.deletionBackupMessage),
          SizedBox(height: spacing.lg),
          ListGroup(
            children: [
              ListRow(
                title: l10n.deletionBackupJson,
                subtitle: l10n.deletionBackupJsonHint,
                value: _exporting
                    ? l10n.exportPreparing
                    : _exported
                    ? l10n.deletionBackupSaved
                    : l10n.deletionBackupJsonValue,
                onTap: _exporting ? null : () => unawaited(_exportJson()),
              ),
              ListRow(
                title: l10n.deletionBackupReports,
                subtitle: l10n.deletionBackupReportsHint,
                // Akış yığında kalır; raporlardan geri gelince bu adım açık.
                onTap: () => unawaited(context.push(AppRoutes.reports)),
              ),
            ],
          ),
        ],
      ),
      action: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Varsayılan öneri: önce kayıtları indir; indirildiyse devam.
          if (_exported)
            BigButton(label: l10n.deletionContinue, onPressed: controller.next)
          else ...[
            BigButton(
              icon: Icons.download_rounded,
              label: l10n.deletionBackupDownload,
              onPressed: _exporting ? null : () => unawaited(_exportJson()),
            ),
            SizedBox(height: spacing.sm),
            BigButton(
              variant: BigButtonVariant.secondary,
              label: l10n.deletionBackupSkip,
              onPressed: _exporting ? null : controller.next,
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Adım 3: kimlik doğrula
// ---------------------------------------------------------------------------

class _VerifyStep extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_VerifyStep> createState() => _VerifyStepState();
}

class _VerifyStepState extends ConsumerState<_VerifyStep> {
  @override
  void initState() {
    super.initState();
    // Adım açılınca silme kodu hesabın e-postasına gider; form çizildikten
    // sonra (denetleyici dinlenirken) istenir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(deletionCodeControllerProvider.notifier).send());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(deletionCodeControllerProvider.notifier);
    return CodeEntryForm(
      overline: l10n.deletionStepCounter(3, _stepCount),
      heading: l10n.deletionVerifyTitle,
      verifyLabel: l10n.deletionVerifyButton,
      state: ref.watch(deletionCodeControllerProvider),
      onVerify: controller.verify,
      onResend: controller.send,
      onVerified: ref
          .read(deletionFlowControllerProvider.notifier)
          .codeVerified,
    );
  }
}

// ---------------------------------------------------------------------------
// Adım 4: son onay
// ---------------------------------------------------------------------------

class _ConfirmStep extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_ConfirmStep> createState() => _ConfirmStepState();
}

class _ConfirmStepState extends ConsumerState<_ConfirmStep> {
  final _typed = TextEditingController();

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final actions = ref.read(accountDeletionActionsProvider);
    final requested = await ref
        .read(deletionFlowControllerProvider.notifier)
        .submit();
    if (!requested || !mounted) return;
    // Önce bitiş ekranına geçilir: oturum kapanınca o ekran açık kalır.
    context.go(AppRoutes.accountDeleted);
    unawaited(actions.leaveDevice());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final flow = ref.watch(deletionFlowControllerProvider);
    final scenario = ref.watch(deletionScenarioProvider);
    final organization = _organizationName(ref);
    final withOrganization = deletesOrganization(scenario, flow.choice);
    final lots = ref.watch(deletionCountsProvider).value?.publicLotPages ?? 0;
    final transfer =
        scenario == DeletionScenario.ownerWithTeam &&
        flow.choice == OwnerDeletionChoice.transfer;
    final newOwner = transfer
        ? (ref.watch(memberProfilesProvider).value ?? const [])
              .where((member) => member.userId == flow.transferTo)
              .firstOrNull
        : null;
    final expected = withOrganization ? organization : l10n.deletionKeyword;
    final failure = flow.failure;

    final consequences = <(IconData, String)>[
      (
        Icons.person_off_outlined,
        l10n.deletionConsequenceAccount(
          format.date(clock.now().add(_gracePeriod)),
        ),
      ),
      if (withOrganization) ...[
        (
          Icons.delete_outline_rounded,
          l10n.deletionConsequenceOrganization(organization),
        ),
        if (lots > 0)
          (Icons.qr_code_2_rounded, l10n.deletionConsequenceLots(lots)),
      ] else ...[
        if (newOwner != null)
          (
            Icons.swap_horiz_rounded,
            l10n.deletionConsequenceTransfer(
              _memberName(ref, l10n, newOwner),
              organization,
            ),
          ),
        (Icons.inventory_2_outlined, l10n.deletionConsequenceRecordsStay),
      ],
      (Icons.logout_rounded, l10n.deletionConsequenceSignOut),
      (Icons.undo_rounded, l10n.deletionConsequenceCancel),
    ];

    return BottomActionLayout(
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          _StepHeader(step: 4, title: l10n.deletionConfirmTitle),
          SizedBox(height: spacing.md),
          Text(l10n.deletionConfirmIntro, style: context.typography.subtitle),
          SizedBox(height: spacing.sm),
          for (final (icon, text) in consequences)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: context.sizes.icon,
                    color: context.colors.textSecondary,
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(child: Text(text, style: context.typography.body)),
                ],
              ),
            ),
          SizedBox(height: spacing.lg),
          LabeledField(
            label: withOrganization
                ? l10n.deletionConfirmTypeName(organization)
                : l10n.deletionConfirmTypeKeyword(l10n.deletionKeyword),
            child: TextField(
              controller: _typed,
              enabled: !flow.busy,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
            ),
          ),
          if (failure != null) ...[
            SizedBox(height: spacing.md),
            StatusMessage(
              status: AppStatus.critical,
              message: _failureMessage(l10n, failure),
            ),
          ],
        ],
      ),
      action: ListenableBuilder(
        listenable: _typed,
        builder: (context, _) {
          final matches = confirmationMatches(
            _typed.text,
            expected,
            upperCase: format.upperCase,
          );
          return BigButton(
            variant: BigButtonVariant.danger,
            icon: Icons.delete_forever_rounded,
            label: flow.busy
                ? l10n.deletionSubmitting
                : withOrganization
                ? l10n.deletionConfirmButtonWithOrganization
                : l10n.deletionConfirmButton,
            onPressed: matches && !flow.busy && flow.verified
                ? () => unawaited(_submit())
                : null,
          );
        },
      ),
    );
  }

  static String _failureMessage(
    AppLocalizations l10n,
    AccountDeletionFailure failure,
  ) => switch (failure) {
    AccountDeletionFailure.network => l10n.deletionFailureNetwork,
    AccountDeletionFailure.ownerMustTransfer =>
      l10n.deletionFailureOwnerMustTransfer,
    AccountDeletionFailure.invalidTransferTarget =>
      l10n.deletionFailureInvalidTransfer,
    AccountDeletionFailure.rateLimited => l10n.deletionFailureRateLimited,
    AccountDeletionFailure.forbidden => l10n.deletionFailureForbidden,
    AccountDeletionFailure.codeRequired => l10n.deletionFailureCodeRequired,
    AccountDeletionFailure.invalidCode => l10n.authErrorInvalidCode,
    AccountDeletionFailure.tooManyAttempts => l10n.authErrorTooManyRequests,
    AccountDeletionFailure.unknown => l10n.deletionFailureUnknown,
  };
}
