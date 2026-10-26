import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

/// Kat ya da çerçeve sayısının üst sınırı (sunucu da 1000'de keser).
const maxHarvestUnitCount = 1000;

/// Süzülen balın kilogram olarak üst sınırı (sunucu da keser).
const maxHarvestNetKg = 100000.0;

/// Kullanıcının yazdığı ağırlık: rakamlar ve en çok bir ondalık ayracı
/// (virgül ya da nokta, en çok üç hane). Basamak ayracı kabul edilmez. Boş,
/// bozuk ya da sıfır ise null.
double? parseHarvestWeight(String text) {
  final match = _weight.firstMatch(text.trim());
  if (match == null) return null;
  final value = double.parse('${match.group(1)}.${match.group(2) ?? '0'}');
  return value > 0 ? value : null;
}

final _weight = RegExp(r'^([0-9]{1,6})(?:[.,]([0-9]{1,3}))?$');

/// Kullanıcının birimindeki ağırlığı ([unit]) saklanan kilograma çevirir
/// ve üç ondalığa yuvarlar.
double storedHarvestKg(double value, MassUnit unit) =>
    (unit.convert(value, to: MassUnit.kilogram) * 1000).roundToDouble() / 1000;

/// Hasat sunucunun kısıtlarına uyuyor mu: kat ya da çerçeve 1 ile
/// [maxHarvestUnitCount] arası, süzülen bal 0'dan büyük ve en çok
/// [maxHarvestNetKg].
bool isValidHarvestAmount({required int unitCount, required double netKg}) =>
    unitCount >= 1 &&
    unitCount <= maxHarvestUnitCount &&
    netKg > 0 &&
    netKg <= maxHarvestNetKg;

/// Hasada alınacak kovanlar (`harvested`) ve bekleme süresi yüzünden
/// alınmayanlar (`locked`); ikisi de numara sırasıyla.
typedef HarvestTargets = ({List<Hive> harvested, List<Hive> locked});

/// [hives] (arılığın aktif kovanları) içinden [selected] kimlikli olanlar
/// hasada alınır. Bekleme süresindeki ([locks]) kovan, bilerek geçilmediyse
/// ([overrides]) seçili olsa da alınmaz; seçili olsun olmasın `locked`'a
/// düşer.
HarvestTargets harvestTargets({
  required Iterable<Hive> hives,
  required Set<String> selected,
  required Map<String, WithdrawalLock> locks,
  required Map<String, WithdrawalOverride> overrides,
}) {
  final harvested = <Hive>[];
  final locked = <Hive>[];
  final sorted = hives.toList()
    ..sort((a, b) => compareNatural(a.number, b.number));
  for (final hive in sorted) {
    if (locks.containsKey(hive.id) && !overrides.containsKey(hive.id)) {
      locked.add(hive);
    } else if (selected.contains(hive.id)) {
      harvested.add(hive);
    }
  }
  return (harvested: harvested, locked: locked);
}

/// Kovan başına ortalama süzülen bal; kovan yoksa null.
double? harvestPerHive(double net, int hives) => hives > 0 ? net / hives : null;
