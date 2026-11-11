import 'dart:typed_data';

/// Sunucudaki dosya deposu (medya, belge, fiş, logo, görüş ekran görüntüsü,
/// bilgi bankası). Telefondaki dosyalar `MediaFileStore`'da; bu arayüz
/// yalnız sunucuya yükler ve oradan indirir. Kuyruk, geri çekilme ve Wi‑Fi
/// şartı çağıranlardadır.
///
/// Hatalar [FileStoreException] olarak gelir; sınıflanamayan başka bir
/// [Exception] (bağlantı, zaman aşımı) çağıranlarca geçici sayılır.
abstract interface class FileStore {
  /// [bytes]'ı [bucket]'ta [path]'e yükler. Aynı yolda dosya zaten varsa
  /// (önceki denemenin yanıtı yolda kalmış) [FileUploadResult.alreadyExists]
  /// döner; dosyalar değişmez, üstüne yazılmaz.
  Future<FileUploadResult> upload(
    String bucket,
    String path,
    Uint8List bytes, {
    required String contentType,
  });

  /// [bucket]'taki [path] dosyasının baytları. Dosya yoksa (henüz
  /// yüklenmemiş) [FileStoreFailure.notFound].
  Future<Uint8List> download(String bucket, String path);
}

enum FileUploadResult {
  uploaded,

  /// Aynı yolda dosya zaten vardı.
  alreadyExists,
}

enum FileStoreFailure {
  /// Ağ, oturum yenileme, istek sınırı ya da sunucu hatası; sonra yeniden
  /// denenir.
  transient,

  /// İndirilecek dosya sunucuda yok.
  notFound,

  /// Yetki yok, dosya çok büyük ya da türü kabul edilmiyor; yeniden denemek
  /// işe yaramaz.
  permanent,
}

class FileStoreException implements Exception {
  const new(this.failure, this.message);

  final FileStoreFailure failure;

  /// Kuyruk satırının `last_error`'ına yazılır.
  final String message;

  @override
  String toString() => 'FileStoreException(${failure.name}): $message';
}
