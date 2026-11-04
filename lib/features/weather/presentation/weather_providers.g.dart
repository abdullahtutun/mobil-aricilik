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

/// Arılığın il/ilçesi ("Ula, Muğla"): saklanan hava paketindeki yer adı ve
/// bölge. Konumsuz arılıkta, paket henüz alınmadıysa ya da sağlayıcı yer adı
/// vermediyse null.

@ProviderFor(apiaryPlace)
final apiaryPlaceProvider = ApiaryPlaceFamily._();

/// Arılığın il/ilçesi ("Ula, Muğla"): saklanan hava paketindeki yer adı ve
/// bölge. Konumsuz arılıkta, paket henüz alınmadıysa ya da sağlayıcı yer adı
/// vermediyse null.

final class ApiaryPlaceProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Arılığın il/ilçesi ("Ula, Muğla"): saklanan hava paketindeki yer adı ve
  /// bölge. Konumsuz arılıkta, paket henüz alınmadıysa ya da sağlayıcı yer adı
  /// vermediyse null.
  ApiaryPlaceProvider._({
    required ApiaryPlaceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryPlaceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryPlaceHash();

  @override
  String toString() {
    return r'apiaryPlaceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as String;
    return apiaryPlace(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryPlaceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryPlaceHash() => r'0ac5c5416df0e33a4155483ceee25cf91575c3ee';

/// Arılığın il/ilçesi ("Ula, Muğla"): saklanan hava paketindeki yer adı ve
/// bölge. Konumsuz arılıkta, paket henüz alınmadıysa ya da sağlayıcı yer adı
/// vermediyse null.

final class ApiaryPlaceFamily extends $Family
    with $FunctionalFamilyOverride<String?, String> {
  ApiaryPlaceFamily._()
    : super(
        retry: null,
        name: r'apiaryPlaceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılığın il/ilçesi ("Ula, Muğla"): saklanan hava paketindeki yer adı ve
  /// bölge. Konumsuz arılıkta, paket henüz alınmadıysa ya da sağlayıcı yer adı
  /// vermediyse null.

  ApiaryPlaceProvider call(String apiaryId) =>
      ApiaryPlaceProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryPlaceProvider';
}

/// Konumu girilmemiş arılıklar, arılık sırasıyla. Bunların havası olmaz;
/// Bugün'deki şeritte "konum ekle" kartı olarak görünürler.

@ProviderFor(unlocatedApiaries)
final unlocatedApiariesProvider = UnlocatedApiariesProvider._();

/// Konumu girilmemiş arılıklar, arılık sırasıyla. Bunların havası olmaz;
/// Bugün'deki şeritte "konum ekle" kartı olarak görünürler.

final class UnlocatedApiariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Apiary>>,
          List<Apiary>,
          FutureOr<List<Apiary>>
        >
    with $FutureModifier<List<Apiary>>, $FutureProvider<List<Apiary>> {
  /// Konumu girilmemiş arılıklar, arılık sırasıyla. Bunların havası olmaz;
  /// Bugün'deki şeritte "konum ekle" kartı olarak görünürler.
  UnlocatedApiariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlocatedApiariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlocatedApiariesHash();

  @$internal
  @override
  $FutureProviderElement<List<Apiary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Apiary>> create(Ref ref) {
    return unlocatedApiaries(ref);
  }
}

String _$unlocatedApiariesHash() => r'35815fea559beef42b1599c0217b064661eddda9';

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

String _$apiaryWeatherHash() => r'442d9eaff26f04403bd96687284c9e579b785ae1';

/// Arılık silinmişse ya da yoksa null.

@ProviderFor(apiaryWeatherDetail)
final apiaryWeatherDetailProvider = ApiaryWeatherDetailFamily._();

/// Arılık silinmişse ya da yoksa null.

final class ApiaryWeatherDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiaryWeatherDetail?>,
          ApiaryWeatherDetail?,
          FutureOr<ApiaryWeatherDetail?>
        >
    with
        $FutureModifier<ApiaryWeatherDetail?>,
        $FutureProvider<ApiaryWeatherDetail?> {
  /// Arılık silinmişse ya da yoksa null.
  ApiaryWeatherDetailProvider._({
    required ApiaryWeatherDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryWeatherDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryWeatherDetailHash();

  @override
  String toString() {
    return r'apiaryWeatherDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ApiaryWeatherDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiaryWeatherDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryWeatherDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryWeatherDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryWeatherDetailHash() =>
    r'f6de24e9e138e055164b329341e99984b7116c58';

/// Arılık silinmişse ya da yoksa null.

final class ApiaryWeatherDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ApiaryWeatherDetail?>, String> {
  ApiaryWeatherDetailFamily._()
    : super(
        retry: null,
        name: r'apiaryWeatherDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılık silinmişse ya da yoksa null.

  ApiaryWeatherDetailProvider call(String apiaryId) =>
      ApiaryWeatherDetailProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryWeatherDetailProvider';
}

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
