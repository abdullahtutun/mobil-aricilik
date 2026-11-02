// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [year] sezonunun raporu ([seasonReport]); yerel DB'deki kayıtlardan,
/// ekranın açıldığı ana kadar. Rapor bir anın dökümüdür, kayıt değişince
/// kendiliğinden yenilenmez. İşletme yoksa null.

@ProviderFor(seasonReportData)
final seasonReportDataProvider = SeasonReportDataFamily._();

/// [year] sezonunun raporu ([seasonReport]); yerel DB'deki kayıtlardan,
/// ekranın açıldığı ana kadar. Rapor bir anın dökümüdür, kayıt değişince
/// kendiliğinden yenilenmez. İşletme yoksa null.

final class SeasonReportDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeasonReport?>,
          SeasonReport?,
          FutureOr<SeasonReport?>
        >
    with $FutureModifier<SeasonReport?>, $FutureProvider<SeasonReport?> {
  /// [year] sezonunun raporu ([seasonReport]); yerel DB'deki kayıtlardan,
  /// ekranın açıldığı ana kadar. Rapor bir anın dökümüdür, kayıt değişince
  /// kendiliğinden yenilenmez. İşletme yoksa null.
  SeasonReportDataProvider._({
    required SeasonReportDataFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'seasonReportDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seasonReportDataHash();

  @override
  String toString() {
    return r'seasonReportDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SeasonReport?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SeasonReport?> create(Ref ref) {
    final argument = this.argument as int;
    return seasonReportData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeasonReportDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seasonReportDataHash() => r'f726a99f619196a1fa00034fad3f9bdfddf88d7c';

/// [year] sezonunun raporu ([seasonReport]); yerel DB'deki kayıtlardan,
/// ekranın açıldığı ana kadar. Rapor bir anın dökümüdür, kayıt değişince
/// kendiliğinden yenilenmez. İşletme yoksa null.

final class SeasonReportDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SeasonReport?>, int> {
  SeasonReportDataFamily._()
    : super(
        retry: null,
        name: r'seasonReportDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [year] sezonunun raporu ([seasonReport]); yerel DB'deki kayıtlardan,
  /// ekranın açıldığı ana kadar. Rapor bir anın dökümüdür, kayıt değişince
  /// kendiliğinden yenilenmez. İşletme yoksa null.

  SeasonReportDataProvider call(int year) =>
      SeasonReportDataProvider._(argument: year, from: this);

  @override
  String toString() => r'seasonReportDataProvider';
}

/// [year] sezonunun maliyet ve kârı (Finans'ın sezon özeti); kovan başı
/// maliyet sezon sonundaki aktif kovanlara göre. Finansı göremeyen rolde
/// (worker, viewer) ya da işletme yüklenmediyse null.

@ProviderFor(seasonFinance)
final seasonFinanceProvider = SeasonFinanceFamily._();

/// [year] sezonunun maliyet ve kârı (Finans'ın sezon özeti); kovan başı
/// maliyet sezon sonundaki aktif kovanlara göre. Finansı göremeyen rolde
/// (worker, viewer) ya da işletme yüklenmediyse null.

final class SeasonFinanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeasonSummary?>,
          SeasonSummary?,
          FutureOr<SeasonSummary?>
        >
    with $FutureModifier<SeasonSummary?>, $FutureProvider<SeasonSummary?> {
  /// [year] sezonunun maliyet ve kârı (Finans'ın sezon özeti); kovan başı
  /// maliyet sezon sonundaki aktif kovanlara göre. Finansı göremeyen rolde
  /// (worker, viewer) ya da işletme yüklenmediyse null.
  SeasonFinanceProvider._({
    required SeasonFinanceFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'seasonFinanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seasonFinanceHash();

  @override
  String toString() {
    return r'seasonFinanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SeasonSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SeasonSummary?> create(Ref ref) {
    final argument = this.argument as int;
    return seasonFinance(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeasonFinanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seasonFinanceHash() => r'0eef6680f249d9afb5a30abdd7ba465689f44db2';

/// [year] sezonunun maliyet ve kârı (Finans'ın sezon özeti); kovan başı
/// maliyet sezon sonundaki aktif kovanlara göre. Finansı göremeyen rolde
/// (worker, viewer) ya da işletme yüklenmediyse null.

final class SeasonFinanceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SeasonSummary?>, int> {
  SeasonFinanceFamily._()
    : super(
        retry: null,
        name: r'seasonFinanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [year] sezonunun maliyet ve kârı (Finans'ın sezon özeti); kovan başı
  /// maliyet sezon sonundaki aktif kovanlara göre. Finansı göremeyen rolde
  /// (worker, viewer) ya da işletme yüklenmediyse null.

  SeasonFinanceProvider call(int year) =>
      SeasonFinanceProvider._(argument: year, from: this);

  @override
  String toString() => r'seasonFinanceProvider';
}
