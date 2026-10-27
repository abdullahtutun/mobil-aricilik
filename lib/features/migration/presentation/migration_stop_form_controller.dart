import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'migration_stop_form_controller.freezed.dart';
part 'migration_stop_form_controller.g.dart';

/// Yeni durağın planlanan konaklaması: başlangıçtan bu kadar gün sonra
/// biter.
const defaultStopDays = 60;

@freezed
abstract class MigrationStopFormState with _$MigrationStopFormState {
  const factory({
    required int position,
    required DateTime plannedStartOn,
    required DateTime plannedEndOn,
    @Default('') String name,
    @Default('') String place,
    String? apiaryId,
    int? hiveCount,
    @Default(MigrationStopStatus.planned) MigrationStopStatus status,
    @Default(false) bool saving,
  }) = _MigrationStopFormState;

  factory fromStop(MigrationStop stop) => MigrationStopFormState(
    position: stop.position,
    plannedStartOn: stop.plannedStartOn,
    plannedEndOn: stop.plannedEndOn,
    name: stop.name,
    place: stop.place ?? '',
    apiaryId: stop.apiaryId,
    hiveCount: stop.hiveCount,
    status: stop.status,
  );
}

extension MigrationStopFormProgress on MigrationStopFormState {
  bool get canSave => name.trim().isNotEmpty && !saving;

  MigrationStopPlan get plan => (
    position: position,
    name: name,
    place: place,
    plannedStartOn: plannedStartOn,
    plannedEndOn: plannedEndOn,
    apiaryId: apiaryId,
    hiveCount: hiveCount,
    status: status,
  );
}

/// Durak ekleme ([stopId] null) ve düzenleme formu. Yeni durak planın
/// sonuna eklenir, planlı başlar ve bugünden [defaultStopDays] gün sürer.
/// Düzenlenecek durak yoksa ya da silinmişse durum null.
@riverpod
class MigrationStopFormController extends _$MigrationStopFormController {
  @override
  Future<MigrationStopFormState?> build(
    String migrationId,
    String? stopId,
  ) async {
    final stops = ref.read(migrationRepositoryProvider).stops;
    if (stopId == null) {
      final today = dateOnly(clock.now());
      return MigrationStopFormState(
        position: await stops.nextPosition(migrationId),
        plannedStartOn: today,
        plannedEndOn: today.add(const Duration(days: defaultStopDays)),
      );
    }
    final stop = await stops.findById(stopId);
    return stop == null ? null : MigrationStopFormState.fromStop(stop);
  }

  void setName(String name) => _update((form) => form.copyWith(name: name));

  void setPlace(String place) => _update((form) => form.copyWith(place: place));

  void setPosition(int position) =>
      _update((form) => form.copyWith(position: position));

  /// Başlangıcı değiştirir; bitiş başlangıçtan önce kalırsa ona çekilir.
  void setStart(DateTime day) => _update((form) {
    final start = dateOnly(day);
    return form.copyWith(
      plannedStartOn: start,
      plannedEndOn: form.plannedEndOn.isBefore(start)
          ? start
          : form.plannedEndOn,
    );
  });

  /// Bitişi değiştirir; başlangıç bitişten sonra kalırsa ona çekilir.
  void setEnd(DateTime day) => _update((form) {
    final end = dateOnly(day);
    return form.copyWith(
      plannedEndOn: end,
      plannedStartOn: form.plannedStartOn.isAfter(end)
          ? end
          : form.plannedStartOn,
    );
  });

  void setApiary(String? apiaryId) =>
      _update((form) => form.copyWith(apiaryId: apiaryId));

  void setHiveCount(int? count) =>
      _update((form) => form.copyWith(hiveCount: count));

  void setStatus(MigrationStopStatus status) =>
      _update((form) => form.copyWith(status: status));

  /// Durağı yazar ve döner; kaydedilemiyorsa ya da düzenlenen durak bu
  /// arada silindiyse null.
  Future<MigrationStop?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final stops = ref.read(migrationRepositoryProvider).stops;
    final id = stopId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      if (id == null) {
        return await stops.create(
          orgId: orgId,
          migrationId: migrationId,
          plan: form.plan,
        );
      }
      final latest = await stops.findById(id);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      return await stops.update(latest, form.plan);
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(
    MigrationStopFormState Function(MigrationStopFormState form) change,
  ) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
