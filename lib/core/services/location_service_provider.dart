import 'package:mobil_arici/core/services/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service_provider.g.dart';

/// Testler sahte konumla override eder.
@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => const GeolocatorLocationService();
