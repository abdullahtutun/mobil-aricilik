import 'package:mobil_arici/core/services/directions_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'directions_service_provider.g.dart';

/// Testler cihazsız sahteyle override eder.
@Riverpod(keepAlive: true)
DirectionsService directionsService(Ref ref) =>
    const MapLauncherDirectionsService();
