import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:pocketbase/pocketbase.dart';

/// Lot sayfasının istediği analiz raporu: `documentId` sayfanın göstereceği
/// belge (lot yayımda değilse, rapor alanı kapalıysa ya da belgeli analiz
/// yoksa null), `uploaded` dosyası sunucuda mı.
typedef LotReportStatus = ({String? documentId, bool uploaded});

/// Yayımdaki lotun analiz raporunu lot sayfasına yükler
/// (`server/internal/lotpage/upload.go`). Belge dosyaları telefonda kalır;
/// sunucuya giden tek belge dosyası budur. Hatalar
/// [PocketBaseApiException] olarak gelir (409 `not_current`: telefonun
/// satırları geride).
abstract interface class LotReportApi {
  Future<LotReportStatus> status(String lotId);

  Future<void> upload({
    required String lotId,
    required String documentId,
    required Uint8List bytes,
    required String fileName,
  });
}

/// [LotReportApi]'nin PocketBase uygulaması:
/// `GET|POST /api/app/lots/{id}/report`.
class PocketBaseLotReportApi implements LotReportApi {
  const new(this._client, {this.timeout = uploadTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; 20 MB'lık PDF yavaş bağlantıda da gitsin.
  final Duration timeout;

  static const uploadTimeout = Duration(seconds: 120);

  static String pathOf(String lotId) => '/api/app/lots/$lotId/report';

  @override
  Future<LotReportStatus> status(String lotId) async {
    final response = await sendPocketBaseAppRequest(
      _client,
      pathOf(lotId),
      method: 'GET',
      timeout: timeout,
    );
    return switch (response) {
      {'document_id': final String? id, 'uploaded': final bool uploaded} => (
        documentId: id,
        uploaded: uploaded,
      ),
      _ => throw const PocketBaseApiException(500, code: 'bad_response'),
    };
  }

  @override
  Future<void> upload({
    required String lotId,
    required String documentId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await sendPocketBaseAppRequest(
      _client,
      pathOf(lotId),
      body: {'document_id': documentId},
      files: [http.MultipartFile.fromBytes('file', bytes, filename: fileName)],
      timeout: timeout,
    );
  }
}
