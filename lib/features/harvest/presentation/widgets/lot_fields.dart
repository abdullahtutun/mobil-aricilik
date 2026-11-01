import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';

/// Lotun yöre ve nem alanları; yeni lotta (hasat adımı) ve düzenlemede
/// aynı. Nem boş bırakılabilir; yazılmışsa 10–30 arası olmalı.
class LotFields extends StatelessWidget {
  const new({
    required this.origin,
    required this.moisture,
    required this.onChanged,
    super.key,
    this.enabled = true,
  });

  final TextEditingController origin;
  final TextEditingController moisture;
  final VoidCallback onChanged;
  final bool enabled;

  /// Nem alanı geçerli: boş ya da aralıkta.
  static bool moistureValid(String text) =>
      text.trim().isEmpty || parseLotMoisture(text) != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.lotOrigin,
          child: TextField(
            controller: origin,
            enabled: enabled,
            maxLength: maxLotOriginLength,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: l10n.lotOriginHint,
              counterText: '',
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
        SizedBox(height: spacing.lg),
        LabeledField(
          label: l10n.lotMoisture,
          helper: l10n.lotMoistureHelper,
          child: TextField(
            controller: moisture,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            textInputAction: TextInputAction.done,
            style: context.typography.number,
            onChanged: (_) => onChanged(),
          ),
        ),
        if (!moistureValid(moisture.text)) ...[
          SizedBox(height: spacing.sm),
          StatusMessage(
            status: AppStatus.warning,
            message: l10n.lotMoistureInvalid,
          ),
        ],
      ],
    );
  }
}
