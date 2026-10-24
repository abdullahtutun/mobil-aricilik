import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/action_tile.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Seçim sayfasını sekmelerin ve alt gezinmenin üstünde açar; seçilen
/// değeri, kapatılırsa null döner. [builder] genelde bir [OptionSheet] verir.
Future<T?> showOptionSheet<T>(BuildContext context, WidgetBuilder builder) =>
    showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: builder,
    );

/// [OptionSheet]'teki bir seçenek; dokunulunca sayfa [value] ile kapanır.
class SheetOption<T> {
  const new({
    required this.value,
    required this.icon,
    required this.label,
    this.iconColor,
    this.hint,
    this.selected,
  });

  final T value;
  final IconData icon;

  /// Boşsa primary.
  final Color? iconColor;
  final String label;

  /// Etiketin altında ikincil satır.
  final String? hint;

  /// Seçim listesinde: ekran okuyucuya seçili olup olmadığı söylenir.
  final bool? selected;
}

/// Seçim sayfası: başlık ve seçenekler. Seçenek yoksa [emptyMessage] yazar.
///
/// Sayfa kök navigator'da açıldığı için seçim sayfanın kendi navigator'ıyla
/// döner; go_router'ın pop'u alttaki sekme yığınını kapatabilir.
class OptionSheet<T> extends StatelessWidget {
  const new({
    required this.title,
    required this.options,
    super.key,
    this.emptyMessage,
  });

  final String title;
  final List<SheetOption<T>> options;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final emptyMessage = this.emptyMessage;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: spacing.lg,
          right: spacing.lg,
          bottom: spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: context.typography.title),
            ),
            SizedBox(height: spacing.md),
            if (options.isEmpty && emptyMessage != null)
              Text(
                emptyMessage,
                style: context.typography.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            for (final option in options)
              OptionTile(
                icon: option.icon,
                iconColor: option.iconColor,
                label: option.label,
                hint: option.hint,
                selected: option.selected,
                onTap: () => Navigator.of(context).pop(option.value),
              ),
          ],
        ),
      ),
    );
  }
}

/// Seçim sayfasının ızgara hali: başlık ve [columns] sütunlu büyük
/// karolar ([ActionTile]). [highlighted] seçenek dolgulu çizilir (ör. en
/// sık kayıt). Seçim [OptionSheet]'teki gibi sayfanın navigator'ıyla döner.
class OptionGridSheet<T> extends StatelessWidget {
  const new({
    required this.title,
    required this.options,
    super.key,
    this.highlighted,
    this.columns = 3,
  });

  final String title;
  final List<SheetOption<T>> options;
  final T? highlighted;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final gap = context.touchTargets.gap;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: spacing.lg,
          right: spacing.lg,
          bottom: spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: gap,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: context.typography.title),
            ),
            for (var row = 0; row < options.length; row += columns)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: gap,
                  children: [
                    for (var i = row; i < row + columns; i++)
                      Expanded(
                        child: i < options.length
                            ? ActionTile(
                                icon: options[i].icon,
                                label: options[i].label,
                                iconColor: options[i].iconColor,
                                highlighted: options[i].value == highlighted,
                                onTap: () =>
                                    Navigator.of(context).pop(options[i].value),
                              )
                            : const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Dokunulabilir seçenek satırı: ikon, etiket, altında isteğe bağlı ipucu
/// ve [badge]. Ekran okuyucu satırı tek buton olarak okur.
class OptionTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.iconColor,
    this.hint,
    this.badge,
    this.selected,
  });

  final IconData icon;

  /// Boşsa primary.
  final Color? iconColor;
  final String label;

  /// Etiketin altında ikincil satır.
  final String? hint;

  /// İpucunun altında; ör. durum rozeti.
  final Widget? badge;

  /// Null ise satır pasif.
  final VoidCallback? onTap;

  /// Seçim listesinde: ekran okuyucuya seçili olup olmadığı söylenir.
  /// Seçimi çizmek (ör. onay ikonu) çağırana kalır.
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final hint = this.hint;
    final badge = this.badge;

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radii.button),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: context.sizes.icon,
                  color: iconColor ?? context.colors.primary,
                ),
                SizedBox(width: spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: context.typography.label),
                      if (hint != null)
                        Text(
                          hint,
                          style: context.typography.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      if (badge != null) ...[
                        SizedBox(height: spacing.xs),
                        badge,
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
