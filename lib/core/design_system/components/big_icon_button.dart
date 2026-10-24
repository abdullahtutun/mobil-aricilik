import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// `BigButton`'ın yanında duran kare ikon butonu (foto, mikrofon): aynı
/// yükseklikte (`touchTargets.button`), beyaz zeminde çizgi çerçeveli.
/// [label] ipucu ve ekran okuyucu adı. [active] seçili hâl (ör. kayıt
/// sürüyor): kritik renkte çerçeve ve ikon. [onPressed] null ise pasif.
class BigIconButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.touchTargets.button;
    final accent = active ? colors.statusCritical : colors.textPrimary;

    return Semantics(
      selected: active,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: context.sizes.icon,
        style: IconButton.styleFrom(
          fixedSize: Size.square(size),
          minimumSize: Size.square(size),
          backgroundColor: colors.tile,
          foregroundColor: accent,
          disabledForegroundColor: colors.textSecondary,
          side: BorderSide(
            color: active ? colors.statusCritical : colors.divider,
            width: context.strokes.focus,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radii.button),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
      ),
    );
  }
}
