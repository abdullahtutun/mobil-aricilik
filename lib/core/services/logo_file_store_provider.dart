import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logo_file_store_provider.g.dart';

/// İşletme logoları (uygulama klasöründe `logos/`). Testler geçici
/// klasörle override eder.
@Riverpod(keepAlive: true)
MediaFileStore logoFileStore(Ref ref) => MediaFileStore.app('logos');
