import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/services/logo_file_store_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'business_profile_form_controller.freezed.dart';
part 'business_profile_form_controller.g.dart';

/// Profil formunun düzenlenebilir alanları. Sayılar, ilk kayıt tarihi, rol,
/// e-posta ve ülke formda yok.
@freezed
abstract class BusinessProfileFields with _$BusinessProfileFields {
  const factory({
    @Default('') String name,
    OrgAvatarColor? avatarColor,

    /// Logonun Storage yolu; yeni seçilen logo da bu yolla yazılır.
    String? logoPath,
    @Default(OperationType.migratory) OperationType operationType,
    @Default('') String currency,
  }) = _BusinessProfileFields;
}

@freezed
abstract class BusinessProfileFormState with _$BusinessProfileFormState {
  const factory({
    /// Formun açıldığı andaki hâli; çıkışta "değişiklikleri at?" buna göre.
    required BusinessProfileFields initial,
    required BusinessProfileFields fields,
    @Default(false) bool saving,
  }) = _BusinessProfileFormState;
}

extension BusinessProfileFormProgress on BusinessProfileFormState {
  bool get dirty => fields != initial;

  bool get canSave => !saving && fields.name.trim().isNotEmpty;

  /// Para birimi değişti: "geçmiş kayıtlar dönüştürülmez" notu görünür.
  bool get currencyChanged => fields.currency != initial.currency;

  /// Gezginciden sabite: kaydetmeden önce gizlenecek kayıtlar sorulur.
  bool get needsTypeConfirmation => operationTypeChangeNeedsConfirmation(
    initial.operationType,
    fields.operationType,
  );
}

/// İşletme profil formu (`/more/business/edit`). Ekran açık kaldığı sürece
/// yaşar. Her şey yerel DB'ye ve outbox'a yazılır, ağ beklenmez; seçilen
/// logo dosyası kaydedilince yükleme kuyruğuna girer, kaydedilmeden kapanan
/// formun seçtiği dosya silinir.
@riverpod
class BusinessProfileFormController extends _$BusinessProfileFormController {
  var _saved = false;

  /// Seçilen logonun dosya adı; kapanırken `state` okunamadığı için ayrıca.
  String? _picked;

  @override
  BusinessProfileFormState build() {
    final files = ref.read(logoFileStoreProvider);
    ref.onDispose(() {
      if (_picked case final fileName? when !_saved) {
        unawaited(files.delete(fileName));
      }
    });
    final profile = ref.read(businessProfileProvider);
    final fields = BusinessProfileFields(
      name: profile?.name ?? '',
      avatarColor: profile?.avatarColor,
      logoPath: profile?.logoPath,
      operationType: profile?.operationType ?? OperationType.migratory,
      currency: profile?.currency ?? '',
    );
    return BusinessProfileFormState(initial: fields, fields: fields);
  }

  void _set(BusinessProfileFields fields) =>
      state = state.copyWith(fields: fields);

  void setName(String name) => _set(state.fields.copyWith(name: name));

  /// Renk seçmek logoyu kaldırır: baş harfler bu renkte görünür.
  void setAvatarColor(OrgAvatarColor color) =>
      _set(state.fields.copyWith(avatarColor: color, logoPath: null));

  void setOperationType(OperationType type) =>
      _set(state.fields.copyWith(operationType: type));

  void setCurrency(String currency) =>
      _set(state.fields.copyWith(currency: currency));

  /// Logoyu kaldırır; baş harfler avatar renginde görünür.
  void removeLogo() => _set(state.fields.copyWith(logoPath: null));

  /// Galeriden logo seçtirir; vazgeçilirse bir şey değişmez. Hata
  /// `MediaCaptureException`.
  Future<void> pickLogo() async {
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    final files = ref.read(logoFileStoreProvider);
    final storagePath = logoStoragePath(orgId: orgId, id: generateId());
    final fileName = logoFileName(storagePath);
    final byteSize = await ref
        .read(cameraServiceProvider)
        .pickImage(await files.pathOf(fileName));
    if (byteSize == null) return;
    if (!ref.mounted) {
      await files.delete(fileName);
      return;
    }
    final previous = _picked;
    _picked = fileName;
    _set(state.fields.copyWith(logoPath: storagePath));
    if (previous != null) await files.delete(previous);
    ref.invalidate(organizationLogoFileProvider(storagePath));
  }

  /// Sabite geçerken gizlenecek göç planı ve durak sayısı (onay için).
  Future<MigratoryRecordCounts> migratoryRecordCounts() {
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return Future.value((plans: 0, stops: 0));
    return ref
        .read(organizationRepositoryProvider)
        .countMigratoryRecords(orgId);
  }

  /// İşletme alanlarını yazar; yazıldıysa true.
  /// Kendi rolü burada değişmez (Ekip ekranından yönetilir).
  Future<bool> save() async {
    final form = state;
    final orgId = ref.read(currentOrgIdProvider);
    if (!form.canSave || orgId == null) return false;
    state = form.copyWith(saving: true);
    try {
      final fields = form.fields;
      final written = await ref
          .read(organizationRepositoryProvider)
          .updateProfile(orgId, (
            name: fields.name,
            avatarColor: fields.avatarColor,
            logoPath: fields.logoPath,
            operationType: fields.operationType,
            currency: fields.currency,
          ));
      if (!written) return false;
      _saved = true;
      return true;
    } finally {
      if (ref.mounted) state = state.copyWith(saving: false);
    }
  }
}
