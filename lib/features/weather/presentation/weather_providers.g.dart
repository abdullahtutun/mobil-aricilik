// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weatherService)
final weatherServiceProvider = WeatherServiceProvider._();

final class WeatherServiceProvider
    extends $FunctionalProvider<WeatherService, WeatherService, WeatherService>
    with $Provider<WeatherService> {
  WeatherServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherServiceHash();

  @$internal
  @override
  $ProviderElement<WeatherService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeatherService create(Ref ref) {
    return weatherService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherService>(value),
    );
  }
}

String _$weatherServiceHash() => r'91dc7c17f30c86acd0a19e4b372a19b6aa2ff50c';

@ProviderFor(weatherRepository)
final weatherRepositoryProvider = WeatherRepositoryProvider._();

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'a441565637b498f125339103259f9556d5a65d52';

/// Telefonda saklanan son paket.

@ProviderFor(weatherBundle)
final weatherBundleProvider = WeatherBundleProvider._();

/// Telefonda saklanan son paket.

final class WeatherBundleProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeatherBundle?>,
          WeatherBundle?,
          Stream<WeatherBundle?>
        >
    with $FutureModifier<WeatherBundle?>, $StreamProvider<WeatherBundle?> {
  /// Telefonda saklanan son paket.
  WeatherBundleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherBundleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherBundleHash();

  @$internal
  @override
  $StreamProviderElement<WeatherBundle?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WeatherBundle?> create(Ref ref) {
    return weatherBundle(ref);
  }
}

String _$weatherBundleHash() => r'1dded6e8078d6d74d378649b0051f7c1c041db46';

/// Saklanan paketten, arılık sırasıyla, şu anki saatin havası. Pakette
/// olmayan, silinmiş ya da tahmin aralığı geçmiş arılık yer almaz.

@ProviderFor(apiaryWeather)
final apiaryWeatherProvider = ApiaryWeatherProvider._();

/// Saklanan paketten, arılık sırasıyla, şu anki saatin havası. Pakette
/// olmayan, silinmiş ya da tahmin aralığı geçmiş arılık yer almaz.

final class ApiaryWeatherProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApiaryWeather>>,
          List<ApiaryWeather>,
          FutureOr<List<ApiaryWeather>>
        >
    with
        $FutureModifier<List<ApiaryWeather>>,
        $FutureProvider<List<ApiaryWeather>> {
  /// Saklanan paketten, arılık sırasıyla, şu anki saatin havası. Pakette
  /// olmayan, silinmiş ya da tahmin aralığı geçmiş arılık yer almaz.
  ApiaryWeatherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiaryWeatherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiaryWeatherHash();

  @$internal
  @override
  $FutureProviderElement<List<ApiaryWeather>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ApiaryWeather>> create(Ref ref) {
    return apiaryWeather(ref);
  }
}

String _$apiaryWeatherHash() => r'd709328adc72ce1543624fedb689c70feb8fc6c3';

/// Paketi gerekince sunucudan yeniler ([weatherNeedsRefresh]). Ağ yoksa ya
/// da sunucu hata verirse saklanan paket kalır; hata ekrana taşınmaz.

@ProviderFor(weatherRefresher)
final weatherRefresherProvider = WeatherRefresherProvider._();

/// Paketi gerekince sunucudan yeniler ([weatherNeedsRefresh]). Ağ yoksa ya
/// da sunucu hata verirse saklanan paket kalır; hata ekrana taşınmaz.

final class WeatherRefresherProvider
    extends
        $FunctionalProvider<
          WeatherRefresher,
          WeatherRefresher,
          WeatherRefresher
        >
    with $Provider<WeatherRefresher> {
  /// Paketi gerekince sunucudan yeniler ([weatherNeedsRefresh]). Ağ yoksa ya
  /// da sunucu hata verirse saklanan paket kalır; hata ekrana taşınmaz.
  WeatherRefresherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRefresherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRefresherHash();

  @$internal
  @override
  $ProviderElement<WeatherRefresher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeatherRefresher create(Ref ref) {
    return weatherRefresher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRefresher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRefresher>(value),
    );
  }
}

String _$weatherRefresherHash() => r'8ac852dcf5ca183999e9a94c79421ffce490c6cf';
