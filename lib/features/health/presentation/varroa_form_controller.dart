import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/varroa_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'varroa_form_controller.freezed.dart';
part 'varroa_form_controller.g.dart';

@freezed
abstract class VarroaFormState with _$VarroaFormState {
  const factory({
    required Hive hive,
    @Default(MiteCountMethod.sugarRoll) MiteCountMethod method,
    @Default(defaultSampleBees) int sampleBees,
    @Default(defaultBoardDays) int days,

    /// Sayılan akar; girilene kadar boş ve Kaydet kapalı. Yanlışlıkla
    /// "0 akar" kaydedilmesin.
    int? mites,
    @Default(false) bool saving,
  }) = _VarroaFormState;
}

extension VarroaFormResult on VarroaFormState {
  /// Formdaki değerlerin sonucu; akar girilmemişse null.
  MiteLoad? get load => switch (mites) {
    final mites? => miteLoad(
      method,
      mites: mites,
      sampleBees: sampleBees,
      days: days,
    ),
    null => null,
  };

  bool get canSave => mites != null && !saving;
}

/// Kovanın varroa ölçümü formu. Ekran açık kaldığı sürece yaşar. Kovan
/// yoksa durum null. Ölçüm yerel DB'ye yazılır.
@riverpod
class VarroaFormController extends _$VarroaFormController {
  @override
  Future<VarroaFormState?> build(String hiveId) async {
    final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
    return hive == null ? null : VarroaFormState(hive: hive);
  }

  void selectMethod(MiteCountMethod method) =>
      _update((form) => form.copyWith(method: method));

  void setSampleBees(int sampleBees) =>
      _update((form) => form.copyWith(sampleBees: sampleBees));

  void setDays(int days) => _update((form) => form.copyWith(days: days));

  void setMites(int mites) => _update((form) => form.copyWith(mites: mites));

  /// Ölçümü kovanın şimdiki arılığında yazar ve döner; akar girilmemişse
  /// ya da kovan bu arada silindiyse null.
  Future<MiteCount?> save() async {
    final form = state.value;
    final mites = form?.mites;
    if (form == null || mites == null || form.saving) return null;
    _update((form) => form.copyWith(saving: true));

    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
      if (hive == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      return await ref
          .read(miteCountRepositoryProvider)
          .add(
            orgId: hive.orgId,
            hiveId: hive.id,
            apiaryId: hive.apiaryId,
            method: form.method,
            mites: mites,
            sampleBees: form.sampleBees,
            days: form.days,
          );
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(VarroaFormState Function(VarroaFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
