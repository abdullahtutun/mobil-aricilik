import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';

/// İhbarı mecburi hastalıkta karantinaya alınacak kovanın seçimi: aktif
/// kovanlar numara sırasıyla, altında arılığı; üstte numaraya göre arama.
/// Karantinadaki kovanda "Karantinada" yazar, yeniden seçilirse hastalığı
/// güncellenir. Seçilince kovan hemen karantinaya alınır, kovan kartı
/// açılır ve 6 sn Geri al çıkar.
class QuarantineHiveScreen extends ConsumerStatefulWidget {
  const new({required this.ruleId, super.key});

  /// Şüphelenilen hastalığın kural kimliği.
  final String ruleId;

  @override
  ConsumerState<QuarantineHiveScreen> createState() =>
      _QuarantineHiveScreenState();
}

class _QuarantineHiveScreenState extends ConsumerState<QuarantineHiveScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final hives = ref.watch(organizationHivesProvider).value;
    final apiaries = {
      for (final summary
          in ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[])
        summary.apiary.id: summary.apiary.name,
    };
    final query = _query.trim().toLowerCase();
    final active = [
      for (final hive in hives ?? const <Hive>[])
        if (hive.status.isCounted && hive.number.toLowerCase().contains(query))
          hive,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quarantinePickTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: l10n.quarantineSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (query) => setState(() => _query = query),
          ),
          SizedBox(height: spacing.lg),
          // Yerel DB'den okunuyor; hemen gelir.
          if (hives != null)
            if (active.isEmpty)
              EmptyState(
                icon: Icons.hive_outlined,
                title: l10n.quarantineNoHivesTitle,
                message: l10n.quarantineNoHivesMessage,
              )
            else
              ListGroup(
                children: [
                  for (final hive in active)
                    ListRow(
                      title: l10n.hiveLabel(hive.number),
                      subtitle: apiaries[hive.apiaryId],
                      value: hive.quarantined ? l10n.hiveQuarantined : null,
                      valueColor: hive.quarantined
                          ? context.colors.statusCritical
                          : null,
                      onTap: () => _quarantine(hive),
                    ),
                ],
              ),
        ],
      ),
    );
  }

  Future<void> _quarantine(Hive hive) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(hiveActionsProvider.notifier);
    await actions.quarantine(hive.id, disease: widget.ruleId);
    if (!mounted) return;
    context.go(AppRoutes.hive(hive.apiaryId, hive.id));
    showUndoSnackBar(
      context,
      message: l10n.quarantineDone(hive.number),
      onUndo: () => actions.restoreQuarantine(hive),
    );
  }
}
