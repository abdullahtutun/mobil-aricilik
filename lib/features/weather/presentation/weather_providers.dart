import 'package:clock/clock.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/weather/data/supabase_weather_service.dart';
import 'package:mobil_arici/features/weather/data/weather_repository.dart';
import 'package:mobil_arici/features/weather/data/weather_service.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_providers.g.dart';

@Riverpod(keepAlive: true)
WeatherService weatherService(Ref ref) => switch (ref.watch(backendProvider)) {
  Backend.supabase => SupabaseWeatherService(ref.watch(supabaseClientProvider)),
  Backend.pocketbase => throw UnimplementedError('PocketBase hava: P7.5'),
};

@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(Ref ref) =>
    WeatherRepository(ref.watch(appDatabaseProvider));

/// Telefonda saklanan son paket.
@riverpod
Stream<WeatherBundle?> weatherBundle(Ref ref) =>
    ref.watch(weatherRepositoryProvider).watchBundle();

/// Arılığın il/ilçesi ("Ula, Muğla"): saklanan hava paketindeki yer adı ve
/// bölge. Konumsuz arılıkta, paket henüz alınmadıysa ya da sağlayıcı yer adı
/// vermediyse null.
@riverpod
String? apiaryPlace(Ref ref, String apiaryId) {
  final bundle = ref.watch(weatherBundleProvider).value;
  final forecast = bundle?.forecasts
      .where((f) => f.apiaryId == apiaryId)
      .firstOrNull
      ?.forecast;
  if (forecast == null) return null;
  final place = [?forecast.place, ?forecast.region].join(', ');
  return place.isEmpty ? null : place;
}

/// Şu anki saatin havası olmayan arılıklar, arılık sırasıyla: konumu
/// girilmemiş olanlar ve konumlu olup tahmini henüz gelmemiş (ya da
/// tahmin aralığı geçmiş) olanlar. Bugün'deki şeritte kayıp olmasınlar diye
/// [apiaryWeather]'ın yanında kendi kartlarıyla görünürler.
@riverpod
Future<List<Apiary>> apiariesWithoutWeather(Ref ref) async {
  final summaries = await ref.watch(apiaryListProvider.future);
  final weather = await ref.watch(apiaryWeatherProvider.future);
  final covered = {for (final item in weather) item.apiary.id};
  return [
    for (final summary in summaries)
      if (!covered.contains(summary.apiary.id)) summary.apiary,
  ];
}

/// Bir arılığın şu anki saatinin havası. `opening` sıcaklık ya da rüzgar
/// eksikse null; `thresholds` simgenin rüzgar sınırı için.
typedef ApiaryWeather = ({
  Apiary apiary,
  HourlyWeather hour,
  HiveOpening? opening,
  HiveOpeningThresholds thresholds,
});

/// Saklanan paketten, arılık sırasıyla, şu anki saatin havası. Pakette
/// olmayan, silinmiş ya da tahmin aralığı geçmiş arılık yer almaz.
@riverpod
Future<List<ApiaryWeather>> apiaryWeather(Ref ref) async {
  final summaries = await ref.watch(apiaryListProvider.future);
  final bundle = await ref.watch(weatherBundleProvider.future);
  final thresholds = await ref.watch(hiveOpeningThresholdsProvider.future);
  if (bundle == null) return const [];
  final forecasts = {for (final f in bundle.forecasts) f.apiaryId: f.forecast};
  final now = clock.now();
  return [
    for (final summary in summaries)
      if (forecasts[summary.apiary.id] case final forecast?)
        if (forecastHourAt(forecast, now) case final hour?)
          (
            apiary: summary.apiary,
            hour: hour,
            opening: hourOpening(hour, thresholds),
            thresholds: thresholds,
          ),
  ];
}

/// "Arılık havası" ekranının verisi. `forecast` ve `generatedAt` saklanan
/// pakette arılık yoksa (ya da paket hiç yoksa) null.
typedef ApiaryWeatherDetail = ({
  Apiary apiary,
  Forecast? forecast,
  DateTime? generatedAt,
  HiveOpeningThresholds thresholds,
});

/// Arılık silinmişse ya da yoksa null.
@riverpod
Future<ApiaryWeatherDetail?> apiaryWeatherDetail(
  Ref ref,
  String apiaryId,
) async {
  final summary = await ref.watch(apiarySummaryProvider(apiaryId).future);
  final bundle = await ref.watch(weatherBundleProvider.future);
  final thresholds = await ref.watch(hiveOpeningThresholdsProvider.future);
  if (summary == null) return null;
  final forecast = bundle?.forecasts
      .where((f) => f.apiaryId == apiaryId)
      .firstOrNull;
  return (
    apiary: summary.apiary,
    forecast: forecast?.forecast,
    generatedAt: forecast == null ? null : bundle?.generatedAt,
    thresholds: thresholds,
  );
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

  /// Paketi beklemeden sunucudan ister ("Yenile"). Alınamazsa false;
  /// saklanan paket kalır.
  Future<bool> refreshNow() async {
    await _running;
    final run = _refresh(force: true);
    _running = run.then((_) {});
    try {
      return await run;
    } finally {
      _running = null;
    }
  }

  Future<bool> _refresh({bool force = false}) async {
    final orgId = _ref.read(currentOrgIdProvider);
    if (orgId == null) return false;
    final repository = _ref.read(weatherRepositoryProvider);
    final needsRefresh =
        force ||
        weatherNeedsRefresh(
          bundle: await repository.readBundle(),
          now: clock.now(),
          locatedApiaries: await _ref
              .read(apiaryRepositoryProvider)
              .locatedUpdatedAt(orgId),
        );
    if (!needsRefresh) return true;
    try {
      final bundle = await _ref.read(weatherServiceProvider).fetchBundle();
      await repository.saveBundle(bundle);
      return true;
    } on WeatherServiceException {
      // Çevrimdışı ya da sunucu hatası: saklanan paket gösterilir.
      return false;
    }
  }
}
