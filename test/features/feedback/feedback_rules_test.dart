import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/feedback/domain/feedback_rules.dart';

void main() {
  group('feedbackMessage', () {
    test('baştaki ve sondaki boşluğu atar', () {
      expect(feedbackMessage('  Liste açılmıyor.\n'), 'Liste açılmıyor.');
    });

    test('boş ya da yalnız boşluksa null', () {
      expect(feedbackMessage(''), isNull);
      expect(feedbackMessage(' \n\t '), isNull);
    });

    test('sınırı aşan mesaj null; sınırdaki geçer', () {
      expect(feedbackMessage('a' * feedbackMessageMaxLength), isNotNull);
      expect(feedbackMessage('a' * (feedbackMessageMaxLength + 1)), isNull);
    });
  });

  test('ekran görüntüsü yolu işletme/kimlik.jpg', () {
    expect(feedbackScreenshotPath(orgId: 'org', id: 'fb'), 'org/fb.jpg');
  });

  test('cihaz bilgisi sürüm, platform, sistem, model ve dili taşır', () {
    expect(
      feedbackDeviceInfo((
        appVersion: '1.0.0+1',
        platform: 'ios',
        osVersion: 'iOS 18.1',
        model: 'iPhone15,2',
      ), locale: 'tr'),
      {
        'app_version': '1.0.0+1',
        'platform': 'ios',
        'os_version': 'iOS 18.1',
        'model': 'iPhone15,2',
        'locale': 'tr',
      },
    );
  });
}
