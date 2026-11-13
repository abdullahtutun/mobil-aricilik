import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:pocketbase/pocketbase.dart';

/// [FileStore]'un PocketBase uygulaması: her bucket bir dosya koleksiyonu,
/// her dosya bir kayıt (K-13, `server/internal/files`). Kaydın `id`'si yolun
/// son UUID'si, `org_id`'si yolun ilk klasörü, `path`'i yolun kendisi.
/// Bilgi bankası `knowledge_packs`'te, kaydın adı yol (`manifest.json`,
/// `knowledge-v<N>.json`).
///
/// Oturumun token'ı süresi dolmuşsa istek atılmaz ve hata geçicidir: SDK
/// süresi dolmuş token'ı göndermez, sunucu da girişsiz yüklemeyi kural reddi
/// (kalıcı) sayardı. Token senkron turunun başında yenilenir (K-6).
class PocketBaseFileStore implements FileStore {
  new(this._client, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final PocketBase _client;
  final DateTime Function() _clock;

  /// Bucket → dosya koleksiyonu (`server/internal/files.Specs`). Lot
  /// sayfasının `public-lots`'u uygulamadan kullanılmaz.
  static const collections = {
    'media': 'media_files',
    'documents': 'document_files',
    'receipts': 'receipt_files',
    'feedback': 'feedback_files',
    'org-logos': 'org_logo_files',
  };

  /// Bilgi bankası paketlerinin bucket'ı ve koleksiyonu (P6.2).
  static const knowledgeBucket = 'knowledge';
  static const knowledgeCollection = 'knowledge_packs';

  /// Aynı id ile ikinci yüklemede `data.id.code` (P6.1). Yalnız bu kod
  /// "zaten yüklendi"; `data`'sı boş 400 kural reddidir.
  static const alreadyExistsCode = 'validation_pk_invalid';

  /// Dosya token'ının yeniden kullanıldığı süre. Sunucu 3 dk geçerli
  /// token verir; dosya isteği sürerken dolmasın diye daha kısa.
  static const fileTokenLifetime = Duration(minutes: 1);

  /// Yanıtı geçici olan durumlar; aynı istek sonra yeniden denenir. 401
  /// süresi dolmuş ya da sunucuda kapatılmış oturum: senkron turu yeniler ya
  /// da kapatır, dosya kuyruğu bekler.
  static bool isTransientStatus(int status) =>
      status == 0 ||
      status == 401 ||
      status == 408 ||
      status == 429 ||
      status >= 500;

  ({String token, String auth, DateTime at})? _fileToken;

  @override
  Future<FileUploadResult> upload(
    String bucket,
    String path,
    Uint8List bytes, {
    required String contentType,
  }) async {
    final collection = _collectionOf(bucket);
    final segments = path.split('/');
    final name = segments.last;
    final dot = name.lastIndexOf('.');
    _requireSession();
    try {
      // Tür sunucuda içerikten bulunur; gönderilen tür bakılmaz.
      await _client
          .collection(collection)
          .create(
            body: {
              'id': dot < 0 ? name : name.substring(0, dot),
              'org_id': segments.first,
              'path': path,
            },
            files: [
              http.MultipartFile.fromBytes('file', bytes, filename: name),
            ],
          );
    } on ClientException catch (error) {
      if (_isAlreadyExists(error)) return FileUploadResult.alreadyExists;
      throw _classify(error);
    }
    return FileUploadResult.uploaded;
  }

  @override
  Future<Uint8List> download(String bucket, String path) async {
    final knowledge = bucket == knowledgeBucket;
    final collection = knowledge ? knowledgeCollection : _collectionOf(bucket);
    _requireSession();
    final RecordModel record;
    try {
      final page = await _client
          .collection(collection)
          .getList(
            perPage: 1,
            skipTotal: true,
            filter: _client.filter(
              knowledge ? 'name = {:path}' : 'path = {:path}',
              {'path': path},
            ),
          );
      // Kaydı yok ya da okuma kuralı göstermiyor (ör. worker fişi).
      if (page.items.isEmpty) {
        throw FileStoreException(FileStoreFailure.notFound, '404: $path');
      }
      record = page.items.single;
    } on ClientException catch (error) {
      throw _classify(error);
    }
    final fileName = record.getStringValue('file');
    if (fileName.isEmpty) {
      throw FileStoreException(FileStoreFailure.notFound, '404: $path');
    }
    // Bilgi bankası dosyası korumalı değil, token istemez.
    if (knowledge) return await _fetch(record, fileName, null);
    final cached = _cachedFileToken();
    final fresh = cached ?? await _newFileToken();
    try {
      return await _fetch(record, fileName, fresh);
    } on FileStoreException catch (error) {
      // Önbellekteki token sunucuda geçersizleşmiş olabilir (korumalı
      // dosya token'sız 404 döner); yenisiyle bir kez daha.
      if (cached == null || error.failure != FileStoreFailure.notFound) {
        rethrow;
      }
      _fileToken = null;
      return await _fetch(record, fileName, await _newFileToken());
    }
  }

  Future<Uint8List> _fetch(
    RecordModel record,
    String fileName,
    String? token,
  ) async {
    final url = _client.files.getURL(record, fileName, token: token);
    final http.Response response;
    final httpClient = _client.httpClientFactory();
    try {
      response = await httpClient.get(url);
    } on Exception catch (error) {
      throw FileStoreException(FileStoreFailure.transient, '$error');
    } finally {
      httpClient.close();
    }
    final status = response.statusCode;
    if (status == 200) return response.bodyBytes;
    throw FileStoreException(switch (status) {
      // Dosya yok ya da token'ı geçersiz.
      404 => FileStoreFailure.notFound,
      _ when isTransientStatus(status) => FileStoreFailure.transient,
      _ => FileStoreFailure.permanent,
    }, '$status: ${record.collectionName}/${record.id}');
  }

  String? _cachedFileToken() {
    final cached = _fileToken;
    if (cached == null ||
        cached.auth != _client.authStore.token ||
        _clock().difference(cached.at) >= fileTokenLifetime) {
      return null;
    }
    return cached.token;
  }

  Future<String> _newFileToken() async {
    final auth = _client.authStore.token;
    final at = _clock();
    final String token;
    try {
      token = await _client.files.getToken();
    } on ClientException catch (error) {
      throw _classify(error);
    }
    _fileToken = (token: token, auth: auth, at: at);
    return token;
  }

  /// Süresi dolmuş ya da olmayan oturum geçici: tur başındaki yenileme
  /// düzeltir, düzeltmezse senkron oturumu kapatır.
  void _requireSession() {
    if (!_client.authStore.isValid) {
      throw const FileStoreException(
        FileStoreFailure.transient,
        'oturum yok ya da süresi dolmuş',
      );
    }
  }

  static String _collectionOf(String bucket) =>
      collections[bucket] ??
      (throw FileStoreException(
        FileStoreFailure.permanent,
        'bilinmeyen bucket: $bucket',
      ));

  static bool _isAlreadyExists(ClientException error) =>
      error.statusCode == 400 &&
      switch (error.response['data']) {
        {'id': {'code': alreadyExistsCode}} => true,
        _ => false,
      };

  /// Durum kodu 0 yanıt yok demek (bağlantı hatası); geçici. Boyut ve tür
  /// (400 `validation_file_size_limit` / `validation_invalid_mime_type`,
  /// gövde sınırında 413), yanlış yol, kural reddi (400, `data` boş) ve
  /// yetki (403) kalıcı.
  static FileStoreException _classify(ClientException error) {
    final status = error.statusCode;
    final message = switch (error.response['message']) {
      final String text when text.isNotEmpty =>
        '$status: $text ${_codes(error)}',
      _ => '$status: ${error.originalError ?? error.url}',
    };
    return FileStoreException(
      isTransientStatus(status)
          ? FileStoreFailure.transient
          : FileStoreFailure.permanent,
      message.trimRight(),
    );
  }

  /// Alan hatalarının kodları (`data.<alan>.code`); `last_error`'da
  /// nedeni görünsün.
  static String _codes(ClientException error) =>
      switch (error.response['data']) {
        final Map<String, dynamic> data => [
          for (final MapEntry(:key, :value) in data.entries)
            if (value case {'code': final String code}) '$key=$code',
        ].join(' '),
        _ => '',
      };
}
