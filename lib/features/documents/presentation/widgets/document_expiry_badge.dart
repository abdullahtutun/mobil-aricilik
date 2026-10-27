import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_labels.dart';

/// Belgenin geçerlilik rozeti ([documentExpiryBadge]). Süresiz belgede
/// durum yok: soluk zeminde ikinci metin renginde, ikonsuz nötr rozet
/// (docs/design "Belge kasası").
class DocumentExpiryBadge extends StatelessWidget {
  const new(this.document, {super.key});

  final VaultDocument document;

  @override
  Widget build(BuildContext context) {
    final badge = documentExpiryBadge(
      AppLocalizations.of(context),
      AppFormat.of(context),
      document,
      clock.now(),
    );
    if (badge.status case final status?) {
      return StatusBadge(status: status, label: badge.label);
    }
    final colors = context.colors;
    final spacing = context.spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Text(
          badge.label,
          style: context.typography.label.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}
