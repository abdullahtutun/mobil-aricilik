import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/plans/data/purchase_service.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';
import 'package:mobil_arici/features/plans/presentation/plan_providers.dart';
import 'package:mobil_arici/features/plans/presentation/plan_widgets.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Plan: işletmenin planı, beta notu, Pro ile gelen üç özellik ve geri
/// kalan her şeyin ücretsiz olduğu. Planlar açıksa ve bu yapıda satın alma
/// kuruluysa işletme sahibi mağazadaki paketleri görür ve satın alır;
/// abonelik işletmeye aittir, ekipteki herkes Pro'yu kullanır.
class PlanScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(planRefresherProvider).refreshNow());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final plan = ref.watch(currentPlanProvider);
    final isOwner = ref.watch(currentRoleProvider) == MembershipRole.owner;
    final canBuy =
        plan.plansEnabled && ref.watch(purchaseServiceProvider).available;
    final expiresAt = plan.expiresAt;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.planTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          ListGroup(
            children: [
              ListRow(
                title: l10n.planTitle,
                value: plan.plan == PlanTier.pro
                    ? l10n.planCurrentPro
                    : l10n.planCurrentFree,
                subtitle: plan.plan == PlanTier.pro && expiresAt != null
                    ? l10n.planProUntil(
                        AppFormat.of(context).date(expiresAt.toLocal()),
                      )
                    : null,
              ),
            ],
          ),
          SizedBox(height: spacing.xl),
          const BetaNoticeCard(),
          SizedBox(height: spacing.xl),
          SectionCard(
            title: l10n.planProFeaturesTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Feature(Icons.hive_outlined, l10n.planFeatureHives),
                _Feature(Icons.groups_outlined, l10n.planFeatureTeam),
                _Feature(Icons.wb_sunny_outlined, l10n.planFeatureWeather),
                SizedBox(height: spacing.sm),
                Text(
                  l10n.planFreeIncludes,
                  style: context.typography.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (canBuy) ...[
            SizedBox(height: spacing.xl),
            if (!isOwner)
              NoteCard(
                icon: Icons.info_outline_rounded,
                message: l10n.planOwnerOnly,
              )
            else ...[
              if (plan.plan != PlanTier.pro) _offers(context),
              SizedBox(height: spacing.md),
              BigButton(
                label: l10n.planRestore,
                variant: BigButtonVariant.secondary,
                onPressed: _busy ? null : _restore,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _offers(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    return switch (ref.watch(planOffersProvider)) {
      AsyncData(value: final offers) when offers.isEmpty => NoteCard(
        message: l10n.planNoOffers,
      ),
      AsyncData(value: final offers) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, offer) in offers.indexed) ...[
            if (index > 0) SizedBox(height: spacing.md),
            BigButton(
              label: offer.yearly
                  ? l10n.planBuyYearly(offer.priceLabel)
                  : l10n.planBuyOther(offer.priceLabel),
              icon: Icons.workspace_premium_outlined,
              variant: index == 0
                  ? BigButtonVariant.primary
                  : BigButtonVariant.secondary,
              onPressed: _busy ? null : () => _purchase(offer),
            ),
          ],
        ],
      ),
      AsyncError(:final error) => NoteCard(
        message: _failureText(
          l10n,
          error is PurchaseException ? error.failure : PurchaseFailure.unknown,
        ),
      ),
      AsyncValue() => const Center(child: CircularProgressIndicator()),
    };
  }

  Future<void> _purchase(PlanOffer offer) => _run((orgId) async {
    await ref.read(purchaseServiceProvider).purchase(orgId, offer);
    if (mounted) {
      showMessageSnackBar(
        context,
        AppLocalizations.of(context).planPurchaseThanks,
      );
    }
  });

  Future<void> _restore() => _run((orgId) async {
    await ref.read(purchaseServiceProvider).restore(orgId);
    if (mounted) {
      showMessageSnackBar(
        context,
        AppLocalizations.of(context).planRestoreDone,
      );
    }
  });

  /// Mağaza işlemini çalıştırır, sonra planı sunucudan yeniler (webhook
  /// birkaç saniye sürebilir; gelmediyse plan sonraki yenilemede gelir).
  Future<void> _run(Future<void> Function(String orgId) action) async {
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null || _busy) return;
    setState(() => _busy = true);
    try {
      await action(orgId);
      unawaited(ref.read(planRefresherProvider).refreshNow());
    } on PurchaseException catch (error) {
      if (error.failure != PurchaseFailure.cancelled && mounted) {
        showMessageSnackBar(
          context,
          _failureText(AppLocalizations.of(context), error.failure),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _failureText(AppLocalizations l10n, PurchaseFailure failure) =>
      switch (failure) {
        PurchaseFailure.network => l10n.planErrorOffline,
        PurchaseFailure.notAllowed => l10n.planErrorNotAllowed,
        PurchaseFailure.unavailable => l10n.planErrorUnavailable,
        PurchaseFailure.cancelled ||
        PurchaseFailure.unknown => l10n.planErrorUnknown,
      };
}

/// Pro özelliği: ikon ve kelime.
class _Feature extends StatelessWidget {
  const new(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        children: [
          Icon(icon, size: context.sizes.icon, color: context.colors.primary),
          SizedBox(width: spacing.md),
          Expanded(child: Text(label, style: context.typography.body)),
        ],
      ),
    );
  }
}
