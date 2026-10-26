import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_labels.dart';

/// Kovandaki ananın kartı: işaret rengi, yıl ve renk, yaş ve ırk; altında
/// kaynak, hat, kanat ve anne ana. Altta sabit "Ana değiştir" yeni anayı
/// verir. Kovanda ana yoksa "Ana ver" sunulur. Tasarımdaki performans,
/// damızlık adaylığı ve soy zinciri verisi geldikçe eklenecek.
class QueenCardScreen extends ConsumerWidget {
  const new({required this.apiaryId, required this.hiveId, super.key});

  final String apiaryId;
  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return switch (ref.watch(hiveProvider(hiveId))) {
      AsyncData(value: final hive?) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.hiveLabel(hive.number)),
          actions: [
            if (ref.watch(hiveQueenProvider(hiveId)).value != null)
              TextButton(
                onPressed: () =>
                    context.go(AppRoutes.hiveQueenEdit(apiaryId, hiveId)),
                child: Text(l10n.queenEdit),
              ),
          ],
        ),
        body: switch (ref.watch(hiveQueenProvider(hiveId))) {
          AsyncData(value: final queen?) => BottomActionLayout(
            separated: true,
            body: ListView(
              padding: EdgeInsets.all(context.spacing.lg),
              children: [
                _Header(queen),
                SizedBox(height: context.spacing.xl),
                _Details(queen),
              ],
            ),
            action: BigButton(
              label: l10n.queenReplace,
              onPressed: () =>
                  context.go(AppRoutes.hiveQueenNew(apiaryId, hiveId)),
            ),
          ),
          AsyncData() => ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              EmptyState(
                icon: Icons.workspace_premium_outlined,
                title: l10n.queenNoneTitle,
                message: l10n.queenNoneMessage,
                actionLabel: l10n.queenGive,
                onAction: () =>
                    context.go(AppRoutes.hiveQueenNew(apiaryId, hiveId)),
              ),
            ],
          ),
          AsyncError() => Center(child: Text(l10n.hivesLoadError)),
          // Yerel DB'den okunuyor; hemen gelir.
          AsyncValue() => const SizedBox.shrink(),
        },
      ),
      AsyncData() => Scaffold(appBar: AppBar(), body: const HiveNotFound()),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

/// Solda işaret rengi dairede; sağda "ANA ARI", "2025 · Mavi" ve
/// "1 yaşında · Kafkas".
class _Header extends StatelessWidget {
  const new(this.queen);

  final Queen queen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = queen.detail(l10n, currentYear: clock.now().year);

    return MergeSemantics(
      child: Row(
        children: [
          QueenMarkCircle(
            markColor: queen.markColor,
            dimension: context.touchTargets.fieldLarge,
          ),
          SizedBox(width: context.spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(l10n.hiveQueenTitle),
                Semantics(
                  header: true,
                  child: Text(
                    queen.title(l10n),
                    style: context.typography.headline,
                  ),
                ),
                if (detail != null)
                  Text(
                    detail,
                    style: context.typography.body.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kaynak, hat, kanat ve anne ana 2×2 ızgarada (docs/design "Ana arı
/// kartı"); girilmeyen alan "Girilmedi" yazar.
class _Details extends ConsumerWidget {
  const new(this.queen);

  final Queen queen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final line = BorderSide(
      color: context.colors.divider,
      width: context.strokes.border,
    );

    Widget row(Widget start, Widget end) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: start),
          VerticalDivider(width: line.width, thickness: line.width),
          Expanded(child: end),
        ],
      ),
    );

    return AppCard(
      child: Column(
        children: [
          row(
            _DetailCell(
              label: l10n.queenSource,
              value: queen.source?.label(l10n) ?? l10n.queenUnknown,
            ),
            _DetailCell(label: l10n.queenMother, value: _mother(l10n, ref)),
          ),
          Divider(height: line.width, thickness: line.width),
          row(
            _DetailCell(
              label: l10n.queenBreedLine,
              value: queen.breedLine ?? l10n.queenUnknown,
            ),
            _DetailCell(
              label: l10n.queenWing,
              value: queen.wingClipped
                  ? l10n.queenWingClipped
                  : l10n.queenWingIntact,
            ),
          ),
        ],
      ),
    );
  }

  /// Anne ana kovandaysa "Kovan 88 · 2024 · Sarı"; kaydı bu telefonda
  /// yoksa (silinmiş ya da henüz inmemiş) bilinmiyor sayılır.
  String _mother(AppLocalizations l10n, WidgetRef ref) {
    final motherId = queen.motherQueenId;
    if (motherId == null) return l10n.queenMotherUnknown;
    final mother = ref.watch(queenProvider(motherId)).value;
    if (mother == null) return l10n.queenMotherUnknown;
    final hive = ref.watch(hivesByQueenProvider).value?[motherId];
    return mother.reference(l10n, hive: hive);
  }
}

/// Izgaranın hücresi: küçük büyük harfli ad, altında kalın değer; ekran
/// okuyucu ikisini birlikte okur.
class _DetailCell extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(label),
            Text(value, style: context.typography.label),
          ],
        ),
      ),
    );
  }
}
