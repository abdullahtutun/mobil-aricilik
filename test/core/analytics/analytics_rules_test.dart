import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';

void main() {
  group('sanitizeAnalyticsProps', () {
    test('sayı, evet/hayır ve enum biçimindeki kısa metin kalır', () {
      expect(
        sanitizeAnalyticsProps({
          'duration_s': 95,
          'ratio': 0.5,
          'from_draft': true,
          'result': 'found',
          'retry_later': 'retry_later',
        }),
        {
          'duration_s': 95,
          'ratio': 0.5,
          'from_draft': true,
          'result': 'found',
          'retry_later': 'retry_later',
        },
      );
    });

    test('serbest metin, kod, kimlik ve boş değer atılır', () {
      expect(
        sanitizeAnalyticsProps({
          'name': 'Yayla Arılığı',
          'code': 'H-0042',
          'hive_id': '0190f1a2-7b7c-7cc1-8c3d-1d2e3f4a5b6c',
          'upper': 'Found',
          'empty': '',
          'missing': null,
          'list': [1, 2],
          'nan': double.nan,
          'infinite': double.infinity,
        }),
        isEmpty,
      );
    });

    test('anahtar küçük harf ve alt çizgi değilse atılır', () {
      expect(
        sanitizeAnalyticsProps({
          'durationS': 1,
          'duration-s': 2,
          '_private': 3,
          'ok_key': 4,
        }),
        {'ok_key': 4},
      );
    });
  });

  group('durationSeconds', () {
    test('tam saniyeye yuvarlar', () {
      expect(durationSeconds(const Duration(milliseconds: 1499)), 1);
      expect(durationSeconds(const Duration(milliseconds: 1500)), 2);
      expect(durationSeconds(const Duration(minutes: 2, seconds: 5)), 125);
    });

    test('eksi süre sıfır, çok uzun süre 24 saatte kesilir', () {
      expect(durationSeconds(const Duration(seconds: -30)), 0);
      expect(durationSeconds(const Duration(days: 3)), 24 * 60 * 60);
    });
  });

  test('olay adları sunucunun CHECK biçimine uyar', () {
    final pattern = RegExp(r'^[a-z][a-z_]{0,39}$');
    for (final event in AnalyticsEvent.values) {
      expect(event.value, matches(pattern), reason: event.name);
    }
  });
}
