import 'package:flutter/material.dart';

/// Rotası olan alt sayfa (teknik.md §8: kayıt formları alttan açılır,
/// arkadaki ekran yerinde kalır). Rota kök navigator'a bağlanınca sayfa
/// sekmelerin ve alt gezinmenin de üstünde açılır. Sürüklemek, arka plana
/// dokunmak ve geri tuşu rotadan çıkar; konum alttaki ekrana döner.
class SheetPage<T> extends Page<T> {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
    settings: this,
    builder: (context) => child,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
  );
}
