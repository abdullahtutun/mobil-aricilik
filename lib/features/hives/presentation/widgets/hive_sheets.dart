import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';

enum AddHivesChoice { one, bulk }

/// Kovan ekle: tek kovan ya da toplu oluşturma. Kapatılırsa null.
Future<AddHivesChoice?> showAddHivesSheet(BuildContext context) =>
    _showSheet(context, (context) {
      final l10n = AppLocalizations.of(context);
      return _Sheet(
        title: l10n.hivesAdd,
        children: [
          _Option(
            icon: Icons.add_rounded,
            label: l10n.hivesAddOne,
            hint: l10n.hivesAddOneHint,
            onTap: () => Navigator.of(context).pop(AddHivesChoice.one),
          ),
          _Option(
            icon: Icons.library_add_rounded,
            label: l10n.hivesAddBulk,
            hint: l10n.hivesAddBulkHint,
            onTap: () => Navigator.of(context).pop(AddHivesChoice.bulk),
          ),
        ],
      );
    });

/// Kovanın yeni durumu; şimdiki durum listede yok. Kapatılırsa null.
Future<HiveStatus?> showHiveStatusSheet(BuildContext context, Hive hive) =>
    _showSheet(context, (context) {
      final l10n = AppLocalizations.of(context);
      final colors = context.colors;
      return _Sheet(
        title: l10n.hiveStatusSheetTitle(hive.number),
        children: [
          for (final status in HiveStatus.values)
            if (status != hive.status)
              _Option(
                icon: status.appStatus.icon,
                iconColor: status.appStatus.colorIn(colors),
                label: status.label(l10n),
                onTap: () => Navigator.of(context).pop(status),
              ),
        ],
      );
    });

/// Kovanın taşınacağı arılık; bulunduğu arılık listede yok. Kapatılırsa
/// null.
Future<Apiary?> showHiveMoveSheet(BuildContext context, Hive hive) =>
    _showSheet(context, (context) => _MoveSheet(hive));

/// Aktif kovan sayısını düşüren durum değişikliği için onay; vazgeçilirse
/// false.
Future<bool> confirmHiveStatusChange(
  BuildContext context, {
  required String number,
  required HiveStatus status,
}) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.hiveStatusConfirmTitle(status.value, number)),
      content: Text(l10n.hiveStatusConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.hiveStatusConfirm),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Sayfalar sekmelerin üstünde açılır. Seçim sayfanın kendi navigator'ıyla
/// döner; go_router'ın pop'u alttaki sekme yığınını kapatabilir.
Future<T?> _showSheet<T>(BuildContext context, WidgetBuilder builder) =>
    showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: builder,
    );

class _MoveSheet extends ConsumerWidget {
  const new(this.hive);

  final Hive hive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final targets = [
      for (final summary
          in ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[])
        if (summary.apiary.id != hive.apiaryId) summary,
    ];
    return _Sheet(
      title: l10n.hiveMoveTitle(hive.number),
      children: [
        if (targets.isEmpty)
          Text(
            l10n.hiveMoveNoOtherApiary,
            style: context.typography.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        for (final target in targets)
          _Option(
            icon: Icons.place_rounded,
            label: target.apiary.name,
            hint: l10n.apiaryHiveCount(target.activeHiveCount),
            onTap: () => Navigator.of(context).pop(target.apiary),
          ),
      ],
    );
  }
}

class _Sheet extends StatelessWidget {
  const new({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
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
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.hint,
  });

  final IconData icon;
  final Color? iconColor;
  final String label;

  /// Etiketin altında ikincil satır.
  final String? hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final hint = this.hint;
    return Semantics(
      container: true,
      button: true,
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
