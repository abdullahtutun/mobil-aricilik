import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Bilgi bildirimi: [message] varsayılan süre görünür. Önceki bildirimin
/// yerini alır.
void showMessageSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: SnackBarRegion(child: Text(message))));
}

/// Bildirim açıkken ekranın bildirim dışındaki bir yerine dokunulunca
/// bildirimi kapatır; dokunuş altındaki butona da gider (ör. bildirimin
/// örttüğü Kaydet'in yanındaki alan). Bildirimin kendisine (Geri al, ek
/// içerik) dokunmak kapatmaz. Uygulamanın kökünde bir kez sarılır.
class SnackBarDismissArea extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: (event) => _dismissOutside(event.position),
    child: child,
  );

  static void _dismissOutside(Offset position) {
    final shown = [
      for (final region in SnackBarRegion._mounted)
        if (_snackBarBounds(region) case final bounds?) (region, bounds),
    ];
    if (shown.isEmpty) return;
    if (shown.any((entry) => entry.$2.contains(position))) return;
    ScaffoldMessenger.maybeOf(shown.first.$1)?.hideCurrentSnackBar();
  }

  /// İçeriği [region]'da olan bildirimin (Geri al dahil) ekrandaki yeri.
  static Rect? _snackBarBounds(BuildContext region) {
    Element? snackBar;
    region.visitAncestorElements((element) {
      if (element.widget is SnackBar) snackBar = element;
      return snackBar == null;
    });
    final box = snackBar?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

/// Bildirimin içeriğini sarar; [SnackBarDismissArea] açık bildirimleri ve
/// sınırlarını buradan bulur. Görünüşü değiştirmez. Bildirim sayfa
/// geçişinde iki sayfada birden çizilebildiği için anahtar değil kayıt.
class SnackBarRegion extends StatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  static final _mounted = <BuildContext>{};

  @override
  State<SnackBarRegion> createState() => _SnackBarRegionState();
}

class _SnackBarRegionState extends State<SnackBarRegion> {
  @override
  void initState() {
    super.initState();
    SnackBarRegion._mounted.add(context);
  }

  @override
  void dispose() {
    SnackBarRegion._mounted.remove(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
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
          content: SnackBarRegion(child: Text(message)),
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
          content: SnackBarRegion(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                SizedBox(height: context.spacing.md),
                details,
                Align(alignment: AlignmentDirectional.centerEnd, child: undo),
              ],
            ),
          ),
          duration: undoSnackBarDuration,
        );
}

const undoSnackBarDuration = Duration(seconds: 6);
