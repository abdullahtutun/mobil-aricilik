import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/harvest_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_providers.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'harvest_form_controller.freezed.dart';
part 'harvest_form_controller.g.dart';

@freezed
abstract class HarvestFormState with _$HarvestFormState {
  const factory({
    /// Hasat günü (yerel takvimde gece yarısı); gelecek olamaz.
    required DateTime day,

    /// Hasada alınacak kovanlar. Bekleme süresindeki kovan ancak
    /// [overrides]'ta gerekçesi varsa alınır ([harvestTargets]).
    required Set<String> selected,
    @Default(<String, WithdrawalOverride>{})
    Map<String, WithdrawalOverride> overrides,

    /// Seçilene kadar boş ve Kaydet kapalı.
    HoneyKind? honeyKind,
    @Default(HarvestUnit.superBox) HarvestUnit unit,
    @Default(1) int unitCount,

    /// Süzülen bal, kullanıcının yazdığı gibi (kullanıcının biriminde).
    @Default('') String weight,
    @Default(false) bool saving,
  }) = _HarvestFormState;
}

/// Okutulan kovanın sonucu.
enum HarvestScanResult {
  /// Seçime eklendi.
  added,

  /// Zaten seçiliydi.
  alreadySelected,

  /// Bu arılıkta değil; eklenmedi.
  otherApiary,

  /// Aktif değil (sönmüş, satılmış…); eklenmedi.
  inactive,

  /// Bekleme süresinde; eklenmedi. Ancak gerekçeyle eklenir
  /// ([HarvestFormController.select]).
  locked,
}

/// Hasat formu (arılığın hasadı). Ekran ve okutma ekranı açık kaldığı
/// sürece yaşar. Açılınca arılığın aktif kovanlarından o gün bekleme
/// süresinde olmayanlar seçili gelir. Hasat ve kovanları yerel DB'ye tek
/// transaction'da yazılır.
@riverpod
class HarvestFormController extends _$HarvestFormController {
  @override
  Future<HarvestFormState> build(String apiaryId) async {
    final day = localDay(clock.now());
    final hives = await _activeHives();
    final locks = await _locks(hives, day);
    return HarvestFormState(
      day: day,
      selected: {
        for (final hive in hives)
          if (!locks.containsKey(hive.id)) hive.id,
      },
    );
  }

  void setDay(DateTime day) =>
      _update((form) => form.copyWith(day: localDay(day)));

  /// [hiveId]'yi seçer; bekleme süresindeyse gerekçesi [withdrawalOverride].
  void select(String hiveId, {WithdrawalOverride? withdrawalOverride}) =>
      _update(
        (form) => form.copyWith(
          selected: {...form.selected, hiveId},
          overrides: {...form.overrides, hiveId: ?withdrawalOverride},
        ),
      );

  /// Seçimden çıkarır; gerekçesi de unutulur.
  void deselect(String hiveId) => _update(
    (form) => form.copyWith(
      selected: {...form.selected}..remove(hiveId),
      overrides: {...form.overrides}..remove(hiveId),
    ),
  );

  /// [hives]'ı seçer (öncekiler kalır; gerekçeler korunur).
  void selectAll(Iterable<Hive> hives) => _update(
    (form) => form.copyWith(
      selected: {...form.selected, for (final hive in hives) hive.id},
    ),
  );

  void clearSelection() =>
      _update((form) => form.copyWith(selected: const {}, overrides: const {}));

  /// Okutulan [hive]'ı seçime ekler; [lock] kovanın o günkü kilidi.
  /// Bekleme süresindeki kovan eklenmez ([HarvestScanResult.locked]).
  HarvestScanResult addScanned(Hive hive, {WithdrawalLock? lock}) {
    final form = state.value;
    if (form == null) return HarvestScanResult.inactive;
    if (hive.apiaryId != apiaryId) return HarvestScanResult.otherApiary;
    if (!canInspect(hive)) return HarvestScanResult.inactive;
    if (form.selected.contains(hive.id)) {
      return HarvestScanResult.alreadySelected;
    }
    if (lock != null) return HarvestScanResult.locked;
    select(hive.id);
    return HarvestScanResult.added;
  }

  void selectHoneyKind(HoneyKind kind) =>
      _update((form) => form.copyWith(honeyKind: kind));

  void setUnit(HarvestUnit unit) =>
      _update((form) => form.copyWith(unit: unit));

  void setUnitCount(int count) =>
      _update((form) => form.copyWith(unitCount: count));

  void setWeight(String weight) =>
      _update((form) => form.copyWith(weight: weight));

  /// Hasadı yazar ve döner. Kovanlar ve kilitler yazma anında yeniden
  /// okunur: bu arada arılıktan çıkan ya da aktif olmayan kovan ve gerekçesiz
  /// kilitli kovan alınmaz. Bal türü, ağırlık ya da alınacak kovan yoksa
  /// null.
  Future<HarvestRecord?> save() async {
    final form = state.value;
    final honeyKind = form?.honeyKind;
    final weight = parseHarvestWeight(form?.weight ?? '');
    if (form == null || honeyKind == null || weight == null || form.saving) {
      return null;
    }
    _update((form) => form.copyWith(saving: true));

    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final hives = await _activeHives();
      final targets = harvestTargets(
        hives: hives,
        selected: form.selected,
        locks: await _locks(hives, form.day),
        overrides: form.overrides,
      );
      if (targets.harvested.isEmpty) return null;
      final today = localDay(clock.now());
      final plan = (
        apiaryId: apiaryId,
        // Bugünün hasadı şimdiki saatle; geçmiş gün öğlen.
        harvestedAt: form.day == today
            ? clock.now()
            : form.day.add(const Duration(hours: 12)),
        honeyKind: honeyKind,
        unit: form.unit,
        unitCount: form.unitCount,
        netKg: storedHarvestKg(
          weight,
          ref.read(regionConfigProvider).defaultUnits.mass,
        ),
      );
      return await ref
          .read(harvestRepositoryProvider)
          .add(
            orgId: targets.harvested.first.orgId,
            plan: plan,
            hiveIds: [for (final hive in targets.harvested) hive.id],
            overrides: form.overrides,
          );
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  /// Arılığın şu anki aktif kovanları; yerel DB'den okuma anında.
  Future<List<Hive>> _activeHives() async => [
    for (final hive
        in await ref.read(hiveRepositoryProvider).findByApiary(apiaryId))
      if (canInspect(hive)) hive,
  ];

  Future<Map<String, WithdrawalLock>> _locks(
    List<Hive> hives,
    DateTime day,
  ) async => withdrawalLocksByHive(
    await ref.read(treatmentRepositoryProvider).findByHives([
      for (final hive in hives) hive.id,
    ]),
    now: day,
  );

  void _update(HarvestFormState Function(HarvestFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
