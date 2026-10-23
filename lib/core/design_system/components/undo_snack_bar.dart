import 'package:flutter/material.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// "Onay yerine geri al" (teknik.md §10): işlem yapılmıştır, [message]
/// 6 saniye görünür ve Geri al [onUndo]'yu çağırır. Önceki bildirimin
/// yerini alır.
void showUndoSnackBar(
  BuildContext context, {
  required String message,
  required VoidCallback onUndo,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: undoSnackBarDuration,
        // Eylemli bildirim varsayılan olarak kapanmaz; süre dolunca kapansın.
        persist: false,
        action: SnackBarAction(
          label: AppLocalizations.of(context).actionUndo,
          onPressed: onUndo,
        ),
      ),
    );
}

const undoSnackBarDuration = Duration(seconds: 6);
