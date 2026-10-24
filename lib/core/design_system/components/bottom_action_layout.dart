import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Form ve adım ekranlarının düzeni: üstte kayan [body], altta başparmağın
/// ulaştığı yerde sabit [action] (genelde birincil buton).
class BottomActionLayout extends StatelessWidget {
  const new({required this.body, required this.action, super.key});

  /// Kalan yüksekliği doldurur; kaydırmayı kendisi yapar (ör. `ListView`).
  final Widget body;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: body),
          Padding(padding: EdgeInsets.all(context.spacing.lg), child: action),
        ],
      ),
    );
  }
}
