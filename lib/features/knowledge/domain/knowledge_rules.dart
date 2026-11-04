import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/utils/text_fold.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';

/// Bu uygulamanın okuyabildiği paket biçimi. Biçim değişirse eski
/// uygulamalar yeni paketi indirmez, kendi içeriğiyle kalır.
const knowledgeFormat = 1;

/// Markdown dosyasını makaleye çevirir. Dosya ön bilgiyle başlar:
///
/// ```text
/// ---
/// id: ana-verme
/// region: GLOBAL
/// category: guides
/// months: [10, 11]
/// title: Ana verme
/// summary: Tek satır özet
/// ---
/// ```
///
/// `region`: `TR` ya da `GLOBAL`. `category`: `atlas`, `guides`,
/// `regulations`, `first_year` ya da `calendar`. `months` isteğe bağlı,
/// Kuzey yarımküre ayları. `#` ile başlayan satır yorumdur; değerin
/// içindeki `#` metne aittir. Bilinmeyen anahtarlar yok sayılır. Zorunlu
/// alan eksikse, bölge ya da kategori tanınmıyorsa veya ay 1–12 dışındaysa
/// [FormatException] atar.
KnowledgeArticle parseKnowledgeArticle(
  String source, {
  required String language,
}) {
  final lines = const LineSplitter().convert(source);
  if (lines.isEmpty || lines.first.trim() != '---') {
    throw const FormatException('Ön bilgi yok');
  }
  final end = lines.indexWhere((line) => line.trim() == '---', 1);
  if (end < 0) throw const FormatException('Ön bilgi kapanmamış');

  final meta = <String, String>{};
  for (final line in lines.sublist(1, end)) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final colon = trimmed.indexOf(':');
    if (colon <= 0) throw FormatException('Geçersiz satır', line);
    meta[trimmed.substring(0, colon).trim()] = trimmed
        .substring(colon + 1)
        .trim();
  }

  String required(String key) => switch (meta[key]) {
    final value? when value.isNotEmpty => value,
    _ => throw FormatException('Eksik alan', key),
  };

  final region = required('region');
  final category = required('category');
  return KnowledgeArticle(
    id: required('id'),
    language: language,
    region: KnowledgeRegion.values.firstWhere(
      (value) => value.value == region,
      orElse: () => throw FormatException('Bilinmeyen bölge', region),
    ),
    category: KnowledgeCategory.values.firstWhere(
      (value) => value.value == category,
      orElse: () => throw FormatException('Bilinmeyen kategori', category),
    ),
    title: required('title'),
    summary: required('summary'),
    months: _months(meta['months']),
    body: lines.sublist(end + 1).join('\n').trim(),
  );
}

List<int> _months(String? value) {
  if (value == null || value.isEmpty) return const [];
  if (!value.startsWith('[') || !value.endsWith(']')) {
    throw FormatException('Aylar [1, 2] biçiminde olmalı', value);
  }
  final inner = value.substring(1, value.length - 1).trim();
  if (inner.isEmpty) return const [];
  return [
    for (final part in inner.split(','))
      switch (int.tryParse(part.trim())) {
        final month? when month >= 1 && month <= 12 => month,
        _ => throw FormatException('Geçersiz ay', part),
      },
  ];
}

/// İçerik paketi (`{"format", "version", "files": {"tr/x.md": "..."}}`).
/// Dosyanın dili yolunun ilk klasörü. Okunamayan makale atlanır: yeni
/// paketteki bilinmeyen bir kategori, eski uygulamada yalnız o makaleyi
/// gizler. Paketin kendisi geçersizse ya da biçimi [knowledgeFormat] değilse
/// [FormatException] atar.
KnowledgeLibrary parseKnowledgePackage(Object? json) {
  if (json case {
    'format': final int format,
    'version': final int version,
    'files': final Map<String, Object?> files,
  }) {
    if (format != knowledgeFormat) {
      throw FormatException('Desteklenmeyen biçim', format);
    }
    final articles = <KnowledgeArticle>[];
    final seen = <(String, String)>{};
    for (final MapEntry(key: path, value: source) in files.entries) {
      final slash = path.indexOf('/');
      if (slash <= 0 || !path.endsWith('.md') || source is! String) continue;
      try {
        final article = parseKnowledgeArticle(
          source,
          language: path.substring(0, slash),
        );
        if (seen.add((article.language, article.id))) articles.add(article);
      } on FormatException {
        continue;
      }
    }
    return KnowledgeLibrary(version: version, articles: articles);
  }
  throw const FormatException('Geçersiz paket');
}

/// Storage'daki `manifest.json`; geçersizse [FormatException] atar.
KnowledgeManifest parseKnowledgeManifest(Object? json) {
  if (json case {
    'format': final int format,
    'version': final int version,
    'path': final String path,
    'sha256': final String sha256,
  }) {
    return KnowledgeManifest(
      format: format,
      version: version,
      path: path,
      sha256: sha256.toLowerCase(),
    );
  }
  throw const FormatException('Geçersiz manifest');
}

/// İndirilen paketi doğrular: SHA-256 özeti ve sürüm manifestle aynı, biçim
/// okunabilir. Uymazsa [FormatException] atar.
KnowledgeLibrary verifyKnowledgePackage(
  List<int> bytes,
  KnowledgeManifest manifest,
) {
  if (sha256.convert(bytes).toString() != manifest.sha256) {
    throw const FormatException('Özet tutmuyor');
  }
  final library = parseKnowledgePackage(jsonDecode(utf8.decode(bytes)));
  if (library.version != manifest.version) {
    throw FormatException('Sürüm tutmuyor', library.version);
  }
  return library;
}

/// Arayüz dilindeki ve bölgede görünen makaleler: TR profilinde TR ve
/// GLOBAL, diğer bölgelerde yalnız GLOBAL. Başlığa göre sıralı.
List<KnowledgeArticle> visibleKnowledgeArticles(
  List<KnowledgeArticle> articles, {
  required String language,
  required RegionProfile profile,
}) =>
    articles
        .where(
          (article) =>
              article.language == language &&
              (article.region == KnowledgeRegion.global ||
                  profile == RegionProfile.tr),
        )
        .toList()
      ..sort(
        (a, b) => foldForSearch(a.title).compareTo(foldForSearch(b.title)),
      );

/// [month]'un Kuzey yarımküredeki karşılığı; Güney'de mevsimler 6 ay
/// kayar (Güney'de Ocak, Kuzey'de Temmuz'dur).
int northernMonth(int month, Hemisphere hemisphere) => switch (hemisphere) {
  Hemisphere.northern => month,
  Hemisphere.southern => (month + 5) % 12 + 1,
};

/// "Bu ay yapılacaklar" makalesi: ayı tutan takvim makalesi; TR profilinde
/// önce TR etiketlisi, yoksa GLOBAL. Yoksa null.
KnowledgeArticle? monthKnowledgeArticle(
  List<KnowledgeArticle> visible, {
  required int month,
  required Hemisphere hemisphere,
  required RegionProfile profile,
}) {
  final target = northernMonth(month, hemisphere);
  final candidates = visible.where(
    (article) =>
        article.category == KnowledgeCategory.calendar &&
        article.months.contains(target),
  );
  return (profile == RegionProfile.tr
          ? candidates.where((a) => a.region == KnowledgeRegion.tr).firstOrNull
          : null) ??
      candidates.firstOrNull;
}

/// Bilgi bankası ekranından kaldırılan kategoriler; makaleleri aramada da
/// çıkmaz (kullanıcı kararı, 2026-11-04).
const Set<KnowledgeCategory> hiddenKnowledgeCategories = {
  KnowledgeCategory.atlas,
  KnowledgeCategory.guides,
  KnowledgeCategory.regulations,
  KnowledgeCategory.firstYear,
};

/// Tam metin arama: sorgunun her kelimesi başlık, özet ya da metinde
/// geçmeli. Başlıkta geçen önce, sonra özette geçen; eşitse başlık sırası.
/// [hiddenKnowledgeCategories] makaleleri atlanır. Boş sorguda boş liste.
List<KnowledgeArticle> searchKnowledgeArticles(
  List<KnowledgeArticle> articles,
  String query,
) {
  final words = foldForSearch(query)
      .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
      .where((w) => w.isNotEmpty);
  if (words.isEmpty) return const [];

  final scored = <(KnowledgeArticle, int, String)>[];
  for (final article in articles) {
    if (hiddenKnowledgeCategories.contains(article.category)) continue;
    final title = foldForSearch(article.title);
    final summary = foldForSearch(article.summary);
    final body = foldForSearch(article.body);
    var score = 0;
    var all = true;
    for (final word in words) {
      if (title.contains(word)) {
        score += 4;
      } else if (summary.contains(word)) {
        score += 2;
      } else if (body.contains(word)) {
        score += 1;
      } else {
        all = false;
        break;
      }
    }
    if (all) scored.add((article, score, title));
  }
  scored.sort((a, b) {
    final byScore = b.$2.compareTo(a.$2);
    return byScore != 0 ? byScore : a.$3.compareTo(b.$3);
  });
  return [for (final (article, _, _) in scored) article];
}
