import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/health/data/drug_info_repository.dart';
import 'package:mobil_arici/features/health/domain/drug_info.dart';

Map<String, Object?> _json(String id, {Map<String, String>? usage}) => {
  'ref_drug_id': id,
  'ilac_adi': 'İlaç $id',
  'etken_madde': 'Flumetrin',
  'endikasyonlar': 'Varroa',
  'kullanimi_ve_sikligi': usage ?? {'uygulama_sekli': 'Asılır'},
  'uygulandigi_donem': {
    'uygun_donemler': ['Sonbahar'],
  },
  'kalinti_bilgisi_ikas': {'arinma_suresi': '0 gün'},
};

void main() {
  group('parseDrugInfos', () {
    test('kimliğe göre; eksik dönem listesi boş, uyarı yoksa null', () {
      final infos = parseDrugInfos([_json('a'), _json('b')]);
      expect(infos.keys, ['a', 'b']);
      final info = infos['a']!;
      expect(info.name, 'İlaç a');
      expect(info.periods.suitable, ['Sonbahar']);
      expect(info.periods.avoid, isEmpty);
      expect(info.residue!.withdrawal, '0 gün');
      expect(info.residue!.warnings, isNull);
      expect(info.defaults, isNull);
      expect(drugInfoHasDetails(info), isTrue);
    });

    test('yalnız ad ve etken madde: diğer alanlar boş, ayrıntı yok', () {
      final info = parseDrugInfos([
        {'ref_drug_id': 'r', 'ilac_adi': 'Rulamit', 'etken_madde': 'Amitraz'},
      ])['r']!;
      expect(info.indications, isNull);
      expect(info.usage, isEmpty);
      expect(info.periods.suitable, isEmpty);
      expect(info.residue, isNull);
      expect(drugInfoHasDetails(info), isFalse);
    });

    test('otomatik doldurma değerleri', () {
      final json = _json('a')
        ..['otomatik_doldurma'] = {'doz': 2, 'uygulama_gun': 63};
      expect(
        parseDrugInfos([json])['a']!.defaults,
        const DrugInfoDefaults(dose: 2, treatmentDays: 63),
      );
    });

    test('aynı kimlik iki kez geçerse ilki kalır', () {
      final second = _json('a')..['ilac_adi'] = 'İkinci';
      expect(parseDrugInfos([_json('a'), second])['a']!.name, 'İlaç a');
    });
  });

  test('drugUsageItems: sabit sıra, tanınmayan anahtar sonda, boşlar '
      'atlanır', () {
    expect(
      drugUsageItems({
        'uygulama_suresi': '4 hafta',
        'bilinmeyen': 'Not',
        'dozaj': ' 2 şerit ',
        'teshis_amaciyla': '',
        'uygulama_sekli': 'Asılır',
      }),
      [
        (DrugUsageKind.method, 'Asılır'),
        (DrugUsageKind.dose, '2 şerit'),
        (DrugUsageKind.duration, '4 hafta'),
        (DrugUsageKind.other, 'Not'),
      ],
    );
  });

  group('ilaclar.json', () {
    final infos = parseDrugInfos(
      jsonDecode(File(DrugInfoRepository.assetPath).readAsStringSync())
          as List<Object?>,
    );
    final migration =
        [
              '20261031200000_tr_ref_drugs.sql',
              '20261101120000_tr_ref_drugs_amitraz.sql',
            ]
            .map((name) => File('supabase/migrations/$name').readAsStringSync())
            .join();
    final detailed = [
      for (final info in infos.values)
        if (drugInfoHasDetails(info)) info,
    ];

    test('11 ürün; yalnız ad ve etken maddesi olan 4 amitraz ürünü', () {
      expect(infos, hasLength(11));
      expect(
        [
          for (final info in infos.values)
            if (!drugInfoHasDetails(info)) (info.name, info.activeIngredient),
        ],
        [
          ('Rulamit', 'Amitraz'),
          ('Rulamit-Va', 'Amitraz'),
          ('Vamitrat-Va', 'Amitraz'),
          ('Varroset', 'Amitraz'),
        ],
      );
      for (final info in infos.values) {
        if (!drugInfoHasDetails(info)) expect(info.defaults, isNull);
      }
    });

    test('ayrıntılı 7 ürün: her alanı dolu, doz ve süre dolu, tanınan '
        'kullanım anahtarları', () {
      expect(detailed, hasLength(7));
      for (final info in detailed) {
        expect(info.name, isNotEmpty);
        expect(info.activeIngredient, isNotEmpty);
        expect(info.indications, isNotEmpty);
        expect(info.residue!.withdrawal, isNotEmpty);
        expect(info.periods.suitable, isNotEmpty);
        expect(info.defaults!.dose, greaterThan(0), reason: info.name);
        expect(info.defaults!.treatmentDays, greaterThan(0), reason: info.name);
        final usage = drugUsageItems(info.usage);
        expect(usage, isNotEmpty);
        expect(
          usage.map((item) => item.$1),
          isNot(contains(DrugUsageKind.other)),
          reason: info.name,
        );
      }
    });

    test('uygulamayla paketlenir ve repository okur', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final loaded = await DrugInfoRepository(rootBundle).loadAll();
      expect(loaded, infos);
    });

    test("her ürün TR referans ilacı olarak aynı adla migration'da", () {
      for (final info in infos.values) {
        expect(
          migration,
          contains("('${info.refDrugId}', 'TR', '${info.name}'"),
          reason: info.name,
        );
      }
    });
  });
}
