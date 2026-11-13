import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flavor.g.dart';

enum Flavor {
  dev(pocketbaseUrl: 'https://arici-api-dev.tutunsoft.com'),
  prod(pocketbaseUrl: 'https://arici-api.tutunsoft.com');

  new({required this.pocketbaseUrl});

  /// PocketBase sunucusunun kök adresi; `--dart-define=PB_URL=...` ezer.
  final String pocketbaseUrl;
}

/// `--dart-define=PB_URL=...`; boşsa flavor'ın adresi. Yerelde ör.
/// `http://127.0.0.1:8090` (iOS simülatörü), `http://10.0.2.2:8090`
/// (Android emülatörü).
const pocketbaseUrlDefine = String.fromEnvironment('PB_URL');

/// [flavor]'ın PocketBase adresi; [define] doluysa o. Sondaki `/` atılır.
String resolvePocketbaseUrl(
  Flavor flavor, {
  String define = pocketbaseUrlDefine,
}) {
  final url = define.trim().isEmpty ? flavor.pocketbaseUrl : define.trim();
  return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}

/// Çalışan flavor. `bootstrap` gerçek değerle override eder; override
/// edilmezse (ör. testlerde) geliştirici araçları kapalı kalsın diye prod.
@Riverpod(keepAlive: true)
Flavor flavor(Ref ref) => Flavor.prod;

/// PocketBase sunucusunun adresi ([resolvePocketbaseUrl]).
@Riverpod(keepAlive: true)
String pocketbaseUrl(Ref ref) =>
    resolvePocketbaseUrl(ref.watch(flavorProvider));
