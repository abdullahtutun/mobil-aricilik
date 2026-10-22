import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/utils/units.dart';

const _allFeatures = RegionFeatures(
  aks: true,
  subsidies: true,
  regulations: true,
  trDrugList: true,
  trFlora: true,
  trMigrationDocs: true,
);

const _usCustomary = DefaultUnits(
  mass: MassUnit.pound,
  temperature: TemperatureUnit.fahrenheit,
  volume: VolumeUnit.gallon,
);

void main() {
  group('normalizeCountryCode', () {
    test('büyük harfe çevirir ve boşlukları kırpar', () {
      expect(normalizeCountryCode('TR'), 'TR');
      expect(normalizeCountryCode('tr'), 'TR');
      expect(normalizeCountryCode('Tr'), 'TR');
      expect(normalizeCountryCode(' us\n'), 'US');
    });

    test('biçimi doğru ama tabloda olmayan kod kabul edilir', () {
      expect(normalizeCountryCode('zz'), 'ZZ');
    });

    test('iki harf değilse ArgumentError', () {
      for (final code in ['', ' ', 'T', 'TUR', 'T1', '90', 'T R', 'çk']) {
        expect(
          () => normalizeCountryCode(code),
          throwsArgumentError,
          reason: '"$code"',
        );
      }
    });
  });

  group('Hemisphere.fromLatitude', () {
    test('pozitif enlem Kuzey, negatif enlem Güney', () {
      // Ankara, Sidney, Buenos Aires, Oslo.
      expect(Hemisphere.fromLatitude(39.93), Hemisphere.northern);
      expect(Hemisphere.fromLatitude(-33.87), Hemisphere.southern);
      expect(Hemisphere.fromLatitude(-34.6), Hemisphere.southern);
      expect(Hemisphere.fromLatitude(59.91), Hemisphere.northern);
    });

    test('ekvator Kuzey sayılır', () {
      expect(Hemisphere.fromLatitude(0), Hemisphere.northern);
      // Negatif sıfır (-0.0).
      expect(Hemisphere.fromLatitude(-0), Hemisphere.northern);
      expect(Hemisphere.fromLatitude(-0.0001), Hemisphere.southern);
    });

    test('kutuplar geçerli', () {
      expect(Hemisphere.fromLatitude(90), Hemisphere.northern);
      expect(Hemisphere.fromLatitude(-90), Hemisphere.southern);
    });

    test('-90 ile 90 dışı ve NaN ArgumentError', () {
      for (final latitude in [
        90.0001,
        -90.0001,
        180.0,
        double.nan,
        double.infinity,
        double.negativeInfinity,
      ]) {
        expect(
          () => Hemisphere.fromLatitude(latitude),
          throwsArgumentError,
          reason: '$latitude',
        );
      }
    });
  });

  group('checkLatitude', () {
    test('aralıktaki enlemde hata atmaz', () {
      for (final latitude in [-90.0, -45.5, 0.0, 41.01, 90.0]) {
        expect(() => checkLatitude(latitude), returnsNormally);
      }
    });

    test('aralık dışında ve NaN ArgumentError', () {
      expect(() => checkLatitude(91), throwsArgumentError);
      expect(() => checkLatitude(-91), throwsArgumentError);
      expect(() => checkLatitude(double.nan), throwsArgumentError);
    });
  });

  group('RegionFeatures', () {
    test('varsayılanda tüm TR modülleri kapalı', () {
      const features = RegionFeatures();

      expect(features.aks, isFalse);
      expect(features.subsidies, isFalse);
      expect(features.regulations, isFalse);
      expect(features.trDrugList, isFalse);
      expect(features.trFlora, isFalse);
      expect(features.trMigrationDocs, isFalse);
    });
  });

  group('DefaultUnits', () {
    test('varsayılanı metrik', () {
      const units = DefaultUnits();

      expect(units.mass, MassUnit.kilogram);
      expect(units.temperature, TemperatureUnit.celsius);
      expect(units.volume, VolumeUnit.liter);
    });
  });

  group('resolveRegionConfig', () {
    group('TR profili', () {
      test('TR modülleri açık, TRY, metrik, Kuzey', () {
        expect(
          resolveRegionConfig('TR'),
          const RegionConfig(
            countryCode: 'TR',
            profile: RegionProfile.tr,
            features: _allFeatures,
            currencyCode: 'TRY',
            defaultUnits: DefaultUnits(),
            hemisphere: Hemisphere.northern,
          ),
        );
      });

      test('küçük harfli kod da TR profilini açar', () {
        expect(resolveRegionConfig(' tr '), resolveRegionConfig('TR'));
      });

      test('enlem yarımküreyi değiştirmez', () {
        expect(
          resolveRegionConfig('TR', latitude: -30).hemisphere,
          Hemisphere.northern,
        );
        expect(
          resolveRegionConfig('TR', latitude: 38.4),
          resolveRegionConfig('TR'),
        );
      });
    });

    group('diğer ülkeler', () {
      test('OTHER profili, TR modülleri kapalı', () {
        expect(
          resolveRegionConfig('DE'),
          const RegionConfig(
            countryCode: 'DE',
            profile: RegionProfile.other,
            features: RegionFeatures(),
            currencyCode: 'EUR',
            defaultUnits: DefaultUnits(),
            hemisphere: Hemisphere.northern,
          ),
        );
      });

      test('TR dışındaki her ülkede TR modülleri kapalı', () {
        // Türkiye'ye komşu ve Türkçe konuşulan ülkeler de dahil.
        for (final code in ['CY', 'AZ', 'BG', 'GR', 'US', 'AU', 'ZZ']) {
          final config = resolveRegionConfig(code);
          expect(config.profile, RegionProfile.other, reason: code);
          expect(config.features, const RegionFeatures(), reason: code);
        }
      });

      test('para birimi ülkeden gelir', () {
        const expected = {
          'US': 'USD',
          'GB': 'GBP',
          'AU': 'AUD',
          'NZ': 'NZD',
          'JP': 'JPY',
          'BR': 'BRL',
          'AZ': 'AZN',
          'BG': 'EUR',
          'CH': 'CHF',
          'ZA': 'ZAR',
        };
        for (final MapEntry(key: code, value: currency) in expected.entries) {
          expect(
            resolveRegionConfig(code).currencyCode,
            currency,
            reason: code,
          );
        }
      });

      test('küçük harfli kodda da para birimi bulunur', () {
        expect(resolveRegionConfig('gb').currencyCode, 'GBP');
      });

      test('tabloda olmayan ülkede USD', () {
        expect(resolveRegionConfig('AQ').currencyCode, 'USD');
        expect(resolveRegionConfig('ZZ').currencyCode, 'USD');
      });
    });

    group('varsayılan birimler', () {
      test('ABD, bağlı bölgeleri ve Liberya: lb, °F, galon', () {
        for (final code in ['US', 'PR', 'GU', 'VI', 'PW', 'LR']) {
          expect(
            resolveRegionConfig(code).defaultUnits,
            _usCustomary,
            reason: code,
          );
        }
      });

      test('Bahamalar, Belize, Cayman: yalnız sıcaklık °F', () {
        for (final code in ['BS', 'BZ', 'KY']) {
          expect(
            resolveRegionConfig(code).defaultUnits,
            const DefaultUnits(temperature: TemperatureUnit.fahrenheit),
            reason: code,
          );
        }
      });

      test('diğer ülkelerde metrik', () {
        for (final code in ['TR', 'GB', 'CA', 'DE', 'AU', 'MM', 'ZZ']) {
          expect(
            resolveRegionConfig(code).defaultUnits,
            const DefaultUnits(),
            reason: code,
          );
        }
      });

      test('küçük harfli kodda da ABD ölçüleri gelir', () {
        expect(resolveRegionConfig('us').defaultUnits, _usCustomary);
      });
    });

    group('yarımküre', () {
      test('enlem bilinmiyorsa Kuzey', () {
        expect(resolveRegionConfig('AU').hemisphere, Hemisphere.northern);
      });

      test('enlemden hesaplanır', () {
        expect(
          resolveRegionConfig('AU', latitude: -33.87).hemisphere,
          Hemisphere.southern,
        );
        expect(
          resolveRegionConfig('DE', latitude: 52.52).hemisphere,
          Hemisphere.northern,
        );
      });

      test('ekvatordaki ülkede arılığın konumuna göre değişir', () {
        // Brezilya: Boa Vista Kuzey'de, São Paulo Güney'de.
        expect(
          resolveRegionConfig('BR', latitude: 2.82).hemisphere,
          Hemisphere.northern,
        );
        expect(
          resolveRegionConfig('BR', latitude: -23.55).hemisphere,
          Hemisphere.southern,
        );
      });
    });

    group('geçersiz giriş', () {
      test('geçersiz ülke kodu ArgumentError', () {
        expect(() => resolveRegionConfig('TUR'), throwsArgumentError);
        expect(() => resolveRegionConfig(''), throwsArgumentError);
      });

      test('geçersiz enlem ArgumentError; TR profilinde de', () {
        expect(
          () => resolveRegionConfig('AU', latitude: -91),
          throwsArgumentError,
        );
        expect(
          () => resolveRegionConfig('TR', latitude: 120),
          throwsArgumentError,
        );
        expect(
          () => resolveRegionConfig('TR', latitude: double.nan),
          throwsArgumentError,
        );
      });
    });
  });
}
