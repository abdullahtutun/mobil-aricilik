import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:mobil_arici/core/utils/csv.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';

/// ZIP'e girecek belge: kaydı, ekranda görünen tür adı ve dosyanın baytları.
typedef ArchivedDocument = ({
  VaultDocument document,
  String typeLabel,
  Uint8List bytes,
});

/// Belge listesinin başlıkları ve adı, uygulamanın dilinde.
typedef DocumentArchiveLabels = ({
  String indexName,
  String file,
  String name,
  String type,
  String expires,
  String description,
  String csvSeparator,
});

/// Belge dosyalarını tek ZIP'e yazar: her dosya belgenin adıyla
/// (`Sağlık raporu.pdf`; aynı ad ikinciyse `Sağlık raporu (2).pdf`) ve hangi
/// dosyanın hangi belge olduğunu yazan CSV liste. Belge dosyaları telefonda
/// kaldığı için telefon değişirken yedek budur. Geri yüklenmez.
Uint8List encodeDocumentArchive(
  List<ArchivedDocument> documents,
  DocumentArchiveLabels labels,
) {
  final archive = Archive();
  final used = <String>{};
  final rows = <List<String>>[
    [labels.file, labels.name, labels.type, labels.expires, labels.description],
  ];
  for (final (:document, :typeLabel, :bytes) in documents) {
    final name = _uniqueName(document.name, document.fileKind.extension, used);
    archive.add(ArchiveFile.bytes(name, bytes));
    rows.add([
      name,
      document.name,
      typeLabel,
      switch (document.expiresOn) {
        final day? => DateFormat('yyyy-MM-dd').format(day),
        null => '',
      },
      document.description ?? '',
    ]);
  }
  archive.add(
    ArchiveFile.bytes(
      csvFileName(labels.indexName),
      encodeCsv(rows, separator: labels.csvSeparator),
    ),
  );
  return ZipEncoder().encodeBytes(archive);
}

/// ZIP'in MIME türü.
const zipMimeType = 'application/zip';

/// Dosya adında sorun çıkaran karakterler tireye döner; aynı ad ikinciyse
/// sonuna sayı eklenir (büyük/küçük harf ayrımı yapmayan dosya sistemleri
/// için harf ayrımsız).
String _uniqueName(String name, String extension, Set<String> used) {
  final base = name.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-').trim();
  final safe = base.isEmpty ? '-' : base;
  var candidate = '$safe.$extension';
  for (var n = 2; !used.add(candidate.toLowerCase()); n++) {
    candidate = '$safe ($n).$extension';
  }
  return candidate;
}
