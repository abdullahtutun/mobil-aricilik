import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/feeding/presentation/feeding_form_controller.dart';
import 'package:mobil_arici/features/feeding/presentation/feeding_providers.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';

/// Besleme (docs/design "Besleme + şurup"): kovan ya da arılığın tümü; tür;
/// kovan başına miktar (kullanıcının biriminde); bal katı uyarısı; şurupta
/// gereken şeker ve su. Arılığın tümünde şurup bal katı olan kovanlara
/// yazılmaz. Kaydedince karta dönülür ve 6 sn geri alınabilir.
class FeedingFormScreen extends ConsumerWidget {
  const new({required this.hiveId, super.key});

  final String hiveId;

  FeedingFormControllerProvider get _provider =>
      feedingFormControllerProvider(hiveId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: Text(l10n.feedingFormTitle),
        ),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [_FeedingFormFields(_provider, form)],
          ),
          action: BigButton(
            label: l10n.feedingSave(_targets(ref, form).fed.length),
            onPressed:
                form.kind != null &&
                    !form.saving &&
                    _targets(ref, form).fed.isNotEmpty
                ? () => _save(context, ref, form)
                : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(appBar: AppBar(), body: const HiveNotFound()),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }

  /// Arılığın şu an bal katı olan kovanları; gelene kadar yok sayılır.
  static Set<String> _supers(WidgetRef ref, FeedingFormState form) =>
      ref.watch(apiaryHoneySuperHiveIdsProvider(form.hive.apiaryId)).value ??
      const {};

  /// Beslenecek ve dışarıda kalan kovanlar. Tek kovanda kovan bal katlı da
  /// olsa beslenir (yalnız uyarı); arılığın tümünde şurup bal katlılara
  /// yazılmaz. Kovan listesi gelene kadar en az bu kovan.
  static FeedingTargets _targets(WidgetRef ref, FeedingFormState form) {
    if (form.scope == FeedingScope.hive) {
      return (fed: [form.hive], skipped: const []);
    }
    final hives = ref.watch(apiaryHivesProvider(form.hive.apiaryId)).value;
    final active = hives == null ? [form.hive] : hives.where(canInspect);
    return feedingTargets(
      active.toList(),
      _supers(ref, form),
      form.kind ?? FeedingKind.beeCake,
    );
  }

  static int _activeInApiary(WidgetRef ref, FeedingFormState form) {
    final hives = ref.watch(apiaryHivesProvider(form.hive.apiaryId)).value;
    if (hives == null) return 1;
    return hives.where(canInspect).length;
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    FeedingFormState form,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(feedingActionsProvider.notifier);
    final feedings = await ref.read(_provider.notifier).save();
    // Kovan bu arada silindiyse ekran bunu gösterir.
    if (feedings == null || feedings.isEmpty || !context.mounted) return;
    showUndoSnackBar(
      context,
      message: form.scope == FeedingScope.hive
          ? l10n.feedingSaved(form.hive.number)
          : l10n.feedingSavedMany(feedings.length),
      onUndo: () => actions.undoAdd(feedings),
    );
    context.pop();
  }
}

class _FeedingFormFields extends ConsumerWidget {
  const new(this.provider, this.form);

  final FeedingFormControllerProvider provider;
  final FeedingFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final controller = ref.read(provider.notifier);
    final units = ref.watch(regionConfigProvider).defaultUnits;
    final kind = form.kind;
    final targets = FeedingFormScreen._targets(ref, form);
    final hiveHasSuper =
        form.scope == FeedingScope.hive &&
        FeedingFormScreen._supers(ref, form).contains(form.hive.id);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedTabs<FeedingScope>(
          options: [
            SegmentOption(
              value: FeedingScope.hive,
              label: l10n.feedingScopeHive(form.hive.number),
            ),
            SegmentOption(
              value: FeedingScope.apiary,
              label: l10n.feedingScopeApiary(
                FeedingFormScreen._activeInApiary(ref, form),
              ),
            ),
          ],
          selected: form.scope,
          onChanged: controller.setScope,
        ),
        SizedBox(height: spacing.lg),
        LabeledField(
          label: l10n.feedingKind,
          group: true,
          child: ChoiceChipGroup<FeedingKind>(
            columns: 2,
            options: [
              for (final kind in FeedingKind.values)
                ChoiceChipOption(value: kind, label: kind.label(l10n)),
            ],
            selected: {?kind},
            onChanged: (selected) {
              // Seçili chip'e yeniden dokunmak seçimi kaldırmasın.
              if (selected.isEmpty) return;
              controller.selectKind(selected.single);
            },
          ),
        ),
        if (kind != null) ...[
          SizedBox(height: spacing.lg),
          BigStepper(
            label: l10n.feedingAmount(_unitLabel(l10n, kind, units)),
            value: form.amount,
            min: 1,
            max: maxFeedingAmount,
            onChanged: controller.setAmount,
          ),
          if (kind.isSyrup && hiveHasSuper) ...[
            SizedBox(height: spacing.lg),
            _SuperWarning(
              title: l10n.feedingSuperHiveTitle,
              message: l10n.feedingSuperHiveMessage,
            ),
          ],
          if (targets.skipped.isNotEmpty) ...[
            SizedBox(height: spacing.lg),
            _SuperWarning(
              title: l10n.feedingSuperSkippedTitle(targets.skipped.length),
              message: l10n.feedingSuperSkippedMessage(
                [for (final hive in targets.skipped) hive.number].join(', '),
              ),
            ),
          ],
          if (targets.fed.isNotEmpty) ...[
            SizedBox(height: spacing.lg),
            _PrepareCard(
              kind: kind,
              hives: targets.fed.length,
              amount: form.amount,
              units: units,
            ),
          ],
        ],
      ],
    );
  }
}

/// Miktarın kullanıcının birimindeki adı: şurupta hacim, değilse kütle.
String _unitLabel(
  AppLocalizations l10n,
  FeedingKind kind,
  DefaultUnits units,
) => kind.isSyrup ? units.volume.label(l10n) : units.mass.label(l10n);

/// Bal katı uyarısı; uyarı zemininde, ikon ve kalın başlıkla.
class _SuperWarning extends StatelessWidget {
  const new({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final body = context.typography.body;

    return MergeSemantics(
      child: AppCard(
        status: AppStatus.warning,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: context.sizes.icon,
                color: colors.statusWarning,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: body.copyWith(
                          color: colors.statusWarning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: message),
                    ],
                  ),
                  style: body.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hazırlanacak toplam: koyu zeminde "37 kovan × 3 L", büyük toplam; şurupta
/// altında yaklaşık şeker ve su. Hepsi kullanıcının biriminde.
class _PrepareCard extends StatelessWidget {
  const new({
    required this.kind,
    required this.hives,
    required this.amount,
    required this.units,
  });

  final FeedingKind kind;
  final int hives;

  /// Kovan başına, kullanıcının biriminde.
  final int amount;
  final DefaultUnits units;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final unit = _unitLabel(l10n, kind, units);
    final total = format.number(amount * hives);
    final recipe = syrupRecipe(
      kind,
      units.volume.convert((amount * hives).toDouble(), to: VolumeUnit.liter),
    );

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.inverseSurface,
          borderRadius: BorderRadius.circular(context.radii.card),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: spacing.sm,
                children: [
                  Text(
                    format.upperCase(l10n.feedingPrepare),
                    style: typography.labelSmall.copyWith(
                      color: colors.onInverseSurface,
                    ),
                  ),
                  Text(
                    l10n.feedingPrepareCount(
                      hives,
                      format.number(amount),
                      unit,
                    ),
                    style: typography.bodySmall.copyWith(
                      color: colors.onInverseSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.sm),
              Text(
                switch (kind) {
                  FeedingKind.syrup1to1 ||
                  FeedingKind.syrup2to1 => l10n.feedingTotalSyrup(total, unit),
                  FeedingKind.beeCake => l10n.feedingTotalBeeCake(total, unit),
                  FeedingKind.pollenSubstitute =>
                    l10n.feedingTotalPollenSubstitute(total, unit),
                },
                style: typography.display.copyWith(
                  color: colors.onInverseSurface,
                ),
              ),
              if (recipe != null) ...[
                SizedBox(height: spacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _Ingredient(
                        label: l10n.feedingSugar,
                        value: l10n.feedingApprox(
                          _approx(
                            format,
                            MassUnit.kilogram.convert(
                              recipe.sugarKg,
                              to: units.mass,
                            ),
                          ),
                          units.mass.label(l10n),
                        ),
                      ),
                    ),
                    SizedBox(width: context.touchTargets.gap),
                    Expanded(
                      child: _Ingredient(
                        label: l10n.feedingWater,
                        value: l10n.feedingApprox(
                          _approx(
                            format,
                            VolumeUnit.liter.convert(
                              recipe.waterLiters,
                              to: units.volume,
                            ),
                          ),
                          units.volume.label(l10n),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Yaklaşık miktar: 10 ve üstü tam sayı, altı bir ondalık.
  static String _approx(AppFormat format, double value) =>
      format.number(value, maxFractionDigits: value >= 10 ? 0 : 1);
}

/// Şeker ya da su: üstte adı, altta bal renginde yaklaşık miktar.
class _Ingredient extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.typography.bodySmall.copyWith(
            color: colors.onInverseSurface,
          ),
        ),
        Text(
          value,
          style: context.typography.number.copyWith(
            color: colors.inversePrimary,
          ),
        ),
      ],
    );
  }
}
