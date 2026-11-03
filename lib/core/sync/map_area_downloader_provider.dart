import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/sync/map_area_downloader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_area_downloader_provider.g.dart';

/// Uygulamadaki tek harita alanı indiricisi; testler sahte HTTP ile
/// override eder.
@Riverpod(keepAlive: true)
MapAreaDownloader mapAreaDownloader(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return MapAreaDownloader(client);
}
