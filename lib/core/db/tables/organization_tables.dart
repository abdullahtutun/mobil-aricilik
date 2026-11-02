import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
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
}

/// `public.memberships` aynası.
@DataClassName('MembershipRow')
@TableIndex(name: 'memberships_org_id_idx', columns: {#orgId})
class Memberships extends Table with SyncColumns, OrgColumns {
  TextColumn get userId => text()();
  TextColumn get role =>
      text().map(const ServerEnumConverter(MembershipRole.values))();
}
