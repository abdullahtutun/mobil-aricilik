import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

/// Cihazda üretilen PDF raporları.
enum ReportKind {
  /// İlaç kayıt defteri: dönemdeki ilaç uygulamaları; denetim için.
  treatmentRegister,

  /// Kovan geçmişi: tek kovanın ya da arılıktaki kovanların kayıtları.
  hiveHistory,
}

/// Raporun dönemi: yerel takvimde `from` gününün başından `to` gününün
/// sonuna; iki gün de dahil.
typedef ReportPeriod = ({DateTime from, DateTime to});

/// İşletmenin TR kayıt numaraları (`organizations`); girilmemişse boş.
final class OrganizationRegistration {
  const new({this.registrationNo, this.aksNo});

  /// İşletme tescil no.
  final String? registrationNo;
  final String? aksNo;
}

/// İlaç kayıt defterinin bir satırı: aynı anda yazılan uygulama grubu
/// (toplu uygulamada arılıktaki bütün kovanlar tek satır).
final class TreatmentRegisterEntry {
  const new({
    required this.treatment,
    required this.hiveCount,
    required this.hiveNumbers,
  });

  /// Grubun bir kaydı; ürün, doz, tarih ve bekleme grupta ortak.
  final Treatment treatment;

  /// Gruptaki uygulama (kovan) sayısı.
  final int hiveCount;

  /// Gruptaki kovanların numaraları, doğal sırayla. Kovanı bu telefonda
  /// olmayan uygulama yazılmaz; [hiveCount]'tan az olabilir.
  final List<String> hiveNumbers;

  /// Bal katı ve hasatın serbest kaldığı gün.
  DateTime get withdrawalEnd => treatmentWithdrawalEnd(treatment);
}

/// Raporun PDF'e basılacak verisi.
sealed class ReportData {
  const new({required this.apiaryNames});

  /// Arılık kimliğinden adı; silinmiş arılıklar da var.
  final Map<String, String> apiaryNames;

  /// Basılacak kayıt yok.
  bool get isEmpty;
}

/// İlaç kayıt defterinin verisi.
final class TreatmentRegister extends ReportData {
  const new({required this.entries, required super.apiaryNames});

  final List<TreatmentRegisterEntry> entries;

  @override
  bool get isEmpty => entries.isEmpty;
}

/// Kovan geçmişindeki bir kayıt.
sealed class HiveHistoryItem {
  const new();

  /// Kaydın kimliği (UUIDv7); aynı andaki kayıtların sırası.
  String get id;

  /// Kaydın zamanı, UTC.
  DateTime get at;
}

final class InspectionItem extends HiveHistoryItem {
  const new(this.inspection);

  final Inspection inspection;

  @override
  String get id => inspection.id;

  @override
  DateTime get at => inspection.inspectedAt;
}

final class TreatmentItem extends HiveHistoryItem {
  const new(this.treatment);

  final Treatment treatment;

  @override
  String get id => treatment.id;

  @override
  DateTime get at => treatment.startedAt;
}

final class FeedingItem extends HiveHistoryItem {
  const new(this.feeding);

  final Feeding feeding;

  @override
  String get id => feeding.id;

  @override
  DateTime get at => feeding.fedAt;
}

final class MiteCountItem extends HiveHistoryItem {
  const new(this.count);

  final MiteCount count;

  @override
  String get id => count.id;

  @override
  DateTime get at => count.countedAt;
}

/// Kovanın alındığı hasat; kat ve bal hasadın tümünündür.
final class HarvestItem extends HiveHistoryItem {
  const new(this.harvest);

  final Harvest harvest;

  @override
  String get id => harvest.id;

  @override
  DateTime get at => harvest.harvestedAt;
}

/// Kovan [entry]'deki arılığa geldi; [fromApiaryId] boşsa oraya eklendi.
final class LocationItem extends HiveHistoryItem {
  const new(this.entry, {this.fromApiaryId});

  final HiveLocationEntry entry;
  final String? fromApiaryId;

  @override
  String get id => entry.id;

  @override
  DateTime get at => entry.movedAt;
}

/// Kovanın bu telefondaki bütün kayıtları; döneme göre süzülmemiş.
typedef HiveRecords = ({
  List<Inspection> inspections,
  List<Treatment> treatments,
  List<Feeding> feedings,
  List<MiteCount> miteCounts,
  List<Harvest> harvests,
  List<HiveLocationEntry> locations,
});

/// Bir kovanın dönemdeki geçmişi, en yeni önce.
typedef HiveHistory = ({Hive hive, List<HiveHistoryItem> items});

/// Kovan geçmişi raporunun verisi. Tek kovan seçildiyse dönemde kaydı
/// olmasa da yer alır; arılıkta yalnız kaydı olan kovanlar.
final class HiveHistoryReport extends ReportData {
  const new({required this.hives, required super.apiaryNames});

  final List<HiveHistory> hives;

  int get itemCount => hives.fold(0, (sum, hive) => sum + hive.items.length);

  @override
  bool get isEmpty => itemCount == 0;
}
