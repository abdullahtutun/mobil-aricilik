import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';

String _md({
  String id = 'ana-verme',
  String region = 'GLOBAL',
  String category = 'guides',
  String? months,
  String title = 'Ana verme',
  String summary = 'Kafesle ana verme.',
  String body = '## Hazırlık\n\nMetin.',
}) =>
    '---\n'
    'id: $id\n'
    'region: $region\n'
    'category: $category\n'
    '${months == null ? '' : 'months: $months\n'}'
    'title: $title\n'
    'summary: $summary\n'
    '---\n\n'
    '$body\n';

KnowledgeArticle _article({
  String id = 'a',
  String language = 'tr',
  KnowledgeRegion region = KnowledgeRegion.global,
  KnowledgeCategory category = KnowledgeCategory.guides,
  String title = 'Başlık',
  String summary = 'Özet',
  String body = '',
  List<int> months = const [],
}) => KnowledgeArticle(
  id: id,
  language: language,
  region: region,
  category: category,
  title: title,
  summary: summary,
  body: body,
  months: months,
);

void main() {
  group('parseKnowledgeArticle', () {
    test('ön bilgiyi ve gövdeyi okur', () {
      final article = parseKnowledgeArticle(
        _md(
          region: 'TR',
          category: 'calendar',
          months: '[10, 11]',
          title: "Kasım'da yapılacaklar",
          summary: 'Stok: kontrol #1',
        ),
        language: 'tr',
      );
      expect(article.id, 'ana-verme');
      expect(article.language, 'tr');
      expect(article.region, KnowledgeRegion.tr);
      expect(article.category, KnowledgeCategory.calendar);
      expect(article.months, [10, 11]);
      expect(article.title, "Kasım'da yapılacaklar");
      // İkinci iki nokta ve # değere aittir.
      expect(article.summary, 'Stok: kontrol #1');
      expect(article.body, '## Hazırlık\n\nMetin.');
    });

    test('Windows satır sonu, yorum satırı ve bilinmeyen anahtar', () {
      final article = parseKnowledgeArticle(
        '---\r\n'
        '# yorum\r\n'
        'id: x\r\n'
        'region: GLOBAL\r\n'
        'category: first_year\r\n'
        'author: Biri\r\n'
        'title: T\r\n'
        'summary: S\r\n'
        '---\r\n'
        'Gövde\r\n',
        language: 'en',
      );
      expect(article.region, KnowledgeRegion.global);
      expect(article.category, KnowledgeCategory.firstYear);
      expect(article.months, isEmpty);
      expect(article.body, 'Gövde');
    });

    test('boş ay listesi', () {
      expect(
        parseKnowledgeArticle(_md(months: '[]'), language: 'tr').months,
        isEmpty,
      );
    });

    for (final (reason, source) in [
      ('ön bilgi yok', 'id: x\n'),
      ('ön bilgi kapanmamış', '---\nid: x\n'),
      ('iki noktasız satır', '---\nid x\n---\n'),
      ('başlık yok', _md(title: '')),
      ('bilinmeyen bölge', _md(region: 'EU')),
      ('bilinmeyen kategori', _md(category: 'recipes')),
      ('köşeli parantezsiz ay', _md(months: '11')),
      ('13. ay', _md(months: '[13]')),
      ('sayı olmayan ay', _md(months: '[kasım]')),
    ]) {
      test('hata: $reason', () {
        expect(
          () => parseKnowledgeArticle(source, language: 'tr'),
          throwsFormatException,
        );
      });
    }
  });

  group('parseKnowledgePackage', () {
    test('dili yoldan alır; okunamayan ve yinelenen makaleyi atlar', () {
      final library = parseKnowledgePackage({
        'format': 1,
        'version': 3,
        'files': {
          'tr/a.md': _md(id: 'a'),
          'en/a.md': _md(id: 'a', title: 'Queen'),
          'tr/kopya.md': _md(id: 'a', title: 'Kopya'),
          'tr/yeni.md': _md(id: 'yeni', category: 'recipes'),
          'kok.md': _md(id: 'kok'),
          'tr/not.txt': _md(id: 'txt'),
          'tr/sayi.md': 5,
        },
      });
      expect(library.version, 3);
      expect(
        [for (final a in library.articles) (a.language, a.id, a.title)],
        [('tr', 'a', 'Ana verme'), ('en', 'a', 'Queen')],
      );
    });

    test('desteklenmeyen biçim ve bozuk paket hata verir', () {
      expect(
        () => parseKnowledgePackage({
          'format': 2,
          'version': 1,
          'files': <String, Object?>{},
        }),
        throwsFormatException,
      );
      expect(
        () =>
            parseKnowledgePackage({'version': 1, 'files': <String, Object?>{}}),
        throwsFormatException,
      );
      expect(() => parseKnowledgePackage([1]), throwsFormatException);
    });
  });

  group('manifest ve paket doğrulama', () {
    final bytes = utf8.encode(
      jsonEncode({
        'format': 1,
        'version': 2,
        'files': {'tr/a.md': _md(id: 'a')},
      }),
    );
    final hash = sha256.convert(bytes).toString();

    test('manifesti okur; özet küçük harfe çevrilir', () {
      final manifest = parseKnowledgeManifest({
        'format': 1,
        'version': 2,
        'path': 'knowledge-v2.json',
        'sha256': hash.toUpperCase(),
      });
      expect(manifest.sha256, hash);
      expect(manifest.path, 'knowledge-v2.json');
      expect(
        () => parseKnowledgeManifest({'version': '2'}),
        throwsFormatException,
      );
    });

    KnowledgeManifest manifest({int version = 2, String? sha}) =>
        KnowledgeManifest(
          format: 1,
          version: version,
          path: 'p',
          sha256: sha ?? hash,
        );

    test('özet ve sürüm tutarsa paketi döner', () {
      final library = verifyKnowledgePackage(bytes, manifest());
      expect(library.version, 2);
      expect(library.articles.single.id, 'a');
    });

    test('özet ya da sürüm tutmazsa hata verir', () {
      expect(
        () => verifyKnowledgePackage(bytes, manifest(sha: '0' * 64)),
        throwsFormatException,
      );
      expect(
        () => verifyKnowledgePackage(bytes, manifest(version: 3)),
        throwsFormatException,
      );
    });
  });

  group('visibleKnowledgeArticles', () {
    final articles = [
      _article(id: 'tr-only', region: KnowledgeRegion.tr, title: 'Zirai'),
      _article(id: 'global', title: 'İlaç'),
      _article(id: 'ç', title: 'Çıta'),
      _article(id: 'en', language: 'en', title: 'Queen'),
    ];

    test('TR profilinde TR ve GLOBAL, Türkçe harfler doğru sırada', () {
      expect(
        visibleKnowledgeArticles(
          articles,
          language: 'tr',
          profile: RegionProfile.tr,
        ).map((a) => a.id),
        ['ç', 'global', 'tr-only'],
      );
    });

    test('diğer bölgede yalnız GLOBAL; dil süzülür', () {
      expect(
        visibleKnowledgeArticles(
          articles,
          language: 'tr',
          profile: RegionProfile.other,
        ).map((a) => a.id),
        ['ç', 'global'],
      );
      expect(
        visibleKnowledgeArticles(
          articles,
          language: 'en',
          profile: RegionProfile.other,
        ).map((a) => a.id),
        ['en'],
      );
    });
  });

  group('ay kartı', () {
    test('Güney yarımkürede aylar 6 kayar', () {
      expect(northernMonth(11, Hemisphere.northern), 11);
      expect(
        [for (var m = 1; m <= 12; m++) northernMonth(m, Hemisphere.southern)],
        [7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6],
      );
    });

    final trNovember = _article(
      id: 'tr-kasim',
      region: KnowledgeRegion.tr,
      category: KnowledgeCategory.calendar,
      months: [11],
    );
    final globalNovember = _article(
      id: 'global-kasim',
      category: KnowledgeCategory.calendar,
      months: [11, 12],
    );
    final guideNovember = _article(id: 'rehber', months: [11]);

    test('TR profilinde önce TR, diğerinde GLOBAL; takvim dışı sayılmaz', () {
      final visible = [guideNovember, globalNovember, trNovember];
      expect(
        monthKnowledgeArticle(
          visible,
          month: 11,
          hemisphere: Hemisphere.northern,
          profile: RegionProfile.tr,
        )?.id,
        'tr-kasim',
      );
      expect(
        monthKnowledgeArticle(
          [guideNovember, globalNovember],
          month: 11,
          hemisphere: Hemisphere.northern,
          profile: RegionProfile.other,
        )?.id,
        'global-kasim',
      );
      expect(
        monthKnowledgeArticle(
          [guideNovember],
          month: 11,
          hemisphere: Hemisphere.northern,
          profile: RegionProfile.tr,
        ),
        isNull,
      );
    });

    test('Güney yarımkürede Mayıs, Kuzey Kasım makalesini açar', () {
      expect(
        monthKnowledgeArticle(
          [globalNovember],
          month: 5,
          hemisphere: Hemisphere.southern,
          profile: RegionProfile.other,
        )?.id,
        'global-kasim',
      );
      expect(
        monthKnowledgeArticle(
          [globalNovember],
          month: 11,
          hemisphere: Hemisphere.southern,
          profile: RegionProfile.other,
        ),
        isNull,
      );
    });
  });

  group('arama', () {
    test('büyük/küçük harf ve Türkçe harf farkı yok', () {
      expect(foldForSearch('KİREÇ Hastalığı'), 'kirec hastaligi');
      expect(foldForSearch('IŞIK'), 'isik');
      expect(foldForSearch('Ağaç ÖĞÜT'), 'agac ogut');
    });

    final articles = [
      _article(id: 'govde', title: 'Kışlatma', body: 'Kireç önlemi'),
      _article(id: 'baslik', title: 'Kireç hastalığı', summary: 'Mantar'),
      _article(id: 'ozet', title: 'Atlas', summary: 'kireç ve diğerleri'),
    ];

    test('başlıkta geçen önce, sonra özet, sonra metin', () {
      expect(searchKnowledgeArticles(articles, 'kirec').map((a) => a.id), [
        'baslik',
        'ozet',
        'govde',
      ]);
    });

    test('her kelime geçmeli; noktalama ayırır', () {
      expect(
        searchKnowledgeArticles(articles, 'kireç, mantar').map((a) => a.id),
        ['baslik'],
      );
      expect(searchKnowledgeArticles(articles, 'kireç arı'), isEmpty);
    });

    test('boş sorgu boş liste', () {
      expect(searchKnowledgeArticles(articles, '  ,  '), isEmpty);
    });
  });
}
