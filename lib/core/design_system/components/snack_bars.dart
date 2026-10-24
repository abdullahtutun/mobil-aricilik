import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Bilgi bildirimi: [message] varsayılan süre görünür. Önceki bildirimin
/// yerini alır.
void showMessageSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// "Onay yerine geri al" (teknik.md §10): işlem yapılmıştır, [message]
/// 6 saniye görünür ve Geri al [onUndo]'yu çağırır. [details] mesajın
/// altında durur (ör. bir sonraki adımın seçimi); dokunmak bildirimi
/// kapatmaz. Önceki bildirimin yerini alır.
void showUndoSnackBar(
  BuildContext context, {
  required String message,
  required VoidCallback onUndo,
  Widget? details,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      undoSnackBar(context, message: message, onUndo: onUndo, details: details),
    );
}

/// [showUndoSnackBar]'ın gösterdiği bildirim: mürekkep zeminde mesaj, bal
/// sarısı Geri al (görünümü temanın `snackBarTheme`'inden). Bileşen
/// galerisi de bunu çizer.
SnackBar undoSnackBar(
  BuildContext context, {
  required String message,
  required VoidCallback onUndo,
  Widget? details,
}) {
  final undo = SnackBarAction(
    label: AppLocalizations.of(context).actionUndo,
    onPressed: onUndo,
  );
  return details == null
      ? SnackBar(
          content: Text(message),
          duration: undoSnackBarDuration,
          // Eylemli bildirim varsayılan olarak kapanmaz; süre dolunca
          // kapansın.
          persist: false,
          action: undo,
        )
      // Mesaj ve ek içerik tam genişlikte, Geri al en altta. Bildirimin
      // kendi eylem yeri, eylem alt satıra geçse de içeriğe genişliğin
      // yalnız %60'ını bırakır; büyük yazıda içerik dar bir sütuna
      // sıkışıp ekrandan taşardı.
      : SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              SizedBox(height: context.spacing.md),
              details,
              Align(alignment: AlignmentDirectional.centerEnd, child: undo),
            ],
          ),
          duration: undoSnackBarDuration,
        );
}

const undoSnackBarDuration = Duration(seconds: 6);
