import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_label_providers.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';

/// Tanınmayan etiketi kovana atar: kovanlar arılıklarına göre listelenir,
/// numarayla aranır. Seçilen kovanın başka etiketi varsa önce sorulur.
/// Atanınca kovan kartı açılır; sonra bu etiket okutulunca da açılır.
class AssignLabelScreen extends ConsumerStatefulWidget {
  const new({required this.code, super.key});

  /// Okutulan kodun ham hâli.
  final String code;

  @override
  ConsumerState<AssignLabelScreen> createState() => _AssignLabelScreenState();
}

class _AssignLabelScreenState extends ConsumerState<AssignLabelScreen> {
  var _query = '';
  var _saving = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.labelAssignTitle)),
      body: switch ((
        ref.watch(apiaryListProvider),
        ref.watch(organizationHivesProvider),
      )) {
        (AsyncData(value: final apiaries), AsyncData(value: final hives)) =>
          ListView(
            padding: EdgeInsets.all(spacing.lg),
            children: [
              Text(
                l10n.labelAssignMessage,
                style: context.typography.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              if (hives.isEmpty) ...[
                SizedBox(height: spacing.xl),
                Text(l10n.labelAssignNoHives, style: context.typography.body),
              ] else ...[
                SizedBox(height: spacing.lg),
                TextField(
                  decoration: InputDecoration(
                    hintText: l10n.labelAssignSearch,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (query) => setState(() => _query = query),
                ),
                ..._groups(context, apiaries, hives),
              ],
            ],
          ),
        (AsyncError(), _) ||
        (_, AsyncError()) => Center(child: Text(l10n.hivesLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        _ => const SizedBox.shrink(),
      },
    );
  }

  /// Arama metnine uyan kovanlar, arılık sırasıyla başlıklarının altında.
  List<Widget> _groups(
    BuildContext context,
    List<ApiarySummary> apiaries,
    List<Hive> hives,
  ) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final query = _query.trim().toLowerCase();
    final matches = [
      for (final hive in hives)
        if (hive.number.toLowerCase().contains(query)) hive,
    ];
    if (matches.isEmpty) {
      return [
        SizedBox(height: spacing.xl),
        Text(l10n.labelAssignNoMatch, style: context.typography.body),
      ];
    }
    return [
      for (final summary in apiaries)
        if (matches.where((h) => h.apiaryId == summary.apiary.id).toList()
            case final group when group.isNotEmpty) ...[
          SizedBox(height: spacing.xl),
          Semantics(
            header: true,
            child: Text(summary.apiary.name, style: context.typography.title),
          ),
          SizedBox(height: spacing.sm),
          for (final hive in group)
            _HiveRow(
              hive: hive,
              hasOtherLabel:
                  hive.tagCode != null &&
                  hive.tagCode != normalizeLabelCode(widget.code),
              onTap: _saving ? null : () => _assign(hive),
            ),
        ],
    ];
  }

  Future<void> _assign(Hive hive) async {
    final l10n = AppLocalizations.of(context);
    final code = normalizeLabelCode(widget.code);
    if (hive.tagCode != null && hive.tagCode != code) {
      final replace = await showConfirmDialog(
        context,
        title: l10n.labelReplaceTitle(hive.number),
        message: l10n.labelReplaceMessage,
        confirmLabel: l10n.labelReplaceConfirm,
      );
      if (!replace || !mounted) return;
    }

    setState(() => _saving = true);
    final saved = await ref
        .read(hiveLabelActionsProvider.notifier)
        .assign(hive.id, widget.code);
    if (!mounted) return;
    showMessageSnackBar(context, l10n.labelAssigned(saved.number));
    context.go(AppRoutes.hive(saved.apiaryId, saved.id));
  }
}

/// Kovan satırı: numara; başka etiketi varsa ya da aktif değilse altında
/// yazar.
class _HiveRow extends StatelessWidget {
  const new({
    required this.hive,
    required this.hasOtherLabel,
    required this.onTap,
  });

  final Hive hive;
  final bool hasOtherLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return OptionTile(
      icon: Icons.hive_rounded,
      label: l10n.hiveLabel(hive.number),
      hint: hasOtherLabel ? l10n.labelAssignHasOther : null,
      badge: hive.status.isCounted
          ? null
          : StatusBadge(
              status: hive.status.appStatus,
              label: hive.status.label(l10n),
            ),
      onTap: onTap,
    );
  }
}
