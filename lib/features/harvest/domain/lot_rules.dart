import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';

/// Nem bu aralıkta (sunucudaki CHECK).
const minLotMoisture = 10.0;
const maxLotMoisture = 30.0;

/// Yöre en çok bu kadar karakter.
const maxLotOriginLength = 80;

/// Analiz değerlerinin üst sınırları (sunucudaki CHECK).
const maxLabHmf = 1000.0;
const maxLabDiastase = 100.0;
const maxLabProline = 10000.0;

/// Satışın kilogram olarak üst sınırı (sunucu da keser).
const maxLotSaleKg = 100000.0;

/// Lot numarası: yıl ve en az iki haneli sıra ("2026-07").
String formatLotNumber(int year, int seq) =>
    '$year-${seq.toString().padLeft(2, '0')}';

/// Lotun herkese açık sayfası: `<baseUrl>/<lotId>`; sondaki `/` tekrar
/// etmez. Kavanoz etiketindeki QR bu adresi taşır.
String lotPageUrl(String baseUrl, String lotId) {
  final base = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;
  return '$base/$lotId';
}

/// `--dart-define=LOT_PAGE_BASE_URL=...`; boşsa sunucunun adresinden çözülür.
const lotPageBaseUrlDefine = String.fromEnvironment('LOT_PAGE_BASE_URL');

/// Lot sayfalarının kökü. [define] (`LOT_PAGE_BASE_URL`) doluysa o; değilse
/// sunucunun `/l` yolu (K-14).
String resolveLotPageBaseUrl({
  required String pocketbaseUrl,
  String define = lotPageBaseUrlDefine,
}) {
  final override = define.trim();
  if (override.isNotEmpty) return override;
  final root = pocketbaseUrl.endsWith('/')
      ? pocketbaseUrl.substring(0, pocketbaseUrl.length - 1)
      : pocketbaseUrl;
  return '$root/l';
}

/// Yılın sıradaki lot sırası: [seqs] (o yılın silinmemiş lotlarının
/// sıraları) içindeki en büyüğün bir fazlası; lot yoksa 1.
int nextLotSeq(Iterable<int> seqs) =>
    seqs.fold(0, (max, seq) => seq > max ? seq : max) + 1;

/// Kullanıcının yazdığı ondalıklı sayı: rakamlar ve en çok bir ondalık
/// ayracı (virgül ya da nokta, en çok [fractionDigits] hane). [min] ile
/// [max] arasında değilse, boş ya da bozuksa null.
double? parseLotDecimal(
  String text, {
  required double min,
  required double max,
  int fractionDigits = 1,
}) {
  final match = RegExp('^([0-9]{1,6})(?:[.,]([0-9]{1,$fractionDigits}))?\$')
      .firstMatch(text.trim());
  if (match == null) return null;
  final value = double.parse('${match.group(1)}.${match.group(2) ?? '0'}');
  return value >= min && value <= max ? value : null;
}

/// Nem (%); boş, bozuk ya da aralık dışıysa null.
double? parseLotMoisture(String text) =>
    parseLotDecimal(text, min: minLotMoisture, max: maxLotMoisture);

/// Lotun stoğu: kilogram eksi satışlar, üç ondalığa yuvarlı.
double lotStock(LotSummary summary) =>
    ((summary.kg - summary.soldKg) * 1000).roundToDouble() / 1000;

/// Hasada alınan bir kovanın lota bağlanacak son ilaçlaması.
typedef LotTreatmentLink = ({
  String hiveId,
  Treatment treatment,
  DateTime withdrawalEndsOn,
  bool violation,
});

/// [harvestedAt] günü hasada alınan [hiveIds] kovanlarının son
/// ilaçlamaları ([treatments] bu kovanların uygulamaları). Hasat gününe
/// kadar başlamış silinmemiş uygulamalar sayılır; en son başlayan "son
/// ilaçlama"dır. Bekleme süresinin bittiği gün bu uygulamaların en geç
/// bitenidir; hasat günü o günden önceyse ihlal ([withdrawalLock] ile aynı
/// kural). İlaçlanmamış kovan listede yok; sıra [hiveIds]'in.
List<LotTreatmentLink> lotTreatmentLinks({
  required DateTime harvestedAt,
  required Iterable<String> hiveIds,
  required Iterable<Treatment> treatments,
}) {
  final harvestDay = _day(harvestedAt);
  final byHive = <String, List<Treatment>>{};
  for (final treatment in treatments) {
    if (treatment.deletedAt != null) continue;
    if (_day(treatment.startedAt).isAfter(harvestDay)) continue;
    (byHive[treatment.hiveId] ??= []).add(treatment);
  }
  return [
    for (final hiveId in hiveIds)
      if (byHive[hiveId] case final hiveTreatments?)
        _link(hiveId, hiveTreatments, harvestDay),
  ];
}

LotTreatmentLink _link(
  String hiveId,
  List<Treatment> treatments,
  DateTime harvestDay,
) {
  var last = treatments.first;
  var endsOn = treatmentWithdrawalEnd(last);
  for (final treatment in treatments.skip(1)) {
    if (treatment.startedAt.isAfter(last.startedAt)) last = treatment;
    final end = treatmentWithdrawalEnd(treatment);
    if (end.isAfter(endsOn)) endsOn = end;
  }
  return (
    hiveId: hiveId,
    treatment: last,
    withdrawalEndsOn: dateOnly(endsOn),
    violation: endsOn.isAfter(harvestDay),
  );
}

/// Lot listesinin özeti: verilen yılın lotlarının kilogramı (`yearKg`),
/// bütün lotların stoğu (`stockKg`, eksiye düşen lot sıfır sayılır) ve
/// yılın kovan başı verimi (`perHive`; kovan yoksa null).
typedef LotOverview = ({double yearKg, double stockKg, double? perHive});

LotOverview lotOverview(Iterable<LotSummary> lots, int year) {
  var yearKg = 0.0;
  var stockKg = 0.0;
  var hives = 0;
  for (final summary in lots) {
    final stock = lotStock(summary);
    if (stock > 0) stockKg += stock;
    if (summary.lot.year == year) {
      yearKg += summary.kg;
      hives += summary.hiveCount;
    }
  }
  return (
    yearKg: yearKg,
    stockKg: stockKg,
    perHive: hives > 0 ? yearKg / hives : null,
  );
}

/// Liste sırası: yeni yıl önce, yıl içinde büyük sıra önce.
int compareLots(Lot a, Lot b) {
  final byYear = b.year.compareTo(a.year);
  return byYear != 0 ? byYear : b.seq.compareTo(a.seq);
}

/// Yerel takvimde günün başı.
DateTime _day(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}
