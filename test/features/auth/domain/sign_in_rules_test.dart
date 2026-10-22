import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';

void main() {
  group('normalizeEmail', () {
    test('boşlukları atar, küçük harfe çevirir', () {
      expect(normalizeEmail('  Ari@Example.COM \n'), 'ari@example.com');
    });
  });

  group('isValidEmail', () {
    test('olağan adresleri kabul eder', () {
      for (final email in [
        'ari@example.com',
        'ali.veli+kovan@posta.com.tr',
        'a@b.co',
      ]) {
        expect(isValidEmail(email), isTrue, reason: email);
      }
    });

    test('eksik ya da boşluklu adresleri reddeder', () {
      for (final email in [
        '',
        'ari',
        'ari@',
        '@example.com',
        'ari@example',
        'ari @example.com',
        'ari@@example.com',
      ]) {
        expect(isValidEmail(email), isFalse, reason: email);
      }
    });
  });

  group('extractOtpCode', () {
    test('yalnız rakamları alır ve 6 haneye kırpar', () {
      expect(extractOtpCode('12a3'), '123');
      expect(extractOtpCode('123 456'), '123456');
      expect(extractOtpCode('1234567'), '123456');
      expect(extractOtpCode('kod yok'), '');
    });

    test('metnin içindeki 6 haneli kodu bulur', () {
      expect(extractOtpCode('Kodun: 482913. 10 dakika geçerli.'), '482913');
      expect(extractOtpCode('Your code is 004211'), '004211');
    });

    test('daha uzun bir sayının parçasını kod sanmaz', () {
      expect(extractOtpCode('12345678 ve 654321'), '654321');
    });
  });

  group('otpInput', () {
    test('tek tek yazılan rakamlar eklenir, silme çalışır', () {
      expect(otpInput(previous: '12', next: '123'), '123');
      expect(otpInput(previous: '123', next: '12'), '12');
      expect(otpInput(previous: '12', next: '12x'), '12');
    });

    test('yapıştırılan tam kod yarım girişin yerine geçer', () {
      expect(otpInput(previous: '12', next: '12482913'), '482913');
      expect(otpInput(previous: '', next: 'Kodun: 482913'), '482913');
    });

    test('sistemin önerdiği kod tüm alanı değiştirince olduğu gibi alınır', () {
      expect(otpInput(previous: '48', next: '482913'), '482913');
    });

    test('6 haneden fazlası kırpılır', () {
      expect(otpInput(previous: '123456', next: '1234567'), '123456');
    });
  });
}
