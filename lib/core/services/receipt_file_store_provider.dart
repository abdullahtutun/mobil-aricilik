import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receipt_file_store_provider.g.dart';

/// Fiş fotoğrafları (uygulama klasöründe `receipts/`). Testler geçici
/// klasörle override eder.
@Riverpod(keepAlive: true)
MediaFileStore receiptFileStore(Ref ref) => MediaFileStore.app('receipts');
