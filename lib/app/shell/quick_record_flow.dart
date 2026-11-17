import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/quick_record_sheet.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Hızlı kayıt (teknik.md §8): tür seçilir, kayıt bir kovana ya da
/// arılığa aitse arılık ve kovan sorulur, sonra kaydın formu açılır.
/// Muayene, besleme ve ilaçlama kovanın formunu; not kovan kartını (ses
/// ve foto butonları orada); hasat arılığın hasadını; gider gider formunu
/// açar. Besleme ve ilaçlamada kovan listesinin başında "Arılığın tümü"
/// var. Tek arılık varsa arılık sorulmaz. Her seçim alttan açılan
/// sayfada, büyük satırlarla; eldivenle de seçilir.
///
/// Alt gezinmedeki Okut basılı tutulunca, yukarı kaydırılınca ve Okut
/// ekranındaki "Hızlı kayıt" butonundan açılır.
Future<void> startQuickRecord(BuildContext context, WidgetRef ref) async {
  final type = await showQuickRecordSheet(
    context,
    showExpense: ref.read(canSeeFinanceProvider),
  );
  if (type == null || !context.mounted) return;
  if (type == QuickRecordType.expense) {
    context.go(AppRoutes.financeNew(TransactionKind.expense));
    return;
  }

  final apiaryId = await _pickApiary(context, ref);
  if (apiaryId == null || !context.mounted) return;
  if (type == QuickRecordType.harvest) {
    context.go(AppRoutes.apiaryHarvest(apiaryId));
    return;
  }

  final wholeApiaryAllowed =
      type == QuickRecordType.feeding || type == QuickRecordType.treatment;
  final target = await _pickHive(
    context,
    ref,
    apiaryId,
    offerWholeApiary: wholeApiaryAllowed,
  );
  if (target == null || !context.mounted) return;
  final (:hive, :wholeApiary) = target;
  context.go(switch (type) {
    QuickRecordType.inspection => AppRoutes.hiveInspect(apiaryId, hive.id),
    QuickRecordType.feeding => AppRoutes.hiveFeed(
      apiaryId,
      hive.id,
      wholeApiary: wholeApiary,
    ),
    QuickRecordType.treatment => AppRoutes.hiveTreat(
      apiaryId,
      hive.id,
      wholeApiary: wholeApiary,
    ),
    QuickRecordType.note => AppRoutes.hive(apiaryId, hive.id),
    QuickRecordType.harvest ||
    QuickRecordType.expense => throw StateError('$type yukarıda açıldı'),
  });
}

/// İşletmenin arılıklarından biri; tek arılık varsa sormadan o. Arılık
/// yoksa nedeni söylenir ve null döner.
Future<String?> _pickApiary(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final orgId = ref.read(currentOrgIdProvider);
  if (orgId == null) return null;
  // Tek seferlik okuma; açık akış beklemez.
  final summaries = await ref.read(apiaryRepositoryProvider).summaries(orgId);
  if (!context.mounted) return null;
  summaries.sort((a, b) => compareNatural(a.apiary.name, b.apiary.name));
  switch (summaries) {
    case []:
      showMessageSnackBar(context, l10n.quickRecordNoApiary);
      return null;
    case [final only]:
      return only.apiary.id;
    default:
      return await showOptionSheet<String>(
        context,
        (context) => OptionSheet<String>(
          title: l10n.taskFormChooseApiary,
          options: [
            for (final summary in summaries)
              SheetOption(
                value: summary.apiary.id,
                icon: Icons.place_outlined,
                label: summary.apiary.name,
                hint: l10n.moveSourceHives(summary.activeHiveCount),
              ),
          ],
        ),
      );
  }
}

/// Arılığın aktif kovanlarından biri, numara sırasıyla. [offerWholeApiary]
/// ise başta "Arılığın tümü" var; seçilirse ilk aktif kovan ve
/// `wholeApiary` true döner (form arılığın tümü seçili açılır). Aktif
/// kovan yoksa nedeni söylenir ve null döner.
Future<({Hive hive, bool wholeApiary})?> _pickHive(
  BuildContext context,
  WidgetRef ref,
  String apiaryId, {
  required bool offerWholeApiary,
}) async {
  final l10n = AppLocalizations.of(context);
  final hives =
      (await ref.read(hiveRepositoryProvider).findByApiary(apiaryId))
          .where(canInspect)
          .toList()
        ..sort((a, b) => compareNatural(a.number, b.number));
  if (!context.mounted) return null;
  if (hives.isEmpty) {
    showMessageSnackBar(context, l10n.harvestNoActiveHives);
    return null;
  }
  // Boş kimlik "Arılığın tümü"; kovan kimliği hiç boş olmaz.
  const wholeApiaryValue = '';
  final picked = await showOptionSheet<String>(
    context,
    (context) => OptionSheet<String>(
      title: l10n.taskFormChooseHive,
      options: [
        if (offerWholeApiary)
          SheetOption(
            value: wholeApiaryValue,
            icon: Icons.grid_view_rounded,
            label: l10n.feedingScopeApiary(hives.length),
          ),
        for (final hive in hives)
          SheetOption(
            value: hive.id,
            icon: Icons.hive_outlined,
            label: l10n.hiveLabel(hive.number),
          ),
      ],
    ),
  );
  if (picked == null) return null;
  if (picked == wholeApiaryValue) {
    return (hive: hives.first, wholeApiary: true);
  }
  final hive = hives.firstWhere((hive) => hive.id == picked);
  return (hive: hive, wholeApiary: false);
}
