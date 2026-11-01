import 'dart:io';

import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/receipt_file_store_provider.dart';

/// Cihazsız fiş klasörü: geçici klasörde fiş fotoğrafları. Dosyalar
/// eşzamanlı yazılır; widget testlerinin sahte zamanında asenkron dosya
/// işlemi bitmez.
class FakeReceipts {
  new() : directory = Directory.systemTemp.createTempSync('fake_receipts') {
    addTearDown(() => directory.deleteSync(recursive: true));
  }

  final Directory directory;
  late final store = MediaFileStore(Future.value(directory));

  /// Fiş klasöründeki dosya adları.
  List<String> get fileNames => [
    for (final file in directory.listSync().whereType<File>())
      file.uri.pathSegments.last,
  ]..sort();

  List<Override> get overrides => [
    receiptFileStoreProvider.overrideWithValue(store),
  ];
}
