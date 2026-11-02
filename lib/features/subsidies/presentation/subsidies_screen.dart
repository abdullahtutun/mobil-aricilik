import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/subsidies/domain/subsidy_rules.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';
import 'package:mobil_arici/features/subsidies/presentation/subsidy_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Destekler (yalnız TR profilinde, `RegionFeatures.subsidies`): üstte
/// başvuru öncesi kontrol (uygulamadaki aktif kovan sayısı ile AKS'de
/// beyan edilen sayı; farklıysa uyarı), altında başvuru dönemleri (açık,
/// yaklaşan, biten). Dönemleri yönetici girer, senkronla iner.
class SubsidiesScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final periods = ref.watch(supportPeriodsProvider).value;
    final check = ref.watch(aksHiveCountCheckProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subsidiesTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          SectionLabel(l10n.subsidiesCheckTitle),
          SizedBox(height: spacing.sm),
          if (check != null) _HiveCountCheck(check),
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.subsidiesPeriodsTitle),
          SizedBox(height: spacing.sm),
          if (periods != null && periods.isEmpty)
            EmptyState(
              icon: Icons.event_note_outlined,
              title: l10n.subsidiesEmptyTitle,
              message: l10n.subsidiesEmptyMessage,
            ),
          for (final period in periods ?? const <SupportPeriod>[]) ...[
            _PeriodCard(period),
            SizedBox(height: context.touchTargets.gap),
          ],
        ],
      ),
    );
  }
}

/// İki özet karosu (uygulamadaki aktif kovan, AKS'de beyan edilen), altında
/// kontrolün sonucu (ikon + renk + cümle) ve owner için "Beyan edilen
/// sayıyı gir".
class _HiveCountCheck extends ConsumerWidget {
  const new(this.state);

  final AksHiveCountState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final canEdit = ref.watch(canEditOrganizationProvider);
    final declared = state.declared;
    final status = switch (state.check) {
      AksHiveCountCheck.notDeclared => AppStatus.info,
      AksHiveCountCheck.matches => AppStatus.good,
      AksHiveCountCheck.differs => AppStatus.warning,
    };
    final message = switch (state.check) {
      AksHiveCountCheck.notDeclared => l10n.subsidiesCheckNotDeclared,
      AksHiveCountCheck.matches => l10n.subsidiesCheckMatches,
      AksHiveCountCheck.differs => l10n.subsidiesCheckDiffers(
        format.number(state.activeHives),
        format.number(declared ?? 0),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: context.touchTargets.gap,
            children: [
              Expanded(
                child: SummaryTile(
                  label: l10n.subsidiesActiveHives,
                  value: format.number(state.activeHives),
                ),
              ),
              Expanded(
                child: SummaryTile(
                  label: l10n.subsidiesDeclaredHives,
                  value: declared == null
                      ? l10n.subsidiesNotDeclared
                      : format.number(declared),
                  status: state.check == AksHiveCountCheck.differs
                      ? AppStatus.warning
                      : null,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        StatusMessage(status: status, message: message),
        SizedBox(height: spacing.md),
        if (canEdit)
          BigButton(
            label: l10n.subsidiesEditDeclared,
            icon: Icons.edit_outlined,
            variant: BigButtonVariant.secondary,
            onPressed: () => context.push(AppRoutes.aksHiveCount),
          )
        else
          Text(
            l10n.subsidiesDeclaredOwnerOnly,
            style: context.typography.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
      ],
    );
  }
}

/// Başvuru dönemi: ad, durum rozeti (açık / yakında / bitti), günler,
/// açıklama ve varsa "Resmî duyuruyu aç".
class _PeriodCard extends ConsumerWidget {
  const new(this.period);

  final SupportPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final description = period.description;
    final source = Uri.tryParse(period.sourceUrl ?? '');
    final (status, label) = switch (supportPeriodPhase(
      period,
      DateTime.now(),
    )) {
      SupportPeriodPhase.open => (AppStatus.good, l10n.subsidiesPhaseOpen),
      SupportPeriodPhase.upcoming => (
        AppStatus.info,
        l10n.subsidiesPhaseUpcoming,
      ),
      SupportPeriodPhase.closed => (
        AppStatus.critical,
        l10n.subsidiesPhaseClosed,
      ),
    };

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacing.sm,
          children: [
            Text(period.name, style: context.typography.title),
            StatusBadge(status: status, label: label),
            Text(
              l10n.subsidiesPeriodDates(
                format.date(period.applicationStartsOn),
                format.date(period.applicationEndsOn),
              ),
              style: context.typography.label,
            ),
            if (description != null)
              Text(
                description,
                style: context.typography.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            if (source != null && source.hasScheme)
              Padding(
                padding: EdgeInsets.only(top: spacing.sm),
                child: BigButton(
                  label: l10n.subsidiesOpenSource,
                  icon: Icons.open_in_new_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => unawaited(_open(context, ref, source)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref, Uri uri) async {
    final opened = await ref.read(urlLauncherServiceProvider).open(uri);
    if (!opened && context.mounted) {
      showMessageSnackBar(
        context,
        AppLocalizations.of(context).subsidiesOpenSourceFailed,
      );
    }
  }
}
