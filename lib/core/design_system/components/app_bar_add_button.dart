import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Üst çubuktaki ekle butonu: soluk zeminde köşeli kare, birincil renkte
/// "+" (docs/design "Belge kasası", "Malzeme ve stok"). [label] ipucu ve
/// ekran okuyucu adı.
class AppBarAddButton extends StatelessWidget {
  const new({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.touchTargets.field;
    return Padding(
      padding: EdgeInsetsDirectional.only(end: context.spacing.sm),
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: const Icon(Icons.add_rounded),
        iconSize: context.sizes.icon,
        color: colors.primary,
        style: IconButton.styleFrom(
          backgroundColor: colors.surfaceContainer,
          fixedSize: Size.square(size),
          minimumSize: Size.square(size),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radii.card),
          ),
        ),
      ),
    );
  }
}
