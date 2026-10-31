import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/health/domain/drug_info.dart';

/// İlacın ürün bilgisini alt sayfada açar; ilaç listesinin üstünde durur,
/// kapatılınca listeye dönülür.
Future<void> showDrugInfoSheet(BuildContext context, DrugInfo info) =>
    showOptionSheet<void>(context, (context) => DrugInfoSheet(info: info));

extension on DrugUsageKind {
  String label(AppLocalizations l10n) => switch (this) {
    DrugUsageKind.method => l10n.drugInfoUsageMethod,
    DrugUsageKind.methodAndDose => l10n.drugInfoUsageMethodAndDose,
    DrugUsageKind.diagnosis => l10n.drugInfoUsageDiagnosis,
    DrugUsageKind.treatmentDose || DrugUsageKind.dose => l10n.drugInfoUsageDose,
    DrugUsageKind.frequency => l10n.drugInfoUsageFrequency,
    DrugUsageKind.duration => l10n.drugInfoUsageDuration,
    DrugUsageKind.other => l10n.drugInfoUsageOther,
  };
}

/// Ürün bilgisi: en üstte kaynağın Bakanlık olduğu, sonra etken madde,
/// kullanım, dönemler ve kalıntı bilgisi. Metinler kaynağındaki gibi
/// Türkçe; başlıklar uygulamanın dilinde.
class DrugInfoSheet extends StatelessWidget {
  const new({required this.info, super.key});

  final DrugInfo info;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final warnings = info.residue.warnings;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: spacing.lg,
          right: spacing.lg,
          bottom: spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(info.name, style: context.typography.title),
            ),
            SizedBox(height: spacing.md),
            NoteCard(
              icon: Icons.account_balance_outlined,
              title: l10n.drugInfoSourceTitle,
              message: l10n.drugInfoSourceMessage,
            ),
            _Section(
              title: l10n.drugInfoActiveIngredient,
              children: [_Body(info.activeIngredient)],
            ),
            _Section(
              title: l10n.drugInfoIndications,
              children: [_Body(info.indications)],
            ),
            _Section(
              title: l10n.drugInfoUsage,
              children: [
                for (final (kind, text) in drugUsageItems(info.usage))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kind.label(l10n), style: context.typography.label),
                      _Body(text),
                    ],
                  ),
              ],
            ),
            if (info.periods.suitable.isNotEmpty)
              _Section(
                title: l10n.drugInfoSuitablePeriods,
                status: AppStatus.good,
                children: [
                  for (final period in info.periods.suitable)
                    _Item(period, status: AppStatus.good),
                ],
              ),
            if (info.periods.avoid.isNotEmpty)
              _Section(
                title: l10n.drugInfoAvoidPeriods,
                status: AppStatus.critical,
                children: [
                  for (final period in info.periods.avoid)
                    _Item(period, status: AppStatus.critical),
                ],
              ),
            _Section(
              title: l10n.drugInfoWithdrawal,
              children: [_Body(info.residue.withdrawal)],
            ),
            if (warnings != null && warnings.trim().isNotEmpty)
              _Section(
                title: l10n.drugInfoWarnings,
                status: AppStatus.warning,
                children: [_Item(warnings, status: AppStatus.warning)],
              ),
            SizedBox(height: spacing.xl),
            BigButton(
              variant: BigButtonVariant.secondary,
              label: l10n.drugInfoClose,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bölüm başlığı ve altında satırlar.
class _Section extends StatelessWidget {
  const new({required this.title, required this.children, this.status});

  final String title;
  final List<Widget> children;
  final AppStatus? status;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.only(top: spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.sm,
        children: [
          SectionLabel(title, status: status),
          ...children,
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: context.typography.body);
}

/// Durum ikonlu madde; anlamı bölüm başlığındaki kelime taşır.
class _Item extends StatelessWidget {
  const new(this.text, {required this.status});

  final String text;
  final AppStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Icon(
            status.icon,
            size: context.sizes.icon,
            color: status.colorIn(context.colors),
          ),
        ),
        SizedBox(width: context.spacing.sm),
        Expanded(child: _Body(text)),
      ],
    );
  }
}
