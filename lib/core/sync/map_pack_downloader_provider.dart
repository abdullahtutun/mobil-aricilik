import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/map_pack_downloader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_pack_downloader_provider.g.dart';

/// Uygulamadaki tek harita paketi indiricisi; testler sahte HTTP ile
/// override eder.
@Riverpod(keepAlive: true)
MapPackDownloader mapPackDownloader(Ref ref) {
  final storage = ref
      .watch(supabaseClientProvider)
      .storage
      .from(MapPackDownloader.bucket);
  final client = http.Client();
  ref.onDispose(client.close);
  return MapPackDownloader(storage.download, client);
}
