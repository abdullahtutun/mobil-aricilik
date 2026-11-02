import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

// Sunucudaki bileşik yabancı anahtarlar ve etiket tekilliği yerelde yok:
// senkron satırları tablo tablo, sırasız indirir; yerel kısıt çekmeyi
// kırardı. Bu kuralları sunucu denetler.

/// `public.apiaries` aynası. Sunucudaki `location` noktası burada iki
/// kolon; ikisi birlikte dolu ya da birlikte boş.
@UseRowClass(Apiary, generateInsertable: true)
@TableIndex(name: 'apiaries_org_id_idx', columns: {#orgId})
class Apiaries extends Table with SyncColumns, OrgColumns {
  TextColumn get name => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  IntColumn get altitudeM => integer().nullable()();
  TextColumn get landownerName => text().nullable()();
  TextColumn get landownerPhone => text().nullable()();
  TextColumn get landTenure =>
      text().nullable().map(const ServerEnumConverter(LandTenure.values))();
  TextColumn get waterSource => text().nullable()();
  IntColumn get vehicleDistanceM => integer().nullable()();
  TextColumn get roadNotes => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK ((latitude IS NULL) = (longitude IS NULL))',
  ];
}

/// `public.queens` aynası.
@UseRowClass(Queen, generateInsertable: true)
@TableIndex(name: 'queens_org_id_idx', columns: {#orgId})
class Queens extends Table with SyncColumns, OrgColumns {
  IntColumn get year => integer().nullable()();

  /// Dart adları sunucu değerleriyle aynı.
  TextColumn get markColor => textEnum<QueenMarkColor>().nullable()();
  TextColumn get breed => text().nullable()();
  TextColumn get breedLine => text().nullable()();
  TextColumn get source =>
      text().nullable().map(const ServerEnumConverter(QueenSource.values))();
  TextColumn get matingStatus => text().nullable().map(
    const ServerEnumConverter(QueenMatingStatus.values),
  )();
  BoolColumn get wingClipped => boolean().withDefault(const Constant(false))();
  TextColumn get motherQueenId => text().nullable()();
}

/// `public.hives` aynası.
@UseRowClass(Hive, generateInsertable: true)
@TableIndex(name: 'hives_org_id_idx', columns: {#orgId})
@TableIndex(name: 'hives_apiary_id_idx', columns: {#apiaryId})
class Hives extends Table with SyncColumns, OrgColumns {
  TextColumn get number => text()();
  TextColumn get tagCode => text().nullable()();
  TextColumn get type =>
      text().map(const ServerEnumConverter(HiveType.values))();
  TextColumn get status =>
      text().map(const ServerEnumConverter(HiveStatus.values))();
  TextColumn get apiaryId => text()();
  TextColumn get queenId => text().nullable()();
  IntColumn get boxCount => integer().withDefault(const Constant(1))();
  IntColumn get frameCount => integer().nullable()();
  TextColumn get source =>
      text().nullable().map(const ServerEnumConverter(HiveSource.values))();
  TextColumn get marking => text().nullable()();
  BoolColumn get quarantined => boolean().withDefault(const Constant(false))();
  DateTimeColumn get quarantinedAt => dateTime().nullable()();
  TextColumn get quarantineDisease => text().nullable()();
}

/// `public.hive_location_history` aynası; olay tablosu.
@UseRowClass(HiveLocationEntry, generateInsertable: true)
@TableIndex(name: 'hive_location_history_org_id_idx', columns: {#orgId})
@TableIndex(name: 'hive_location_history_hive_id_idx', columns: {#hiveId})
class HiveLocationHistory extends Table with SyncColumns, OrgColumns {
  TextColumn get hiveId => text()();
  TextColumn get apiaryId => text()();
  DateTimeColumn get movedAt => dateTime()();
}

/// `public.hive_status_events` aynası; olay tablosu.
@UseRowClass(HiveStatusEvent, generateInsertable: true)
@TableIndex(name: 'hive_status_events_org_id_idx', columns: {#orgId})
@TableIndex(name: 'hive_status_events_hive_id_idx', columns: {#hiveId})
class HiveStatusEvents extends Table with SyncColumns, OrgColumns {
  TextColumn get hiveId => text()();
  TextColumn get apiaryId => text()();
  TextColumn get fromStatus =>
      text().map(const ServerEnumConverter(HiveStatus.values))();
  TextColumn get toStatus =>
      text().map(const ServerEnumConverter(HiveStatus.values))();
  DateTimeColumn get changedAt => dateTime()();
  TextColumn get lossReason =>
      text().nullable().map(const ServerEnumConverter(HiveLossReason.values))();
}
