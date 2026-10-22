import 'package:mobil_arici/app/routes.dart';

/// Uygulamanın derin link şeması. AndroidManifest ve Info.plist'te de aynı
/// şema kayıtlı.
const deepLinkScheme = 'mobilarici';

/// Derin linki router konumuna çevirir: `mobilarici://hives/42?tab=1` →
/// `/hives/42?tab=1`. Platform linki olduğu gibi verir; host ilk yol parçası
/// sayılır. Şema bizim değilse (uygulama içi konumlar) null.
String? deepLinkLocation(Uri uri) {
  if (uri.scheme != deepLinkScheme) return null;
  final path = [
    if (uri.host.isNotEmpty) '/${uri.host}',
    if (uri.path.isNotEmpty && !uri.path.startsWith('/')) '/',
    uri.path,
  ].join();
  return Uri(
    path: path.isEmpty ? AppRoutes.today : path,
    query: uri.hasQuery ? uri.query : null,
    fragment: uri.hasFragment ? uri.fragment : null,
  ).toString();
}
