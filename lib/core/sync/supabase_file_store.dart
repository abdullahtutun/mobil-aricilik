import 'dart:typed_data';

import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [FileStore]'un Supabase uygulaması: Storage bucket'ları.
class SupabaseFileStore implements FileStore {
  const new(this._client);

  final SupabaseClient _client;

  @override
  Future<FileUploadResult> upload(
    String bucket,
    String path,
    Uint8List bytes, {
    required String contentType,
  }) async {
    try {
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: contentType),
            retryAttempts: 0,
          );
    } on StorageException catch (error) {
      // Aynı yola ikinci yükleme.
      if (error.statusCode == '409') return FileUploadResult.alreadyExists;
      if (_isTransient(error.statusCode)) {
        throw FileStoreException(FileStoreFailure.transient, error.message);
      }
      throw FileStoreException(
        FileStoreFailure.permanent,
        '${error.statusCode}: ${error.message}',
      );
    }
    return FileUploadResult.uploaded;
  }

  @override
  Future<Uint8List> download(String bucket, String path) async {
    try {
      return await _client.storage.from(bucket).download(path);
    } on StorageException catch (error) {
      throw FileStoreException(switch (error.statusCode) {
        // Henüz yüklenmemiş.
        '400' || '404' => FileStoreFailure.notFound,
        final status when _isTransient(status) => FileStoreFailure.transient,
        _ => FileStoreFailure.permanent,
      }, '${error.statusCode}: ${error.message}');
    }
  }

  /// HTTP durumu olmayan hata (bağlantı; storage_client türün adını yazar),
  /// süresi dolmuş oturum, zaman aşımı, istek sınırı ve sunucu hataları.
  static bool _isTransient(String? statusCode) {
    final status = int.tryParse(statusCode ?? '');
    return status == null ||
        status == 401 ||
        status == 408 ||
        status == 429 ||
        status >= 500;
  }
}
