import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Form ve adım ekranlarının düzeni: üstte kayan [body], altta başparmağın
/// ulaştığı yerde sabit [action] (genelde birincil buton).
class BottomActionLayout extends StatelessWidget {
  const new({
    required this.body,
    required this.action,
    super.key,
    this.separated = false,
  });

  /// Kalan yüksekliği doldurur; kaydırmayı kendisi yapar (ör. `ListView`).
  final Widget body;
  final Widget action;

  /// Eylemin üstünde ince çizgi: uzun formlarda içerik eylemin altına
  /// kayarken sınır belli olsun.
  final bool separated;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: body),
          if (separated) const Divider(),
          Padding(padding: EdgeInsets.all(context.spacing.lg), child: action),
        ],
      ),
    );
  }
}
