import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_labels.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('tr'));

  test('durum kelimesi: grup adı, "diğer"de kodun türü', () {
    expect(weatherConditionLabel(l10n, 1000), 'Güneşli');
    expect(weatherConditionLabel(l10n, 1183), 'Yağmurlu');
    expect(weatherConditionLabel(l10n, 9999), 'Bulutlu');
    expect(weatherConditionLabel(l10n, null), 'Bulutlu');
    expect(weatherConditionLabel(l10n, 1030), 'Sisli');
    expect(weatherConditionLabel(l10n, 1135), 'Sisli');
    expect(weatherConditionLabel(l10n, 1087), 'Gök gürültülü');
    expect(weatherConditionLabel(l10n, 1276), 'Gök gürültülü');
    expect(weatherConditionLabel(l10n, 1204), 'Karla karışık yağmur');
    expect(weatherConditionLabel(l10n, 1213), 'Karlı');
    expect(weatherConditionLabel(l10n, 1237), 'Karlı');
  });
}
