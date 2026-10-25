import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

/// Formdaki kovan başına miktarın üst sınırı, kullanıcının biriminde.
/// Galonda da sunucunun 100 L sınırının altında kalır.
const maxFeedingAmount = 20;

/// Kayıttaki kovan başına miktarın üst sınırı (L ya da kg); sunucunun
/// CHECK'i.
const maxStoredFeedingAmount = 100;

/// Şurubun 20 °C'deki yoğunluğu (kg/L): şeker çözeltisi tablosundan, 1:1
/// ağırlıkça %50, 2:1 %66,7 şeker.
const Map<FeedingKind, double> _syrupDensity = {
  FeedingKind.syrup1to1: 1.23,
  FeedingKind.syrup2to1: 1.33,
};

/// Ağırlıkça şeker / su oranı.
const Map<FeedingKind, int> _sugarPerWater = {
  FeedingKind.syrup1to1: 1,
  FeedingKind.syrup2to1: 2,
};

/// Hazırlanacak şurubun şekeri (kg) ve suyu (L).
typedef SyrupRecipe = ({double sugarKg, double waterLiters});

/// [syrupLiters] litre [kind] şurubu için gereken şeker ve su. Şurubun
/// kütlesi yoğunluktan; şeker ve su bu kütleyi ağırlıkça orana göre
/// paylaşır, suyun 1 kg'ı 1 L sayılır. Şurup değilse null.
SyrupRecipe? syrupRecipe(FeedingKind kind, double syrupLiters) {
  final density = _syrupDensity[kind];
  final ratio = _sugarPerWater[kind];
  if (density == null || ratio == null) return null;
  final mass = syrupLiters * density;
  return (sugarKg: mass * ratio / (ratio + 1), waterLiters: mass / (ratio + 1));
}

/// Formdaki [value] (kullanıcının biriminde, [units]'e göre) kayıttaki
/// birime çevrilir: şurupta litre, değilse kilogram. Sunucu üç ondalık
/// tutar.
double storedFeedingAmount(FeedingKind kind, int value, DefaultUnits units) {
  final converted = kind.isSyrup
      ? units.volume.convert(value.toDouble(), to: VolumeUnit.liter)
      : units.mass.convert(value.toDouble(), to: MassUnit.kilogram);
  return (converted * 1000).round() / 1000;
}

/// Kovanın son bal katı işlemine göre üstünde bal katı var mı: silinmemiş
/// muayenelerden "Kat verildi" ya da "Kat alındı" içeren en sonuncusu
/// (aynı anda yapılanlardan kimliği büyük olan) "Kat verildi"yse var. İkisi
/// aynı muayenedeyse kat değiştirilmiş sayılır, var. Hiç yoksa yok.
bool hasHoneySuper(Iterable<Inspection> inspections) {
  Inspection? latest;
  for (final inspection in inspections) {
    if (inspection.deletedAt != null) continue;
    final actions = inspection.actions;
    if (!actions.contains(InspectionAction.superAdded) &&
        !actions.contains(InspectionAction.superRemoved)) {
      continue;
    }
    if (latest == null || _isLater(inspection, latest)) latest = inspection;
  }
  return latest?.actions.contains(InspectionAction.superAdded) ?? false;
}

bool _isLater(Inspection a, Inspection b) {
  final byTime = a.inspectedAt.compareTo(b.inspectedAt);
  return byTime > 0 || (byTime == 0 && a.id.compareTo(b.id) > 0);
}

/// [inspections] içinden şu an bal katı olan kovanların kimlikleri
/// ([hasHoneySuper] kovan kovan).
Set<String> honeySuperHiveIds(Iterable<Inspection> inspections) {
  final byHive = <String, List<Inspection>>{};
  for (final inspection in inspections) {
    (byHive[inspection.hiveId] ??= []).add(inspection);
  }
  return {
    for (final MapEntry(key: hiveId, value: rows) in byHive.entries)
      if (hasHoneySuper(rows)) hiveId,
  };
}

/// Beslemenin yazılacağı ve dışarıda kalan kovanlar.
typedef FeedingTargets = ({List<Hive> fed, List<Hive> skipped});

/// [hives] içinden beslenecek kovanlar: şurupta bal katı olanlar
/// ([superHiveIds]) şurup bala karışmasın diye dışarıda kalır; kek ve polen
/// ikamesinde hepsi beslenir. Sıra korunur.
FeedingTargets feedingTargets(
  List<Hive> hives,
  Set<String> superHiveIds,
  FeedingKind kind,
) {
  if (!kind.isSyrup) return (fed: hives, skipped: const []);
  return (
    fed: [
      for (final hive in hives)
        if (!superHiveIds.contains(hive.id)) hive,
    ],
    skipped: [
      for (final hive in hives)
        if (superHiveIds.contains(hive.id)) hive,
    ],
  );
}
