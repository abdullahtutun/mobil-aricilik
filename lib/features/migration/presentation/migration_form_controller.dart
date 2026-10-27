import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'migration_form_controller.freezed.dart';
part 'migration_form_controller.g.dart';

@freezed
abstract class MigrationFormState with _$MigrationFormState {
  const factory({
    required int year,
    @Default('') String name,
    @Default(false) bool saving,
  }) = _MigrationFormState;
}

extension MigrationFormProgress on MigrationFormState {
  bool get canSave => name.trim().isNotEmpty && !saving;
}

/// Göç planı ekleme ([migrationId] null) ve düzenleme formu: yıl ve ad.
/// Düzenlenecek plan yoksa ya da silinmişse durum null. Yeni planın yılı
/// bu yıl, adı [defaultName] (ekranın dilinde).
@riverpod
class MigrationFormController extends _$MigrationFormController {
  @override
  Future<MigrationFormState?> build(
    String? migrationId, {
    String defaultName = '',
  }) async {
    if (migrationId == null) {
      return MigrationFormState(year: clock.now().year, name: defaultName);
    }
    final migration = await ref
        .read(migrationRepositoryProvider)
        .findById(migrationId);
    return migration == null
        ? null
        : MigrationFormState(year: migration.year, name: migration.name);
  }

  void setYear(int year) => _update((form) => form.copyWith(year: year));

  void setName(String name) => _update((form) => form.copyWith(name: name));

  /// Planı yazar ve döner; kaydedilemiyorsa ya da düzenlenen plan bu arada
  /// silindiyse null.
  Future<Migration?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final repository = ref.read(migrationRepositoryProvider);
    final id = migrationId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      if (id == null) {
        return await repository.create(
          orgId: orgId,
          year: form.year,
          name: form.name,
        );
      }
      final latest = await repository.findById(id);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      return await repository.update(
        latest.copyWith(year: form.year, name: form.name),
      );
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(MigrationFormState Function(MigrationFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}
