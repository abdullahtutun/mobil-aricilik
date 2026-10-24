import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inspection_form_controller.freezed.dart';
part 'inspection_form_controller.g.dart';

@freezed
abstract class InspectionFormState with _$InspectionFormState {
  const factory({
    required Hive hive,
    required InspectionDraft draft,

    /// Kovanın önceki muayenesi; soluk değerler buradan gelir.
    Inspection? previous,
    @Default(false) bool saving,
  }) = _InspectionFormState;
}

extension InspectionFormProgress on InspectionFormState {
  /// Form önceki muayenenin bıraktığı hâlden farklı; taslak saklanıyor ve
  /// baştan başlanabilir.
  bool get hasChanges => draft != prefilledDraft(previous);

  bool get hasSuggestions => draft.suggested.isNotEmpty;
}

/// Kovanın hızlı muayene formu (teknik.md §9). Taslak varsa ondan, yoksa
/// önceki muayenenin değerleriyle (öneri olarak) açılır. Her değişiklik
/// hemen taslak olarak yerel DB'ye yazılır; uygulama kapansa da form
/// kaldığı yerden açılır. Sayfa açık kaldığı sürece yaşar. Kovan yoksa ya
/// da silindiyse durum null.
@riverpod
class InspectionFormController extends _$InspectionFormController {
  /// Kaydedildikten sonra gelen değişiklik taslağı yeniden yazmasın.
  var _saved = false;

  @override
  Future<InspectionFormState?> build(String hiveId) async {
    final hive = await ref.read(hiveRepositoryProvider).findById(hiveId);
    if (hive == null) return null;
    final previous = await ref
        .read(inspectionRepositoryProvider)
        .latestByHive(hiveId);
    final draft = await ref
        .read(inspectionDraftRepositoryProvider)
        .find(hiveId);
    return InspectionFormState(
      hive: hive,
      previous: previous,
      draft: draft ?? prefilledDraft(previous),
    );
  }

  void setQueenState(QueenState? value) => _change(
    InspectionField.queenState,
    (values) => values.copyWith(queenState: value),
  );

  void setBeeFrames(int value) => _change(
    InspectionField.beeFrames,
    (values) => values.copyWith(beeFrames: value),
  );

  void setBroodFrames(int value) => _change(
    InspectionField.broodFrames,
    (values) => values.copyWith(broodFrames: value),
  );

  void setHoneyFrames(int value) => _change(
    InspectionField.honeyFrames,
    (values) => values.copyWith(honeyFrames: value),
  );

  void setTemperament(Temperament? value) => _change(
    InspectionField.temperament,
    (values) => values.copyWith(temperament: value),
  );

  void setSwarmSigns({required bool? seen}) => _change(
    InspectionField.swarmSigns,
    (values) => values.copyWith(swarmSigns: seen),
  );

  void setQueenCells(QueenCells? value) => _change(
    InspectionField.queenCells,
    (values) => values.copyWith(queenCells: value),
  );

  void setDiseaseSuspected({required bool? suspected}) => _change(
    InspectionField.diseaseSuspected,
    (values) => values.copyWith(diseaseSuspected: suspected),
  );

  void setActions(Set<InspectionAction> actions) =>
      _change(null, (values) => values.copyWith(actions: actions));

  /// Taslağı siler; form önceki muayenenin değerleriyle yeniden başlar.
  void restart() {
    final form = state.value;
    if (form == null || form.saving || _saved) return;
    state = AsyncData(form.copyWith(draft: prefilledDraft(form.previous)));
    unawaited(ref.read(inspectionDraftRepositoryProvider).discard(hiveId));
  }

  /// Muayeneyi yerel DB'ye yazar (taslak silinir) ve döner. Kaydetme
  /// sürüyorsa null.
  Future<SavedInspection?> save() async {
    final form = state.value;
    if (form == null || form.saving || _saved) return null;
    _update((form) => form.copyWith(saving: true));

    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final inspection = await ref
          .read(inspectionRepositoryProvider)
          .add(
            orgId: form.hive.orgId,
            hiveId: hiveId,
            apiaryId: form.hive.apiaryId,
            values: form.draft.values,
          );
      _saved = true;
      return (inspection: inspection, draft: form.draft);
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  /// [field]'ı (işlemlerde null) değiştirir ve formu taslak olarak yazar.
  /// Yazmalar verildiği sırayla çalışır.
  void _change(
    InspectionField? field,
    InspectionValues Function(InspectionValues values) change,
  ) {
    final form = state.value;
    if (form == null || form.saving || _saved) return;
    final draft = form.draft.change(field, change(form.draft.values));
    state = AsyncData(form.copyWith(draft: draft));
    unawaited(
      ref
          .read(inspectionDraftRepositoryProvider)
          .save(orgId: form.hive.orgId, hiveId: hiveId, draft: draft),
    );
  }

  void _update(InspectionFormState Function(InspectionFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
