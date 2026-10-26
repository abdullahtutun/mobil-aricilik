import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/weather/data/weather_repository.dart';
import 'package:mobil_arici/features/weather/data/weather_service.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_providers.g.dart';

@Riverpod(keepAlive: true)
WeatherService weatherService(Ref ref) =>
    SupabaseWeatherService(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(Ref ref) =>
    WeatherRepository(ref.watch(appDatabaseProvider));

/// Telefonda saklanan son paket.
@riverpod
Stream<WeatherBundle?> weatherBundle(Ref ref) =>
    ref.watch(weatherRepositoryProvider).watchBundle();

/// Bir arılığın şu anki saatinin havası. `advice` sıcaklık, rüzgar ya da
/// yağış eksikse null.
typedef ApiaryWeather = ({
  Apiary apiary,
  HourlyWeather hour,
  HiveOpeningAdvice? advice,
});

/// Saklanan paketten, arılık sırasıyla, şu anki saatin havası. Pakette
/// olmayan, silinmiş ya da tahmin aralığı geçmiş arılık yer almaz.
@riverpod
Future<List<ApiaryWeather>> apiaryWeather(Ref ref) async {
  final summaries = await ref.watch(apiaryListProvider.future);
  final bundle = await ref.watch(weatherBundleProvider.future);
  if (bundle == null) return const [];
  final forecasts = {for (final f in bundle.forecasts) f.apiaryId: f.forecast};
  final now = clock.now();
  return [
    for (final summary in summaries)
      if (forecasts[summary.apiary.id] case final forecast?)
        if (forecastHourAt(forecast, now) case final hour?)
          (apiary: summary.apiary, hour: hour, advice: hourOpeningAdvice(hour)),
  ];
}

/// Paketi gerekince sunucudan yeniler ([weatherNeedsRefresh]). Ağ yoksa ya
/// da sunucu hata verirse saklanan paket kalır; hata ekrana taşınmaz.
@Riverpod(keepAlive: true)
WeatherRefresher weatherRefresher(Ref ref) => WeatherRefresher(ref);

class WeatherRefresher {
  new(this._ref);

  final Ref _ref;
  Future<void>? _running;

  /// Süren bir yenileme varsa onu bekler.
  Future<void> refreshIfStale() =>
      _running ??= _refresh().whenComplete(() => _running = null);

  Future<void> _refresh() async {
    final orgId = _ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    final repository = _ref.read(weatherRepositoryProvider);
    final needsRefresh = weatherNeedsRefresh(
      bundle: await repository.readBundle(),
      now: clock.now(),
      locatedApiaryIds: await _ref
          .read(apiaryRepositoryProvider)
          .locatedIds(orgId),
    );
    if (!needsRefresh) return;
    try {
      final bundle = await _ref.read(weatherServiceProvider).fetchBundle();
      await repository.saveBundle(bundle);
    } on WeatherServiceException {
      // Çevrimdışı ya da sunucu hatası: saklanan paket gösterilir.
    }
  }
}
