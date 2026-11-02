import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/features/knowledge/data/knowledge_repository.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';

const _article = '''
---
id: indirilen
region: GLOBAL
category: guides
title: İndirilen
summary: Paketten gelen makale.
---
Metin.
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;
  late KnowledgeRepository repository;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('knowledge_repository');
    repository = KnowledgeRepository(
      rootBundle,
      MediaFileStore(Future.value(directory)),
    );
  });
  tearDown(() => directory.deleteSync(recursive: true));

  void writePackage(Object? json) =>
      File('${directory.path}/${KnowledgeRepository.packageFile}')
          .writeAsStringSync(jsonEncode(json));

  group('uygulamayla gelen içerik', () {
    test(
      'her dosya okunur; her makale iki dilde aynı meta veriyle var',
      () async {
        final manifest = jsonDecode(
          await rootBundle.loadString(KnowledgeRepository.manifestAsset),
        ) as Map<String, Object?>;
        final paths = (await AssetManifest.loadFromAssetBundle(rootBundle))
            .listAssets()
            .where((path) => path.startsWith(KnowledgeRepository.assetRoot))
            .where((path) => path.endsWith('.md'))
            .toList();
        final library = await repository.loadBundled();

        expect(manifest['format'], knowledgeFormat);
        expect(library.version, manifest['version']);
        expect(paths, isNotEmpty);
        // Okunamayan dosya sessizce atlanmasın.
        expect(library.articles, hasLength(paths.length));

        final byLanguage = {
          for (final language in ['tr', 'en'])
            language: {
              for (final article in library.articles.where(
                (article) => article.language == language,
              ))
                article.id: article,
            },
        };
        expect(byLanguage['tr']!.keys.toSet(), byLanguage['en']!.keys.toSet());
        for (final MapEntry(key: id, value: tr) in byLanguage['tr']!.entries) {
          final en = byLanguage['en']![id]!;
          expect(
            (en.region, en.category, en.months.join(',')),
            (tr.region, tr.category, tr.months.join(',')),
            reason: id,
          );
          expect(id, isNot('category'), reason: 'rotadaki sabit yolla çakışır');
        }
      },
    );

    test('örnek makaleler: Kasım takvimi (TR), atlas ve rehber', () async {
      final tr = (await repository.loadBundled()).articles.where(
        (article) => article.language == 'tr',
      );
      expect(
        {for (final a in tr) a.id: (a.region, a.category, a.months.join(','))},
        {
          'kasim-yapilacaklar': (
            KnowledgeRegion.tr,
            KnowledgeCategory.calendar,
            '11',
          ),
          'kirec-hastaligi': (
            KnowledgeRegion.global,
            KnowledgeCategory.atlas,
            '',
          ),
          'ana-verme': (KnowledgeRegion.global, KnowledgeCategory.guides, ''),
        },
      );
    });
  });

  group('load', () {
    test('indirilen paket yoksa uygulamayla gelen', () async {
      expect(await repository.loadDownloaded(), isNull);
      expect((await repository.load()).version, 1);
    });

    test('indirilen paket daha yeniyse o okunur', () async {
      writePackage({
        'format': 1,
        'version': 2,
        'files': {'tr/indirilen.md': _article},
      });
      final library = await repository.load();
      expect(library.version, 2);
      expect(library.articles.single.id, 'indirilen');
    });

    test(
      'indirilen paket eski ya da aynı sürümdeyse uygulamayla gelen',
      () async {
        writePackage({
          'format': 1,
          'version': 1,
          'files': {'tr/indirilen.md': _article},
        });
        final library = await repository.load();
        expect(library.articles.map((a) => a.id), isNot(contains('indirilen')));
      },
    );

    test('bozuk ya da yeni biçimdeki paket yok sayılır', () async {
      File('${directory.path}/${KnowledgeRepository.packageFile}')
          .writeAsStringSync('{yarım');
      expect(await repository.loadDownloaded(), isNull);

      writePackage({'format': 2, 'version': 9, 'files': <String, Object?>{}});
      expect(await repository.loadDownloaded(), isNull);
      expect((await repository.load()).version, 1);
    });

    test('saveDownloaded kaydeder; sonraki load onu okur', () async {
      await repository.saveDownloaded(
        utf8.encode(
          jsonEncode({
            'format': 1,
            'version': 5,
            'files': {'en/indirilen.md': _article},
          }),
        ),
      );
      final library = await repository.load();
      expect(library.version, 5);
      expect(library.articles.single.language, 'en');
    });
  });
}
