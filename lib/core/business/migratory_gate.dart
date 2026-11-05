import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/business/business_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Gezginci modülünün rotalarını (göç planı, durak, taşıma) işletme türüne
/// bağlar. Sabit işletmede rotaya elle ya da eski bir bağlantıyla
/// gidilirse çökmez: boş durum gösterilir; kayıtlar silinmez, tür yeniden
/// gezginci olunca ekran geri gelir.
class MigratoryGate extends ConsumerWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final migratory = ref.watch(
      businessConfigProvider.select((config) => config.features.migratory),
    );
    if (migratory) return child;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreMigratory)),
      body: Center(
        child: EmptyState(
          icon: Icons.local_shipping_outlined,
          title: l10n.migratoryHiddenTitle,
          message: l10n.migratoryHiddenMessage,
        ),
      ),
    );
  }
}
