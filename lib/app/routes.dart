import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/knowledge/domain/calculator_rules.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';

/// Rota yolları. Geliştirici rotaları yalnızca dev flavor'da kayıtlıdır.
abstract final class AppRoutes {
  // Alt gezinmedeki sekmeler; her biri kendi gezinme yığınını tutar.
  static const today = '/';
  static const apiaries = '/apiaries';
  static const tasks = '/tasks';
  static const more = '/more';

  static const apiaryNew = '/apiaries/new';
  static String apiary(String id) => '/apiaries/$id';
  static String apiaryEdit(String id) => '/apiaries/$id/edit';

  /// Kovan rotaları arılığın altında: geri tuşu arılığa döner. Kovan
  /// başka arılığa taşınsa da kart yoldaki arılığa değil kovana bakar.
  static String hiveNew(String apiaryId) => '/apiaries/$apiaryId/hives/new';
  static String hivesBulk(String apiaryId) => '/apiaries/$apiaryId/hives/bulk';
  static String hive(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId';
  static String hiveEdit(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/edit';

  /// Kovan kartı ve üstünde alttan açılan hızlı muayene.
  static String hiveInspect(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/inspect';

  /// Kovandaki ananın kartı; geri tuşu kovan kartına döner.
  static String hiveQueen(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/queen';

  /// Kovana yeni ana verme; kovanda ana varsa onun yerine geçer.
  static String hiveQueenNew(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/queen/new';
  static String hiveQueenEdit(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/queen/edit';

  /// Kovanın varroa ölçümü; geri tuşu kovan kartına döner.
  static String hiveVarroa(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/varroa';

  /// Kovana ya da arılığının tümüne ilaç uygulaması; geri tuşu kovan
  /// kartına döner.
  static String hiveTreat(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/treat';

  /// Kovana ya da arılığının tümüne besleme; geri tuşu kovan kartına
  /// döner.
  static String hiveFeed(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/feed';

  /// Arılığın hasadı; geri tuşu arılığa döner.
  static String apiaryHarvest(String apiaryId) => '/apiaries/$apiaryId/harvest';

  /// Arılık turu; sekmelerin üstünde açılır, geri tuşu arılığa döner.
  static String apiaryTour(String apiaryId) => '/apiaries/$apiaryId/tour';

  /// Turda kovanın muayenesi; turun üstünde alttan açılır.
  static String apiaryTourInspect(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/tour/hives/$hiveId/inspect';

  /// Tur sonu özeti; turun yerine açılır, geri tuşu arılığa döner.
  static String apiaryTourSummary(String apiaryId) =>
      '/apiaries/$apiaryId/tour-summary';

  /// Hasada alınacak kovanların seçimi; geri tuşu hasada döner.
  static String apiaryHarvestHives(String apiaryId) =>
      '/apiaries/$apiaryId/harvest/hives';

  /// Hasada kovan okutma; sekmelerin üstünde açılır, hasada döner.
  static String apiaryHarvestScan(String apiaryId) =>
      '/apiaries/$apiaryId/harvest/scan';

  /// Kaydedilen hasadı lota ekleme adımı; hasadın yerine açılır, geri tuşu
  /// arılığa döner.
  static String apiaryHarvestLot(String apiaryId, String harvestId) =>
      '/apiaries/$apiaryId/harvest-lot/$harvestId';

  /// İlaç uygulamasından işletmeye yeni ilaç ekleme; eklenen ilaç
  /// uygulamada seçilir.
  static String hiveTreatDrugNew(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/treat/drug';

  /// Okutulan kovan: muayene edilebiliyorsa kartı ve üstünde muayene,
  /// değilse (ör. sönmüş) yalnız kartı.
  static String scannedHive(Hive hive) => canInspect(hive)
      ? hiveInspect(hive.apiaryId, hive.id)
      : AppRoutes.hive(hive.apiaryId, hive.id);

  /// Arılıktaki kovanların etiketlerini seçip yazdırma.
  static String hiveLabels(String apiaryId) => '/apiaries/$apiaryId/labels';

  /// Kovan etiketinin derin linki (`mobilarici://h/<kimlik>`). Kovan varsa
  /// kartına yönlenir, yoksa etiketi atamayı sunar.
  static String hiveLink(String hiveId) => '/h/$hiveId';

  /// Tanınmayan etiketi bir kovana atama; sekmelerin üstünde açılır.
  static const labelAssignPath = '/labels/assign';
  static const labelCodeParameter = 'code';
  static String labelAssign(String code) => Uri(
    path: labelAssignPath,
    queryParameters: {labelCodeParameter: code},
  ).toString();

  /// Görev ekleme ve düzenleme; Görevler sekmesinin içinde.
  static const taskNew = '/tasks/new';
  static const taskDueParameter = 'due';
  static const taskApiaryParameter = 'apiary';
  static const taskTitleParameter = 'title';

  /// Yeni görev önerilen günle (yerel takvim günü), arılıkla ve başlıkla.
  static String taskNewSuggested({
    required DateTime day,
    String? apiaryId,
    String? title,
  }) => Uri(
    path: taskNew,
    queryParameters: {
      taskDueParameter:
          '${day.year.toString().padLeft(4, '0')}-'
          '${day.month.toString().padLeft(2, '0')}-'
          '${day.day.toString().padLeft(2, '0')}',
      taskApiaryParameter: ?apiaryId,
      taskTitleParameter: ?title,
    },
  ).toString();
  static String taskEdit(String id) => '/tasks/$id/edit';

  /// Bugün'deki "Dikkat isteyenler"in bir grubu; Bugün sekmesinin içinde.
  static String attention(AttentionKind kind) => '/attention/${kind.name}';

  /// Arılığın havası (Bugün'deki hava kartından); sekmelerin üstünde açılır.
  static String apiaryWeather(String apiaryId) => '/weather/$apiaryId';

  static const settings = '/more/settings';

  /// Offline harita paketleri; Ayarlar'dan açılır.
  static const offlineMaps = '/more/settings/maps';

  /// PDF raporları; Daha fazla'dan açılır.
  static const reports = '/more/reports';

  /// Aktif kovanlardaki değiştirilmesi gereken analar.
  static const oldQueens = '/more/old-queens';

  /// Ekip: üyeler ve davet; Daha fazla'dan açılır.
  static const team = '/more/team';

  /// "Görüş bildir"; Daha fazla'dan açılır.
  static const feedback = '/more/feedback';

  /// Belge kasası; Daha fazla'dan açılır. Belge, ekleme, düzenleme ve yol
  /// kontrolü kasanın altında.
  static const documents = '/more/documents';
  static const documentNew = '/more/documents/new';
  static String document(String id) => '/more/documents/$id';
  static String documentEdit(String id) => '/more/documents/$id/edit';

  /// Yol kontrolü: belgeler tam ekran, kaydırarak geçilir.
  static const roadCheck = '/more/documents/road-check';

  /// Malzeme ve stok; Daha fazla'dan açılır. Kalem, ekleme ve düzenleme
  /// listenin altında. Yeni kalemin kategorisi listede açık sekme.
  static const inventory = '/more/inventory';
  static const inventoryNewPath = '/more/inventory/new';
  static const inventoryCategoryParameter = 'category';
  static String inventoryNew(InventoryCategory category) => Uri(
    path: inventoryNewPath,
    queryParameters: {inventoryCategoryParameter: category.value},
  ).toString();
  static const inventoryShopping = '/more/inventory/shopping';
  static String inventoryItem(String id) => '/more/inventory/$id';
  static String inventoryItemEdit(String id) => '/more/inventory/$id/edit';

  /// Hasat ve lotlar; Daha fazla'dan açılır. Lot, düzenleme ve analiz
  /// ekleme listenin altında. Lot hasat kaydından açılır.
  static const lots = '/more/lots';
  static String lot(String id) => '/more/lots/$id';
  static String lotEdit(String id) => '/more/lots/$id/edit';
  static String lotLabResult(String id) => '/more/lots/$id/lab';

  /// Destekler (yalnız TR): başvuru öncesi kovan sayısı kontrolü ve
  /// başvuru dönemleri; Daha fazla'dan açılır. AKS'de beyan edilen kovan
  /// sayısının formu altında.
  static const subsidies = '/more/subsidies';
  static const aksHiveCount = '/more/subsidies/aks-count';

  /// Bilgi bankası; Daha fazla'dan açılır. Kategori, teşhis yardımcısı,
  /// hesaplayıcılar ve makale altında (makale kimliği `category`,
  /// `diagnosis` ya da `calculators` olamaz).
  static const knowledge = '/more/knowledge';
  static String knowledgeCategory(KnowledgeCategory category) =>
      '/more/knowledge/category/${category.value}';
  static String knowledgeArticle(String id) => '/more/knowledge/$id';

  /// Teşhis yardımcısı: belirti seçimi, olası hastalık ve ihbarı mecburi
  /// hastalıkta karantinaya alınacak kovanın seçimi.
  static const diagnosis = '/more/knowledge/diagnosis';
  static String diagnosisResult(String ruleId) =>
      '/more/knowledge/diagnosis/$ruleId';
  static String diagnosisQuarantine(String ruleId) =>
      '/more/knowledge/diagnosis/$ruleId/quarantine';

  /// Hesaplayıcılar; her biri altında.
  static const calculators = '/more/knowledge/calculators';
  static String calculator(Calculator calculator) =>
      '/more/knowledge/calculators/${calculator.value}';

  /// Sezon raporu: kovan sayısı, kayıplar, kış kaybı karşılaştırması;
  /// Daha fazla'dan açılır.
  static const season = '/more/season';

  /// Finans: sezon özeti ve son hareketler; Daha fazla'dan açılır.
  /// Gelir/gider ekleme ve hareket listenin altında. Yeni hareketin türü
  /// sorguda.
  static const finance = '/more/finance';
  static const financeNewPath = '/more/finance/new';
  static const financeKindParameter = 'kind';
  static String financeNew(TransactionKind kind) => Uri(
    path: financeNewPath,
    queryParameters: {financeKindParameter: kind.value},
  ).toString();
  static String financeTransaction(String id) => '/more/finance/$id';

  /// Satışa tahsilat ekleme.
  static String financePayment(String transactionId) =>
      '/more/finance/$transactionId/payment';

  /// Müşteri defteri; Finans'tan açılır. Yeni gelir müşteriyle açılabilir
  /// (sorguda [financeCustomerParameter]).
  static const customers = '/more/finance/customers';
  static const customerNew = '/more/finance/customers/new';
  static String customer(String id) => '/more/finance/customers/$id';
  static String customerEdit(String id) => '/more/finance/customers/$id/edit';
  static const financeCustomerParameter = 'customer';
  static String financeSale(String customerId) => Uri(
    path: financeNewPath,
    queryParameters: {
      financeKindParameter: TransactionKind.income.value,
      financeCustomerParameter: customerId,
    },
  ).toString();

  /// Ana yetiştirme serileri; Daha fazla'dan açılır. Serinin takvimi,
  /// ekleme ve düzenleme listenin altında.
  static const rearing = '/more/rearing';
  static const rearingNew = '/more/rearing/new';
  static String rearingBatch(String id) => '/more/rearing/$id';
  static String rearingBatchEdit(String id) => '/more/rearing/$id/edit';

  /// Göç planları; Daha fazla'dan açılır. Planın zaman çizelgesi, plan ve
  /// durak formları planların altında.
  static const migrations = '/more/migrations';
  static const migrationNew = '/more/migrations/new';
  static String migration(String id) => '/more/migrations/$id';
  static String migrationEdit(String id) => '/more/migrations/$id/edit';
  static String migrationStopNew(String migrationId) =>
      '/more/migrations/$migrationId/stops/new';
  static String migrationStopEdit(String migrationId, String stopId) =>
      '/more/migrations/$migrationId/stops/$stopId/edit';

  /// Planın sıradaki taşıması (kontrol, yükleme, indirme).
  static String migrationMove(String migrationId) =>
      '/more/migrations/$migrationId/move';

  /// Taşımanın sürekli okutma ekranı (yükleme ya da indirme).
  static String migrationMoveScan(String migrationId, String transportId) =>
      '/more/migrations/$migrationId/move/$transportId/scan';

  /// Fotoğrafın tam ekranı; sekmelerin üstünde açılır.
  static String mediaPhoto(String mediaId) => '/media/$mediaId';

  /// Ortadaki butonun açtığı tam ekran; sekmelerin üstünde açılır.
  static const scan = '/scan';

  /// Üst bardaki senkron ikonunun açtığı ayrıntı; sekmelerin üstünde açılır.
  static const sync = '/sync';

  /// İlk girişte tam çekme; bitene kadar sekmeler açılmaz.
  static const initialSync = '/initial-sync';

  /// Giriş yapılmamışken açılabilen tek rotalar.
  static const signIn = '/sign-in';
  static const signInCode = '/sign-in/code';

  /// İşletmesi olmayan kullanıcının açabildiği tek rota.
  static const onboarding = '/onboarding';

  /// İşletme kurulduktan sonraki son onboarding adımı. Onboarding'in alt
  /// rotası değil: geri tuşu işletme adımlarına dönmesin.
  static const onboardingApiary = '/onboarding/apiary';

  static const developerMenu = '/dev';
  static const componentGallery = '/dev/components';
}
