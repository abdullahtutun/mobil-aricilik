import 'package:freezed_annotation/freezed_annotation.dart';

part 'knowledge_article.freezed.dart';

/// Makalenin bölge etiketi: yalnız TR profilinde ya da her yerde görünür.
enum KnowledgeRegion {
  tr('TR'),
  global('GLOBAL');

  new(this.value);

  /// Ön bilgideki yazımı.
  final String value;
}

/// Bilgi bankası kategorisi. [calendar] makaleleri listede değil, "Bu ay
/// yapılacaklar" kartında ve aramada görünür.
enum KnowledgeCategory {
  atlas('atlas'),
  guides('guides'),
  regulations('regulations'),
  firstYear('first_year'),
  calendar('calendar');

  new(this.value);

  /// Ön bilgideki ve rotadaki yazımı.
  final String value;
}

/// Bilgi bankası makalesi: `assets/knowledge/<dil>/<id>.md` dosyası ya da
/// indirilen paketteki karşılığı. Meta veri dosyanın başındaki ön bilgiden
/// (`---` arası) gelir, [body] Markdown.
@freezed
abstract class KnowledgeArticle with _$KnowledgeArticle {
  const factory({
    required String id,

    /// Dosyanın klasörü (`tr`, `en`).
    required String language,
    required KnowledgeRegion region,
    required KnowledgeCategory category,
    required String title,
    required String summary,
    required String body,

    /// Makalenin ait olduğu aylar (1–12), Kuzey yarımküreye göre; Güney'de
    /// 6 ay kaydırılarak eşlenir.
    @Default([]) List<int> months,
  }) = _KnowledgeArticle;
}

/// Bir içerik sürümünün bütün makaleleri.
@freezed
abstract class KnowledgeLibrary with _$KnowledgeLibrary {
  const factory({
    required int version,
    required List<KnowledgeArticle> articles,
  }) = _KnowledgeLibrary;
}

/// Storage'daki `manifest.json`: en son paketin sürümü, yolu ve SHA-256
/// özeti (küçük harf hex).
@freezed
abstract class KnowledgeManifest with _$KnowledgeManifest {
  const factory({
    required int format,
    required int version,
    required String path,
    required String sha256,
  }) = _KnowledgeManifest;
}
