import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';

void main() {
  test('Storage yolu işletme/kovan/kimlik ve türün uzantısı', () {
    expect(
      mediaStoragePath(orgId: 'o', hiveId: 'h', id: 'm', kind: MediaKind.photo),
      'o/h/m.jpg',
    );
    expect(
      mediaStoragePath(orgId: 'o', hiveId: 'h', id: 'm', kind: MediaKind.audio),
      'o/h/m.m4a',
    );
    expect(MediaKind.photo.contentType, 'image/jpeg');
    expect(MediaKind.audio.contentType, 'audio/mp4');
  });

  group('sıkıştırmada kısa kenar', () {
    test('uzun kenar 1600 olacak şekilde, yön ne olursa olsun', () {
      // 4000x3000 → 1600x1200.
      expect(compressShortEdge(4000, 3000), 1200);
      expect(compressShortEdge(3000, 4000), 1200);
      // 16:9 → 1600x900.
      expect(compressShortEdge(4032, 2268), 900);
    });

    test('küçük görüntü büyütülmez', () {
      expect(compressShortEdge(1600, 1200), 1200);
      expect(compressShortEdge(800, 600), 600);
    });

    test('çok ince görüntüde kısa kenar en az 1', () {
      expect(compressShortEdge(100000, 10), 1);
    });
  });

  test('yükleme beklemesi 30 sn’den ikiye katlanır, en çok 6 saat', () {
    expect(uploadBackoff(1), const Duration(seconds: 30));
    expect(uploadBackoff(2), const Duration(minutes: 1));
    expect(uploadBackoff(5), const Duration(minutes: 8));
    expect(uploadBackoff(30), const Duration(hours: 6));
    expect(uploadBackoff(1000), const Duration(hours: 6));
  });

  test('sesli not süresi dakika:saniye', () {
    expect(formatVoiceDuration(const Duration(seconds: 7)), '0:07');
    expect(
      formatVoiceDuration(const Duration(minutes: 12, seconds: 30)),
      '12:30',
    );
    expect(formatVoiceDuration(const Duration(milliseconds: 999)), '0:00');
  });
}
