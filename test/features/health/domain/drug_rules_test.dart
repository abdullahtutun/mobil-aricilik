import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/drug_rules.dart';

RefDrug _ref(
  String id, {
  required String countryCode,
  required String nameTr,
  String? nameEn,
  int? withdrawalDays,
  String? licenseNo,
  DateTime? deletedAt,
}) => RefDrug(
  id: id,
  countryCode: countryCode,
  nameTr: nameTr,
  nameEn: nameEn ?? nameTr,
  activeIngredient: DrugActiveIngredient.amitraz,
  doseUnit: DrugDoseUnit.strip,
  withdrawalDays: withdrawalDays,
  licenseNo: licenseNo,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  deletedAt: deletedAt,
);

Drug _drug(String id, String name, {DateTime? deletedAt}) => Drug(
  id: id,
  orgId: 'org-1',
  name: name,
  activeIngredient: DrugActiveIngredient.thymol,
  doseUnit: DrugDoseUnit.g,
  withdrawalDays: 14,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  deletedAt: deletedAt,
);

void main() {
  final refDrugs = [
    _ref('g-oxalic', countryCode: 'GLOBAL', nameTr: 'Oksalik asit'),
    _ref(
      'g-amitraz',
      countryCode: 'GLOBAL',
      nameTr: 'Amitraz',
      nameEn: 'Amitraz EN',
    ),
    _ref(
      'tr-strip',
      countryCode: 'TR',
      nameTr: 'Amitraz şerit',
      nameEn: 'Amitraz strip',
      withdrawalDays: 0,
      licenseNo: 'TR-1',
    ),
    _ref('de-only', countryCode: 'DE', nameTr: 'Nur DE'),
    _ref(
      'g-deleted',
      countryCode: 'GLOBAL',
      nameTr: 'Silinmiş',
      deletedAt: DateTime.utc(2026),
    ),
  ];
  final drugs = [
    _drug('own-b', 'Timol jel'),
    _drug('own-a', 'Formik şerit'),
    _drug('own-deleted', 'Eski', deletedAt: DateTime.utc(2026)),
  ];

  List<String?> ids(List<DrugChoice> choices) => [
    for (final choice in choices) choice.refDrugId ?? choice.drugId,
  ];

  test('TR profilinde: işletmenin ilaçları, TR listesi, GLOBAL; '
      'gruplar kendi içinde ada göre', () {
    final catalog = drugCatalog(
      refDrugs: refDrugs,
      drugs: drugs,
      trList: true,
      languageCode: 'tr',
    );

    expect(ids(catalog), [
      'own-a',
      'own-b',
      'tr-strip',
      'g-amitraz',
      'g-oxalic',
    ]);
  });

  test('diğer bölgelerde TR listesi görünmez, etken madde bazlı GLOBAL '
      'liste ve kullanıcının ilaçları kalır', () {
    final catalog = drugCatalog(
      refDrugs: refDrugs,
      drugs: drugs,
      trList: false,
      languageCode: 'en',
    );

    expect(ids(catalog), ['own-a', 'own-b', 'g-amitraz', 'g-oxalic']);
  });

  test('başka ülkeye etiketli ve silinmiş satırlar hiçbir profilde yok', () {
    for (final trList in [true, false]) {
      final catalog = drugCatalog(
        refDrugs: refDrugs,
        drugs: drugs,
        trList: trList,
        languageCode: 'tr',
      );
      expect(
        ids(catalog),
        isNot(anyOf(contains('de-only'), contains('g-deleted'))),
      );
      expect(ids(catalog), isNot(contains('own-deleted')));
    }
  });

  test('referans ilacın adı dile göre; Türkçe dışında İngilizce', () {
    final drug = refDrugs[2];

    expect(refDrugChoice(drug, languageCode: 'tr').name, 'Amitraz şerit');
    expect(refDrugChoice(drug, languageCode: 'en').name, 'Amitraz strip');
    expect(refDrugChoice(drug, languageCode: 'de').name, 'Amitraz strip');
  });

  test('seçenek ilacın listesini, birimini, bekleme süresini ve ruhsatını '
      'taşır', () {
    expect(
      refDrugChoice(refDrugs[2], languageCode: 'tr'),
      const DrugChoice(
        refDrugId: 'tr-strip',
        name: 'Amitraz şerit',
        activeIngredient: DrugActiveIngredient.amitraz,
        doseUnit: DrugDoseUnit.strip,
        withdrawalDays: 0,
        licenseNo: 'TR-1',
      ),
    );
    expect(
      customDrugChoice(drugs.first),
      const DrugChoice(
        drugId: 'own-b',
        name: 'Timol jel',
        activeIngredient: DrugActiveIngredient.thymol,
        doseUnit: DrugDoseUnit.g,
        withdrawalDays: 14,
      ),
    );
  });
}
