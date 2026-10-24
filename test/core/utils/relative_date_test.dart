import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/relative_date.dart';

void main() {
  setUpAll(() => initializeDateFormatting('tr'));

  final tr = lookupAppLocalizations(const Locale('tr'));
  final en = lookupAppLocalizations(const Locale('en'));
  const format = AppFormat('tr');
  final now = DateTime(2026, 10, 24, 9, 30);

  String day(DateTime at, {AppLocalizations? l10n}) =>
      relativeDay(l10n ?? tr, format, at, now: now);

  test('aynı gün bugün; saat farkı önemsiz', () {
    expect(day(DateTime(2026, 10, 24)), 'bugün');
    expect(day(DateTime(2026, 10, 24, 23, 59)), 'bugün');
  });

  test('takvimde önceki gün dün; 24 saat dolmasa da', () {
    expect(day(DateTime(2026, 10, 23, 23, 59)), 'dün');
    expect(day(DateTime(2026, 10, 23)), 'dün');
  });

  test('2–6 gün önce sayıyla, 7 gün ve öncesi tarihle', () {
    expect(day(DateTime(2026, 10, 22)), '2 gün önce');
    expect(day(DateTime(2026, 10, 18)), '6 gün önce');
    expect(day(DateTime(2026, 10, 17)), '17 Eki 2026');
  });

  test('gelecekteki an bugün sayılır', () {
    expect(day(DateTime(2026, 10, 26)), 'bugün');
  });

  test('UTC an yerel güne çevrilir', () {
    final utc = DateTime(2026, 10, 22, 12).toUtc();
    expect(day(utc), '2 gün önce');
  });

  test('İngilizcede tekil ve çoğul', () {
    expect(day(DateTime(2026, 10, 23), l10n: en), 'yesterday');
    expect(day(DateTime(2026, 10, 21), l10n: en), '3 days ago');
  });
}
