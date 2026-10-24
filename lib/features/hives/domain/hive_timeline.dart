import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';

/// Kovan kartının zaman tünelindeki bir olay.
///
/// Her kayıt türü (muayene, taşıma, medya; ileride besleme, ilaçlama,
/// hasat) bir alt sınıf ekler ve kendi kayıtlarını olaya çeviren bir
/// fonksiyon verir. Tünel hepsini [sortTimeline] ile tek listede sıralar.
/// Sınıf kapalı (`sealed`); kart olayları `switch` ile çizdiği için yeni
/// bir tür eklenince derleyici çizilmeyen türü gösterir.
sealed class HiveTimelineEvent {
  const new();

  /// Kaydın kimliği (UUIDv7); liste anahtarı ve aynı andaki olayların
  /// sırası.
  String get id;

  /// Olayın zamanı, UTC; tünel buna göre sıralanır.
  DateTime get at;
}

/// Muayene; sırasında çekilen foto ve sesli notlarla.
final class InspectionEvent extends HiveTimelineEvent {
  const new(this.inspection, {this.media = const []});

  final Inspection inspection;

  /// Çekilme sırasıyla.
  final List<MediaItem> media;

  @override
  String get id => inspection.id;

  @override
  DateTime get at => inspection.inspectedAt;
}

/// Kovan [entry]'deki arılığa geldi. [fromApiaryId] bir önceki arılık;
/// null ise bu kovanın ilk arılığı (kovan oraya eklendi).
final class LocationEvent extends HiveTimelineEvent {
  const new(this.entry, {this.fromApiaryId});

  final HiveLocationEntry entry;
  final String? fromApiaryId;

  String get toApiaryId => entry.apiaryId;

  @override
  String get id => entry.id;

  @override
  DateTime get at => entry.movedAt;
}

/// Kovan kartından eklenen foto ya da sesli not; muayeneye bağlı değil.
final class MediaEvent extends HiveTimelineEvent {
  const new(this.media);

  final MediaItem media;

  @override
  String get id => media.id;

  @override
  DateTime get at => media.capturedAt;
}

/// Muayeneleri olaylara çevirir; [media]'dan her muayenenin kendi
/// medyasını (verildiği sırayla) yanına koyar.
List<InspectionEvent> inspectionEvents(
  Iterable<Inspection> inspections, {
  Iterable<MediaItem> media = const [],
}) {
  final byInspection = <String, List<MediaItem>>{};
  for (final item in media) {
    if (item.inspectionId case final id?) {
      (byInspection[id] ??= []).add(item);
    }
  }
  return [
    for (final inspection in inspections)
      InspectionEvent(
        inspection,
        media: byInspection[inspection.id] ?? const [],
      ),
  ];
}

/// Muayenenin yanında gösterilmeyen medya kendi olayı olur: kovan
/// kartından eklenenler ve muayenesi bu telefonda olmayanlar (silinmiş ya
/// da henüz inmemiş). [inspectionIds] tünelde gösterilen muayeneler.
List<MediaEvent> mediaEvents(
  Iterable<MediaItem> media, {
  Set<String> inspectionIds = const {},
}) => [
  for (final item in media)
    if (!inspectionIds.contains(item.inspectionId)) MediaEvent(item),
];

/// Kovanın arılık geçmişini olaylara çevirir. Her kaydın geldiği arılık,
/// zamanca bir önceki kaydınkidir; ilk kayıt kovanın eklendiği arılıktır.
/// [entries] herhangi bir sırada olabilir.
List<LocationEvent> locationEvents(Iterable<HiveLocationEntry> entries) {
  final ordered = [...entries]..sort(_oldestFirst);
  return [
    for (final (i, entry) in ordered.indexed)
      LocationEvent(
        entry,
        fromApiaryId: i == 0 ? null : ordered[i - 1].apiaryId,
      ),
  ];
}

/// Tünelin sırası: en yeni önce; aynı andaki olaylardan kimliği büyük
/// (sonra yazılan) önce.
List<HiveTimelineEvent> sortTimeline(Iterable<HiveTimelineEvent> events) =>
    [...events]..sort((a, b) => _byTime(b.at, b.id, a.at, a.id));

int _oldestFirst(HiveLocationEntry a, HiveLocationEntry b) =>
    _byTime(a.movedAt, a.id, b.movedAt, b.id);

int _byTime(DateTime a, String aId, DateTime b, String bId) {
  final byTime = a.compareTo(b);
  return byTime != 0 ? byTime : aId.compareTo(bId);
}
