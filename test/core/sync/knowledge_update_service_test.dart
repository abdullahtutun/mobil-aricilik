import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/sync/knowledge_update_service.dart';
import 'package:mobil_arici/features/knowledge/data/knowledge_repository.dart';

import '../../helpers/fake_knowledge.dart';

const _article = '''
---
id: yeni
region: GLOBAL
category: guides
title: Yeni makale
summary: Güncellemeyle geldi.
---
Metin.
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeKnowledge storage;
  late KnowledgeRepository repository;
  late DateTime now;
  late KnowledgeUpdateService service;

  setUp(() {
    storage = FakeKnowledge();
    repository = KnowledgeRepository(rootBundle, storage.store);
    now = DateTime(2026, 11, 2, 9);
    service = KnowledgeUpdateService(
      storage.download,
      repository,
      clock: () => now,
    );
  });

  test('yeni sürümü indirir, doğrular ve kaydeder', () async {
    storage.publish(2, {'tr/yeni.md': _article});

    expect(await service.update(), isTrue);
    expect(storage.requested, ['manifest.json', 'knowledge-v2.json']);
    final library = await repository.load();
    expect(library.version, 2);
    expect(library.articles.single.title, 'Yeni makale');
  });

  test('manifest yoksa (404) ya da ağ yoksa eldeki içerik kalır', () async {
    expect(await service.update(), isFalse);
    expect(storage.requested, ['manifest.json']);
    expect(await repository.loadDownloaded(), isNull);
  });

  test('sürüm eldekinden büyük değilse paket indirilmez', () async {
    storage.publish(1, {'tr/yeni.md': _article});

    expect(await service.update(), isFalse);
    expect(storage.requested, ['manifest.json']);
  });

  test('özet tutmazsa kaydedilmez', () async {
    final bytes = storage.publish(2, {'tr/yeni.md': _article});
    storage.files['knowledge-v2.json'] = Uint8List.fromList([...bytes, 0x20]);

    expect(await service.update(), isFalse);
    expect(await repository.loadDownloaded(), isNull);
  });

  test('yeni biçimdeki paket indirilmez', () async {
    storage
      ..publish(2, {'tr/yeni.md': _article})
      ..files['manifest.json'] = utf8.encode(
        jsonEncode({
          'format': 2,
          'version': 2,
          'path': 'knowledge-v2.json',
          'sha256': '',
        }),
      );

    expect(await service.update(), isFalse);
    expect(storage.requested, ['manifest.json']);
  });

  test('bir saat geçmeden yeniden bakmaz; zorlanınca bakar', () async {
    await service.update();
    storage.publish(2, {'tr/yeni.md': _article});

    now = now.add(const Duration(minutes: 59));
    expect(await service.update(), isFalse);
    expect(storage.requested, ['manifest.json']);

    expect(await service.update(force: true), isTrue);

    now = now.add(const Duration(hours: 1));
    expect(await service.update(), isFalse);
    expect(storage.requested, [
      'manifest.json',
      'manifest.json',
      'knowledge-v2.json',
      'manifest.json',
    ]);
  });

  test('süren kontrol varken gelen çağrı onu bekler', () async {
    storage.publish(2, {'tr/yeni.md': _article});

    final results = await Future.wait([
      service.update(),
      service.update(force: true),
    ]);
    expect(results, [isTrue, isTrue]);
    expect(storage.requested, ['manifest.json', 'knowledge-v2.json']);
  });
}
