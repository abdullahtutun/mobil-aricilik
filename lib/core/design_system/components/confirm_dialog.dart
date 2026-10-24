import 'package:flutter/material.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Geri alınamayan ya da sonucu büyük işlem için onay: Vazgeç ve
/// [confirmLabel]. Onaylanırsa true; vazgeçilir ya da kapatılırsa false.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
