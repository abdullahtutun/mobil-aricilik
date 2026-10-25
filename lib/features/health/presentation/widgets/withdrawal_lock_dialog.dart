import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';

/// Bekleme süresi kilidi (docs/design "Bekleme süresi kilidi"): bekleme
/// süresindeki kovana bal katı verilmek (ya da hasat işaretlenmek)
/// istenince açılır. Tam genişlikte kırmızı kilit kartı, kalan gün ve
/// uygulama; öne çıkan eylem vazgeçmek. Yine de kaydetmek için gerekçe
/// seçilmeli. Seçilen gerekçe döner; vazgeçilir ya da kapatılırsa null.
Future<WithdrawalOverrideReason?> showWithdrawalLockDialog(
  BuildContext context, {
  required String hiveNumber,
  required WithdrawalLock lock,
}) => showDialog<WithdrawalOverrideReason>(
  context: context,
  builder: (context) =>
      _WithdrawalLockDialog(hiveNumber: hiveNumber, lock: lock),
);

class _WithdrawalLockDialog extends StatefulWidget {
  const new({required this.hiveNumber, required this.lock});

  final String hiveNumber;
  final WithdrawalLock lock;

  @override
  State<_WithdrawalLockDialog> createState() => _WithdrawalLockDialogState();
}

class _WithdrawalLockDialogState extends State<_WithdrawalLockDialog> {
  WithdrawalOverrideReason? _reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final lock = widget.lock;
    final treatment = lock.treatment;
    final reason = _reason;

    return Dialog(
      insetPadding: EdgeInsets.all(spacing.lg),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CriticalLockCard(
              title: l10n.withdrawalLockTitle,
              message: l10n.withdrawalLockMessage(
                widget.hiveNumber,
                treatment.productName,
                format.date(lock.until),
              ),
            ),
            SizedBox(height: spacing.lg),
            // Uzun yazıda iki karo aynı boyda kalsın.
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SummaryTile(
                      label: l10n.withdrawalDaysLeft,
                      value: l10n.withdrawalDays(lock.daysLeft),
                      status: AppStatus.critical,
                    ),
                  ),
                  SizedBox(width: context.touchTargets.gap),
                  Expanded(
                    child: SummaryTile(
                      label: l10n.withdrawalApplied,
                      value: [
                        format.dayMonth(treatment.startedAt.toLocal()),
                        ?treatment.batchNo,
                      ].join(l10n.titleSeparator),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.lg),
            LabeledField(
              label: l10n.withdrawalReasonPrompt,
              group: true,
              child: RadioCardGroup<WithdrawalOverrideReason>(
                options: [
                  for (final reason in WithdrawalOverrideReason.values)
                    RadioCardOption(value: reason, label: reason.label(l10n)),
                ],
                selected: reason,
                onChanged: (reason) => setState(() => _reason = reason),
              ),
            ),
            SizedBox(height: spacing.lg),
            BigButton(
              label: l10n.withdrawalCancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(height: context.touchTargets.gap),
            BigButton(
              variant: BigButtonVariant.secondary,
              label: l10n.withdrawalProceed,
              onPressed: reason == null
                  ? null
                  : () => Navigator.of(context).pop(reason),
            ),
          ],
        ),
      ),
    );
  }
}
