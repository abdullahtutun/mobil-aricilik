import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';
import 'package:mobil_arici/features/health/domain/diagnosis.dart';
import 'package:mobil_arici/features/health/domain/diagnosis_rules.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Olası hastalığın ayrıntısı: ne yapılmalı. İhbarı mecburi hastalıkta
/// üstte kritik uyarı, bölgenin yetkili kurumu (TR'de il/ilçe müdürlüğü;
/// numarası varsa "Ara") ve altta "Kovanı karantinaya al" (viewer
/// görmez).
class DiagnosisResultScreen extends ConsumerWidget {
  const new({required this.ruleId, super.key});

  final String ruleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final table = ref.watch(diagnosisTableProvider);
    final rule = switch (table) {
      AsyncData(:final value) => diagnosisRule(value, ruleId),
      _ => null,
    };
    if (table case AsyncError()) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.diagnosisLoadError)),
      );
    }
    if (table case AsyncData() when rule == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.diagnosisNotFound)),
      );
    }
    // Uygulamayla gelen dosya; hemen okunur.
    if (rule == null) return Scaffold(appBar: AppBar());

    final language = Localizations.localeOf(context).languageCode;
    final spacing = context.spacing;
    final authority = diagnosisAuthority(
      table.requireValue,
      ref.watch(regionConfigProvider).profile,
    );
    final body = ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        if (rule.notifiable) ...[
          const _NotifiableWarning(),
          SizedBox(height: spacing.xl),
        ],
        SectionLabel(l10n.diagnosisAdvice),
        SizedBox(height: spacing.sm),
        Text(
          localizedText(rule.advice, language),
          style: context.typography.body,
        ),
        if (rule.notifiable) ...[
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.diagnosisAuthority),
          SizedBox(height: spacing.sm),
          _AuthorityCard(authority: authority, language: language),
        ],
        SizedBox(height: spacing.xl),
        NoteCard(
          icon: Icons.info_outline_rounded,
          message: l10n.diagnosisDisclaimer,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(localizedText(rule.name, language))),
      body: rule.notifiable && ref.watch(canWriteRecordsProvider)
          ? BottomActionLayout(
              body: body,
              action: BigButton(
                label: l10n.diagnosisQuarantine,
                onPressed: () => unawaited(
                  context.push(AppRoutes.diagnosisQuarantine(rule.id)),
                ),
              ),
            )
          : body,
    );
  }
}

/// "İhbarı mecburi hastalık." ve ne yapılacağı; kritik zeminde, ikonlu.
class _NotifiableWarning extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final body = context.typography.body;

    return MergeSemantics(
      child: AppCard(
        status: AppStatus.critical,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.report_rounded,
                size: context.sizes.icon,
                color: colors.statusCritical,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: l10n.diagnosisNotifiableTitle,
                        style: body.copyWith(
                          color: colors.statusCritical,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: l10n.diagnosisNotifiableMessage),
                    ],
                  ),
                  style: body.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Yetkili kurum: adı, açıklaması ve numarası varsa "Ara" butonu.
class _AuthorityCard extends ConsumerWidget {
  const new({required this.authority, required this.language});

  final DiagnosisAuthority authority;
  final String language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final detail = authority.detail;
    final phone = authority.phone;
    final phoneUri = authorityPhoneUri(authority);

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing.sm,
          children: [
            Text(
              localizedText(authority.name, language),
              style: context.typography.title,
            ),
            if (detail != null)
              Text(
                localizedText(detail, language),
                style: context.typography.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            if (phone != null && phoneUri != null) ...[
              SizedBox(height: spacing.xs),
              BigButton(
                label: l10n.diagnosisCall(phone),
                icon: Icons.call_rounded,
                variant: BigButtonVariant.secondary,
                onPressed: () => unawaited(_call(context, ref, phoneUri)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _call(BuildContext context, WidgetRef ref, Uri uri) async {
    final opened = await ref.read(urlLauncherServiceProvider).open(uri);
    if (!opened && context.mounted) {
      showMessageSnackBar(
        context,
        AppLocalizations.of(context).diagnosisCallFailed,
      );
    }
  }
}
