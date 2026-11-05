import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/media_tables.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';

// İşletme `create_organization` RPC'siyle, üyelik owner tarafından sunucuda
// açılır; bu tablolara yalnız senkron yazar. Satır sınıfları Drift'in
// ürettiği sınıflar, freezed model senkron adımında bağlanacak.

/// `public.organizations` aynası.
@DataClassName('OrganizationRow')
class Organizations extends Table with SyncColumns {
  TextColumn get name => text()();

  /// ISO 3166-1 alpha-2, büyük harf.
  TextColumn get countryCode => text()();

  /// ISO 4217.
  TextColumn get currency => text()();

  /// Yalnız TR profilinde: işletme tescil no ve AKS no.
  TextColumn get trRegistrationNo => text().nullable()();
  TextColumn get trAksNo => text().nullable()();
  TextColumn get hiveCountRange =>
      text().nullable().map(const ServerEnumConverter(HiveCountRange.values))();

  /// AKS'de beyan edilen kovan sayısı; başvuru öncesi kontrol bunu aktif
  /// kovan sayısıyla karşılaştırır. Owner girer.
  IntColumn get trAksHiveCount => integer().nullable()();

  /// Gezginci ya da sabit; sabitte gezginci modülleri gizlenir.
  TextColumn get operationType => text()
      .map(const ServerEnumConverter(OperationType.values))
      .withDefault(Constant(OperationType.migratory.value))();
  TextColumn get avatarColor =>
      text().nullable().map(const ServerEnumConverter(OrgAvatarColor.values))();

  /// `org-logos` bucket'ındaki yol (`org_id/uuid.jpg`); logo yoksa boş.
  TextColumn get logoPath => text().nullable()();
}

/// `public.memberships` aynası.
@DataClassName('MembershipRow')
@TableIndex(name: 'memberships_org_id_idx', columns: {#orgId})
class Memberships extends Table with SyncColumns, OrgColumns {
  TextColumn get userId => text()();
  TextColumn get role =>
      text().map(const ServerEnumConverter(MembershipRole.values))();

  /// Üyenin adı soyadı; yalnız üyenin kendisi yazar.
  TextColumn get fullName => text().nullable()();

  /// Üye hesabını silmeyi onayladıysa kalıcı silme zamanı; vazgeçerse
  /// boşalır. Yalnız sunucu yazar. Doluyken rolü değiştirilmez, ekipten
  /// çıkarılmaz.
  DateTimeColumn get deletionScheduledFor => dateTime().nullable()();
}

/// İşletme logosunun yükleme kuyruğu; yalnız bu telefonda. Dosya
/// `logos/` klasöründe, adı Storage yolunun son parçası.
class LogoUploads extends Table {
  TextColumn get storagePath => text()();
  TextColumn get orgId => text()();
  TextColumn get uploadStatus => textEnum<MediaUploadStatus>()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Boşsa hemen denenir.
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {storagePath};
}
