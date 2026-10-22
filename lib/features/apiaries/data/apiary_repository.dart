import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';

/// Arılıklar; durum kaydı, son yazan kazanır.
class ApiaryRepository extends BaseRepository<$ApiariesTable, Apiary> {
  new(super.db, {super.clock});

  @override
  $ApiariesTable get table => db.apiaries;

  @override
  Insertable<Apiary> toInsertable(Apiary record) => record.toInsertable();

  /// İşletmenin arılıkları, ada göre.
  Stream<List<Apiary>> watchAll(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [(t) => OrderingTerm.asc(t.name)],
  );

  /// [latitude] ve [longitude] birlikte verilir ya da ikisi de boş kalır.
  Future<Apiary> create({
    required String orgId,
    required String name,
    double? latitude,
    double? longitude,
    int? altitudeM,
    String? landownerName,
    String? landownerPhone,
    LandTenure? landTenure,
    String? waterSource,
    int? vehicleDistanceM,
    String? roadNotes,
    String? notes,
  }) {
    final at = now();
    return insertRecord(
      Apiary(
        id: generateId(),
        orgId: orgId,
        name: name,
        latitude: latitude,
        longitude: longitude,
        altitudeM: altitudeM,
        landownerName: landownerName,
        landownerPhone: landownerPhone,
        landTenure: landTenure,
        waterSource: waterSource,
        vehicleDistanceM: vehicleDistanceM,
        roadNotes: roadNotes,
        notes: notes,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }

  /// Arılığın alanlarını yazar.
  Future<Apiary> update(Apiary apiary) => updateRecord(apiary);
}
