import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/services/location_service.dart';
import 'package:mobil_arici/core/services/location_service_provider.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apiary_form_controller.freezed.dart';
part 'apiary_form_controller.g.dart';

@freezed
abstract class ApiaryFormState with _$ApiaryFormState {
  const factory({
    @Default('') String name,
    double? latitude,
    double? longitude,

    /// Bu formda GPS'ten alınan konumun doğruluğu (m); kayıtlı konumda
    /// bilinmez.
    double? accuracyM,
    @Default('') String notes,

    /// GPS'ten konum bekleniyor.
    @Default(false) bool locating,
    LocationFailure? locationFailure,
    @Default(false) bool saving,
  }) = _ApiaryFormState;

  factory fromApiary(Apiary apiary) => ApiaryFormState(
    name: apiary.name,
    latitude: apiary.latitude,
    longitude: apiary.longitude,
    notes: apiary.notes ?? '',
  );
}

extension ApiaryFormProgress on ApiaryFormState {
  bool get hasLocation => latitude != null && longitude != null;

  /// Ad yazıldı; konum beklenirken kaydedilmez, yoksa gelen konum kaybolurdu.
  bool get canSave => name.trim().isNotEmpty && !locating && !saving;
}

/// Arılık ekleme ([apiaryId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek arılık yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır; konum GPS'ten gelir, ağ gerekmez.
@riverpod
class ApiaryFormController extends _$ApiaryFormController {
  /// Son konum isteğinin sırası; vazgeçilen ya da eskiyen isteğin sonucu
  /// yok sayılır.
  int _locateRequest = 0;

  @override
  Future<ApiaryFormState?> build(String? apiaryId) async {
    if (apiaryId == null) return const ApiaryFormState();
    final apiary = await ref.read(apiaryRepositoryProvider).findById(apiaryId);
    return apiary == null ? null : ApiaryFormState.fromApiary(apiary);
  }

  void updateName(String name) => _update((form) => form.copyWith(name: name));

  void updateNotes(String value) =>
      _update((form) => form.copyWith(notes: value));

  /// Konumu GPS'ten alır; izin sorulmadıysa sorar. Hata formda gösterilir.
  Future<void> locate() async {
    if (state.value case null || ApiaryFormState(locating: true)) return;
    final request = ++_locateRequest;
    _update((form) => form.copyWith(locating: true, locationFailure: null));
    try {
      final fix = await ref.read(locationServiceProvider).currentFix();
      if (!ref.mounted || request != _locateRequest) return;
      _update(
        (form) => form.copyWith(
          locating: false,
          latitude: fix.latitude,
          longitude: fix.longitude,
          accuracyM: fix.accuracyM,
        ),
      );
    } on LocationServiceException catch (error) {
      if (!ref.mounted || request != _locateRequest) return;
      _update(
        (form) =>
            form.copyWith(locating: false, locationFailure: error.failure),
      );
    }
  }

  /// Konum beklemeyi bırakır; önceki konum (varsa) kalır.
  void cancelLocate() {
    _locateRequest++;
    _update((form) => form.copyWith(locating: false));
  }

  /// Haritada seçilen noktayı konum yapar; bekleyen GPS isteği bırakılır.
  /// Doğruluk bilinmez.
  void setPickedLocation(double latitude, double longitude) {
    _locateRequest++;
    _update(
      (form) => form.copyWith(
        locating: false,
        latitude: latitude,
        longitude: longitude,
        accuracyM: null,
        locationFailure: null,
      ),
    );
  }

  void clearLocation() => _update(
    (form) => form.copyWith(
      latitude: null,
      longitude: null,
      accuracyM: null,
      locationFailure: null,
    ),
  );

  /// Konum hatasını çözecek cihaz ayarını açar (konum servisi ya da izin).
  Future<void> openLocationSettings() async {
    final failure = state.value?.locationFailure;
    if (failure == null) return;
    await ref.read(locationServiceProvider).openSettings(failure);
  }

  /// Arılığı yerel DB'ye yazar ve kimliğini döner. Kaydedilemiyorsa
  /// ([ApiaryFormProgress.canSave]) null döner. Düzenlenen arılık bu arada
  /// silindiyse durum null olur.
  Future<String?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final repository = ref.read(apiaryRepositoryProvider);
    final id = apiaryId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      final Apiary saved;
      if (id == null) {
        saved = await repository.create(
          orgId: orgId,
          name: form.name.trim(),
          latitude: form.latitude,
          longitude: form.longitude,
          notes: _orNull(form.notes),
        );
      } else {
        // Formda olmayan alanlar (ör. senkronla gelen su kaynağı) en son
        // hâlinden alınır.
        final latest = await repository.findById(id);
        if (latest == null) {
          if (ref.mounted) state = const AsyncData(null);
          return null;
        }
        saved = await repository.update(
          latest.copyWith(
            name: form.name.trim(),
            latitude: form.latitude,
            longitude: form.longitude,
            notes: _orNull(form.notes),
          ),
        );
      }
      return saved.id;
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(ApiaryFormState Function(ApiaryFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }

  static String? _orNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
