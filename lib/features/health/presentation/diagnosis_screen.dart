import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/health/domain/diagnosis.dart';
import 'package:mobil_arici/features/health/domain/diagnosis_rules.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_providers.dart';

/// Teşhis yardımcısı: gördüğü belirtileri seçer (çoklu chip), altında
/// olası hastalıklar çok eşleşen önce listelenir; ihbarı mecburi olanlar
/// rozetli. Hastalığa dokununca ne yapılacağı açılır. Kural tablosu
/// uygulamayla gelir, internet istemez. Seçim yalnız ekranda tutulur.
class DiagnosisScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends ConsumerState<DiagnosisScreen> {
  Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final language = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.knowledgeDiagnosisTitle)),
      body: switch (ref.watch(diagnosisTableProvider)) {
        AsyncData(:final value) => ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            LabeledField(
              label: l10n.diagnosisSymptoms,
              helper: l10n.diagnosisSymptomsHelper,
              group: true,
              child: ChoiceChipGroup<String>(
                multiSelect: true,
                columns: 1,
                options: [
                  for (final symptom in value.symptoms)
                    ChoiceChipOption(
                      value: symptom.id,
                      label: localizedText(symptom.label, language),
                    ),
                ],
                selected: _selected,
                onChanged: (selected) => setState(() => _selected = selected),
              ),
            ),
            SizedBox(height: spacing.xl),
            SectionLabel(l10n.diagnosisResults),
            SizedBox(height: spacing.sm),
            ..._results(context, value, language),
            SizedBox(height: spacing.lg),
            NoteCard(
              icon: Icons.info_outline_rounded,
              message: l10n.diagnosisDisclaimer,
            ),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.diagnosisLoadError)),
        // Uygulamayla gelen dosya; hemen okunur.
        _ => const SizedBox.shrink(),
      },
    );
  }

  List<Widget> _results(
    BuildContext context,
    DiagnosisTable table,
    String language,
  ) {
    final l10n = AppLocalizations.of(context);
    final secondary = context.typography.body.copyWith(
      color: context.colors.textSecondary,
    );
    if (_selected.isEmpty) {
      return [Text(l10n.diagnosisPickHint, style: secondary)];
    }
    final matches = diagnose(table, _selected);
    if (matches.isEmpty) {
      return [Text(l10n.diagnosisNoMatch, style: secondary)];
    }
    return [
      for (final (index, match) in matches.indexed) ...[
        if (index > 0) SizedBox(height: context.touchTargets.gap),
        _MatchCard(match: match, language: language),
      ],
    ];
  }
}

/// Olası hastalık: adı, eşleşen belirti sayısı ve ihbarı mecburiyse
/// kritik rozet; dokununca ayrıntı açılır.
class _MatchCard extends StatelessWidget {
  const new({required this.match, required this.language});

  final DiagnosisMatch match;
  final String language;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rule = match.rule;

    return NavigationCard(
      onTap: () => unawaited(context.push(AppRoutes.diagnosisResult(rule.id))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.spacing.xs,
        children: [
          Text(
            localizedText(rule.name, language),
            style: context.typography.title,
          ),
          Text(
            l10n.diagnosisMatched(match.matched, rule.symptoms.length),
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          if (rule.notifiable)
            StatusBadge(
              status: AppStatus.critical,
              label: l10n.diagnosisNotifiable,
            ),
        ],
      ),
    );
  }
}
