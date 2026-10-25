import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'treatment_form_controller.freezed.dart';
part 'treatment_form_controller.g.dart';

/// Uygulamanın yazılacağı kovanlar: açılan kovan ya da arılığındaki tüm
/// aktif kovanlar.
enum TreatmentScope { hive, apiary }

@freezed
abstract class TreatmentFormState with _$TreatmentFormState {
  const factory({
    required Hive hive,

    /// Başlangıç günü (yerel takvimde gün başı).
    required DateTime startedOn,
    @Default(TreatmentScope.hive) TreatmentScope scope,

    /// Seçilene kadar boş ve Kaydet kapalı.
    DrugChoice? drug,
    @Default(1) int dose,
    @Default(0) int withdrawalDays,

    /// Planlanan çıkarma günü; tek seferlik uygulamada boş.
    DateTime? removalOn,
    @Default('') String batchNo,
    @Default(false) bool saving,
  }) = _TreatmentFormState;
}

extension TreatmentFormResult on TreatmentFormState {
  bool get canSave => drug != null && !saving;

  /// Bal katı ve hasatın serbest kaldığı gün.
  DateTime get withdrawalEnd => withdrawalEndDate(
    startedAt: startedOn,
    plannedRemovalAt: removalOn,
    withdrawalDays: withdrawalDays,
  );

  /// Planlanan çıkarmanın seçilebileceği ilk gün: başlangıçtan sonraki gün.
  DateTime get firstRemovalDay =>
      DateTime(startedOn.year, startedOn.month, startedOn.day + 1);
}

/// İlaç uygulaması formu. Ekran açık kaldığı sürece yaşar. Kovan yoksa
/// durum null. Uygulama yerel DB'ye yazılır; arılığın tümü seçiliyse
/// arılıktaki her aktif kovana tek transaction'da.
@riverpod
class TreatmentFormController extends _$TreatmentFormController {
  @override
  Future<TreatmentFormState?> build(String hiveId) async {
    final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
    if (hive == null) return null;
    final now = clock.now();
    return TreatmentFormState(
      hive: hive,
      startedOn: DateTime(now.year, now.month, now.day),
    );
  }

  void setScope(TreatmentScope scope) =>
      _update((form) => form.copyWith(scope: scope));

  /// İlacı seçer; bekleme süresi ilacın etiketinden (bilinmiyorsa 0),
  /// planlanan çıkarma birime göre önerilir.
  void selectDrug(DrugChoice drug) => _update(
    (form) => form.copyWith(
      drug: drug,
      withdrawalDays: drug.withdrawalDays ?? 0,
      removalOn: defaultPlannedRemoval(drug.doseUnit, form.startedOn),
    ),
  );

  void setBatchNo(String batchNo) =>
      _update((form) => form.copyWith(batchNo: batchNo));

  void setDose(int dose) => _update((form) => form.copyWith(dose: dose));

  void setWithdrawalDays(int days) =>
      _update((form) => form.copyWith(withdrawalDays: days));

  /// Başlangıç değişince çıkarma ondan önce ya da aynı gün kalırsa birime
  /// göre yeniden önerilir.
  void setStartedOn(DateTime day) => _update((form) {
    final removal = form.removalOn;
    final drug = form.drug;
    return form.copyWith(
      startedOn: day,
      removalOn: removal == null || removal.isAfter(day)
          ? removal
          : drug == null
          ? null
          : defaultPlannedRemoval(drug.doseUnit, day),
    );
  });

  void setRemovalOn(DateTime? day) =>
      _update((form) => form.copyWith(removalOn: day));

  /// Uygulamayı yazar ve yazılanları döner; ilaç seçilmemişse ya da kovan
  /// bu arada silindiyse null.
  Future<List<Treatment>?> save() async {
    final form = state.value;
    final drug = form?.drug;
    if (form == null || drug == null || form.saving) return null;
    _update((form) => form.copyWith(saving: true));

    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
      if (hive == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      final plan = TreatmentPlan(
        drug: drug,
        dose: form.dose.toDouble(),
        startedAt: _startedAt(form.startedOn),
        plannedRemovalAt: switch (form.removalOn) {
          final day? => _midday(day),
          null => null,
        },
        withdrawalDays: form.withdrawalDays,
        batchNo: form.batchNo,
      );
      final repository = ref.read(treatmentRepositoryProvider);
      return switch (form.scope) {
        TreatmentScope.hive => [await repository.addToHive(hive, plan)],
        TreatmentScope.apiary => await repository.addToApiary(
          hive.apiaryId,
          plan,
        ),
      };
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  /// Bugün başladıysa şimdi; başka günde öğlen (saat dilimi günü
  /// kaydırmasın).
  static DateTime _startedAt(DateTime day) {
    final now = clock.now();
    final sameDay =
        day.year == now.year && day.month == now.month && day.day == now.day;
    return sameDay ? now : _midday(day);
  }

  static DateTime _midday(DateTime day) =>
      DateTime(day.year, day.month, day.day, 12);

  void _update(TreatmentFormState Function(TreatmentFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
