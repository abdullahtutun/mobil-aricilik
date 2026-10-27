import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';

/// Planın sıradaki taşıması (docs/design "Taşıma · yükleme"); başlıkta
/// nereden nereye. Kontrol, yükleme ve indirme adımları sonraki adımda bu
/// rotaya kurulacak; şimdilik yalnız başlık ve "yakında" notu. Planlı
/// durak kalmadıysa bunu söyler.
class MoveScreen extends ConsumerWidget {
  const new({required this.migrationId, super.key});

  final String migrationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return switch (ref.watch(migrationStopsProvider(migrationId))) {
      AsyncData(value: final stops) => switch (nextMove(stops)) {
        (:final from, :final to) => Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.moveTitle(
                from == null
                    ? to.name
                    : l10n.migrationRoute(from.name, to.name),
              ),
            ),
          ),
          body: EmptyState(
            icon: Icons.local_shipping_outlined,
            title: l10n.moveComingTitle,
            message: l10n.moveComingMessage,
            centered: true,
          ),
        ),
        null => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(l10n.moveNone)),
        ),
      },
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.migrationsLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}
